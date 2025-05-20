import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../api/order_service.dart';
import '../../models/order.dart';

class PaymentScreen extends StatefulWidget {
  final String snapToken;
  final Order order;

  const PaymentScreen({
    Key? key,
    required this.snapToken,
    required this.order,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late InAppWebViewController _webViewController;
  bool _isLoading = true;
  bool _paymentCompleted = false;
  bool _isVerifying = false;

  bool _isValidPaymentCallback(String url) {
    // Ganti dengan domain Anda yang sebenarnya
    const allowedDomains = [
      '192.168.19.213', // Hanya domain/IP tanpa http:// dan slash
      'midtrans.com',
      'simulator.sandbox.midtrans.com'
    ];

    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    // Cek domain yang diizinkan
    if (!allowedDomains.any((domain) => uri.host.contains(domain))) {
      return false;
    }

    // Cek parameter callback pembayaran
    return uri.queryParameters.containsKey('status_code') ||
           uri.queryParameters.containsKey('transaction_status');
  }

  Future<void> _handleWebViewUrl(String? url) async {
    if (url == null || !_isValidPaymentCallback(url)) return;

    final uri = Uri.parse(url);
    final status = uri.queryParameters['transaction_status'] ?? 
                  uri.queryParameters['status_code'];

    if (status == '200' || status == 'settlement' || status == 'capture') {
      await _handlePaymentCompletion(); // Ganti dari _verifyPaymentWithServer()
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment #${widget.order.orderNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _verifyPaymentStatus,
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri('https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.snapToken}'),
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, url) {
              if (!mounted) return;
              setState(() => _isLoading = true);
              _handleWebViewUrl(url?.toString());
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url?.toString();
              if (url != null && _isValidPaymentCallback(url)) {
                await _handleWebViewUrl(url);
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },
            onLoadStop: (controller, url) async {
              if (!mounted) return;
              setState(() => _isLoading = false);
            },
            onLoadError: (controller, url, code, message) {
              if (!mounted) return;
              setState(() => _isLoading = false);
              Fluttertoast.showToast(msg: 'Payment error: $message');
            },
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (_paymentCompleted)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _returnToOrderDetail,
                child: const Icon(Icons.check),
                backgroundColor: Colors.green,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handlePaymentCompletion() async {
    if (!mounted) return;
    setState(() => _isVerifying = true);
    
    try {
      final result = await OrderService.checkPaymentStatus(widget.order);
      final isPaid = result['payment_status'] == 'paid';
      
      if (!mounted) return;
      setState(() {
        _paymentCompleted = isPaid;
        _isLoading = false;
        _isVerifying = false;
      });
      
      if (isPaid) {
        Fluttertoast.showToast(msg: 'Payment verified successfully');
      } else {
        Fluttertoast.showToast(msg: 'Payment not yet confirmed');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isVerifying = false);
      Fluttertoast.showToast(msg: 'Verification failed: ${e.toString()}');
    }
  }

  Future<void> _verifyPaymentStatus() async {
    if (!mounted) return;
    setState(() => _isVerifying = true);
    
    try {
      final result = await OrderService.checkPaymentStatus(widget.order);
      final isPaid = result['payment_status'] == 'paid';
      
      if (!mounted) return;
      setState(() {
        _paymentCompleted = isPaid;
        _isVerifying = false;
      });
      
      if (isPaid) {
        Fluttertoast.showToast(msg: 'Payment already confirmed');
        _returnToOrderDetail();
      } else {
        Fluttertoast.showToast(msg: 'Payment not yet confirmed');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isVerifying = false);
      Fluttertoast.showToast(msg: 'Failed to verify payment: ${e.toString()}');
    }
  }

  Future<void> _returnToOrderDetail() async {
    Navigator.of(context).pop(true);
  }

  @override
  void dispose() {
    _webViewController.stopLoading();
    super.dispose();
  }
}