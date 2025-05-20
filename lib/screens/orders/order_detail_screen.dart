import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../api/order_service.dart';
import '../../models/order.dart';
import 'payment_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Order _order;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    try {
      final updatedOrder = await OrderService.getOrderDetails(_order.id);
      setState(() {
        _order = updatedOrder;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to load order details');
    }
  }

  Future<void> _checkPaymentStatus() async {
    setState(() => _isLoading = true);
    try {
      final result = await OrderService.checkPaymentStatus(_order);
      setState(() {
        _order = Order.fromJson(result['order']);
      });
      Fluttertoast.showToast(msg: 'Payment status updated');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to check payment status');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _proceedToPayment() async {
    if (_order.isPaid) return;

    setState(() => _isLoading = true);
    try {
      final result = await OrderService.createPayment(_order);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            snapToken: result['snap_token'],
            order: _order,
          ),
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to create payment');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${_order.orderNumber}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Status',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Chip(
                          backgroundColor: _getStatusColor(_order.paymentStatus),
                          label: Text(
                            _order.paymentStatus.toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Order Number: ${_order.orderNumber}'),
                    Text('Date: ${_order.createdAt.toString().substring(0, 10)}'),
                    Text('Total: ${_order.formattedTotalAmount}'),
                    if (_order.paymentMethod != null)
                      Text('Payment Method: ${_order.paymentMethod}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Items',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _order.items.length,
              itemBuilder: (context, index) {
                final item = _order.items[index];
                return Card(
                  child: ListTile(
                    leading: item.product.imageUrl != null
                        ? Image.network(
                            item.product.imageUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.shopping_bag),
                    title: Text(item.product.name),
                    subtitle: Text('${item.quantity} x ${item.formattedPrice}'),
                    trailing: Text(
                      'Rp ${(item.quantity * item.price).toStringAsFixed(0).replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]}.',
                          )}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            if (!_order.isPaid)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _proceedToPayment,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Proceed to Payment'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _isLoading ? null : _checkPaymentStatus,
                    child: const Text('Check Payment Status'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}