// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import '../../api/order_service.dart';
// import '../../models/order.dart';

// class PaymentScreen extends StatefulWidget {
//   final String snapToken;
//   final Order order;

//   const PaymentScreen({
//     Key? key,
//     required this.snapToken,
//     required this.order,
//   }) : super(key: key);

//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   late InAppWebViewController _webViewController;
//   bool _isLoading = true;
//   bool _paymentCompleted = false;
//   bool _isVerifying = false;

//   bool _isValidPaymentCallback(String url) {
//     // Ganti dengan domain Anda yang sebenarnya
//     const allowedDomains = [
//       '192.168.19.213', // Hanya domain/IP tanpa http:// dan slash
//       'midtrans.com',
//       'simulator.sandbox.midtrans.com'
//     ];

//     final uri = Uri.tryParse(url);
//     if (uri == null) return false;

//     // Cek domain yang diizinkan
//     if (!allowedDomains.any((domain) => uri.host.contains(domain))) {
//       return false;
//     }

//     // Cek parameter callback pembayaran
//     return uri.queryParameters.containsKey('status_code') ||
//            uri.queryParameters.containsKey('transaction_status');
//   }

//   Future<void> _handleWebViewUrl(String? url) async {
//     if (url == null || !_isValidPaymentCallback(url)) return;

//     final uri = Uri.parse(url);
//     final status = uri.queryParameters['transaction_status'] ?? 
//                   uri.queryParameters['status_code'];

//     if (status == '200' || status == 'settlement' || status == 'capture') {
//       await _handlePaymentCompletion(); // Ganti dari _verifyPaymentWithServer()
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Payment #${widget.order.orderNumber}'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _verifyPaymentStatus,
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           InAppWebView(
//             initialUrlRequest: URLRequest(
//               url: WebUri('https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.snapToken}'),
//             ),
//             onWebViewCreated: (controller) {
//               _webViewController = controller;
//             },
//             onLoadStart: (controller, url) {
//               if (!mounted) return;
//               setState(() => _isLoading = true);
//               _handleWebViewUrl(url?.toString());
//             },
//             shouldOverrideUrlLoading: (controller, navigationAction) async {
//               final url = navigationAction.request.url?.toString();
//               if (url != null && _isValidPaymentCallback(url)) {
//                 await _handleWebViewUrl(url);
//                 return NavigationActionPolicy.CANCEL;
//               }
//               return NavigationActionPolicy.ALLOW;
//             },
//             onLoadStop: (controller, url) async {
//               if (!mounted) return;
//               setState(() => _isLoading = false);
//             },
//             onLoadError: (controller, url, code, message) {
//               if (!mounted) return;
//               setState(() => _isLoading = false);
//               Fluttertoast.showToast(msg: 'Payment error: $message');
//             },
//           ),
//           if (_isLoading)
//             const Center(
//               child: CircularProgressIndicator(),
//             ),
//           if (_paymentCompleted)
//             Positioned(
//               bottom: 20,
//               right: 20,
//               child: FloatingActionButton(
//                 onPressed: _returnToOrderDetail,
//                 child: const Icon(Icons.check),
//                 backgroundColor: Colors.green,
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Future<void> _handlePaymentCompletion() async {
//     if (!mounted) return;
//     setState(() => _isVerifying = true);
    
//     try {
//       final result = await OrderService.checkPaymentStatus(widget.order);
//       final isPaid = result['payment_status'] == 'paid';
      
//       if (!mounted) return;
//       setState(() {
//         _paymentCompleted = isPaid;
//         _isLoading = false;
//         _isVerifying = false;
//       });
      
//       if (isPaid) {
//         Fluttertoast.showToast(msg: 'Payment verified successfully');
//       } else {
//         Fluttertoast.showToast(msg: 'Payment not yet confirmed');
//       }
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _isVerifying = false);
//       Fluttertoast.showToast(msg: 'Verification failed: ${e.toString()}');
//     }
//   }

//   Future<void> _verifyPaymentStatus() async {
//     if (!mounted) return;
//     setState(() => _isVerifying = true);
    
//     try {
//       final result = await OrderService.checkPaymentStatus(widget.order);
//       final isPaid = result['payment_status'] == 'paid';
      
//       if (!mounted) return;
//       setState(() {
//         _paymentCompleted = isPaid;
//         _isVerifying = false;
//       });
      
//       if (isPaid) {
//         Fluttertoast.showToast(msg: 'Payment already confirmed');
//         _returnToOrderDetail();
//       } else {
//         Fluttertoast.showToast(msg: 'Payment not yet confirmed');
//       }
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _isVerifying = false);
//       Fluttertoast.showToast(msg: 'Failed to verify payment: ${e.toString()}');
//     }
//   }

//   Future<void> _returnToOrderDetail() async {
//     Navigator.of(context).pop(true);
//   }

//   @override
//   void dispose() {
//     _webViewController.stopLoading();
//     super.dispose();
//   }
// }

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
    const allowedDomains = [
      '192.168.19.213',
      'midtrans.com',
      'simulator.sandbox.midtrans.com'
    ];

    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    if (!allowedDomains.any((domain) => uri.host.contains(domain))) {
      return false;
    }

    return uri.queryParameters.containsKey('status_code') ||
           uri.queryParameters.containsKey('transaction_status');
  }

  Future<void> _handleWebViewUrl(String? url) async {
    if (url == null || !_isValidPaymentCallback(url)) return;

    final uri = Uri.parse(url);
    final status = uri.queryParameters['transaction_status'] ?? 
                  uri.queryParameters['status_code'];

    if (status == '200' || status == 'settlement' || status == 'capture') {
      await _handlePaymentCompletion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pembayaran #${widget.order.orderNumber}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF041562),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _verifyPaymentStatus,
            tooltip: 'Periksa Status',
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
              Fluttertoast.showToast(
                msg: 'Error pembayaran: $message',
                backgroundColor: const Color(0xFFDA1212),
                textColor: Colors.white,
              );
            },
          ),
          
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF041562),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Memuat halaman pembayaran...',
                    style: TextStyle(
                      color: Color(0xFF11468F),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          
          if (_isVerifying)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFF041562),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Memverifikasi pembayaran...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          if (_paymentCompleted)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _returnToOrderDetail,
                child: const Icon(Icons.check, size: 32),
                backgroundColor: const Color(0xFF4CAF50),
                elevation: 4,
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
        Fluttertoast.showToast(
          msg: 'Pembayaran berhasil diverifikasi',
          backgroundColor: const Color(0xFF4CAF50),
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Pembayaran belum dikonfirmasi',
          backgroundColor: const Color(0xFFFF9800),
          textColor: Colors.white,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isVerifying = false);
      Fluttertoast.showToast(
        msg: 'Gagal verifikasi: ${e.toString()}',
        backgroundColor: const Color(0xFFDA1212),
        textColor: Colors.white,
      );
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
        Fluttertoast.showToast(
          msg: 'Pembayaran sudah dikonfirmasi',
          backgroundColor: const Color(0xFF4CAF50),
          textColor: Colors.white,
        );
        _returnToOrderDetail();
      } else {
        Fluttertoast.showToast(
          msg: 'Pembayaran belum dikonfirmasi',
          backgroundColor: const Color(0xFFFF9800),
          textColor: Colors.white,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isVerifying = false);
      Fluttertoast.showToast(
        msg: 'Gagal memverifikasi pembayaran: ${e.toString()}',
        backgroundColor: const Color(0xFFDA1212),
        textColor: Colors.white,
      );
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