// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import '../../api/order_service.dart';
// import '../../models/order.dart';
// import 'payment_screen.dart';

// class OrderDetailScreen extends StatefulWidget {
//   final Order order;

//   const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

//   @override
//   _OrderDetailScreenState createState() => _OrderDetailScreenState();
// }

// class _OrderDetailScreenState extends State<OrderDetailScreen> {
//   late Order _order;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _order = widget.order;
//     _loadOrderDetails();
//   }

//   Future<void> _loadOrderDetails() async {
//     try {
//       final updatedOrder = await OrderService.getOrderDetails(_order.id);
//       setState(() {
//         _order = updatedOrder;
//       });
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Failed to load order details');
//     }
//   }

//   Future<void> _checkPaymentStatus() async {
//     setState(() => _isLoading = true);
//     try {
//       final result = await OrderService.checkPaymentStatus(_order);
//       setState(() {
//         _order = Order.fromJson(result['order']);
//       });
//       Fluttertoast.showToast(msg: 'Payment status updated');
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Failed to check payment status');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _proceedToPayment() async {
//     if (_order.isPaid) return;

//     setState(() => _isLoading = true);
//     try {
//       final result = await OrderService.createPayment(_order);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PaymentScreen(
//             snapToken: result['snap_token'],
//             order: _order,
//           ),
//         ),
//       );
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Failed to create payment');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'paid':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'failed':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order #${_order.orderNumber}'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Order Status',
//                           style: Theme.of(context).textTheme.titleMedium,
//                         ),
//                         Chip(
//                           backgroundColor: _getStatusColor(_order.paymentStatus),
//                           label: Text(
//                             _order.paymentStatus.toUpperCase(),
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text('Order Number: ${_order.orderNumber}'),
//                     Text('Date: ${_order.createdAt.toString().substring(0, 10)}'),
//                     Text('Total: ${_order.formattedTotalAmount}'),
//                     if (_order.paymentMethod != null)
//                       Text('Payment Method: ${_order.paymentMethod}'),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Items',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: _order.items.length,
//               itemBuilder: (context, index) {
//                 final item = _order.items[index];
//                 return Card(
//                   child: ListTile(
//                     leading: item.product.imageUrl != null
//                         ? Image.network(
//                             item.product.imageUrl!,
//                             width: 50,
//                             height: 50,
//                             fit: BoxFit.cover,
//                           )
//                         : const Icon(Icons.shopping_bag),
//                     title: Text(item.product.name),
//                     subtitle: Text('${item.quantity} x ${item.formattedPrice}'),
//                     trailing: Text(
//                       'Rp ${(item.quantity * item.price).toStringAsFixed(0).replaceAllMapped(
//                             RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
//                             (Match m) => '${m[1]}.',
//                           )}',
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 20),
//             if (!_order.isPaid)
//               Column(
//                 children: [
//                   ElevatedButton(
//                     onPressed: _isLoading ? null : _proceedToPayment,
//                     child: _isLoading
//                         ? const CircularProgressIndicator()
//                         : const Text('Proceed to Payment'),
//                   ),
//                   const SizedBox(height: 8),
//                   TextButton(
//                     onPressed: _isLoading ? null : _checkPaymentStatus,
//                     child: const Text('Check Payment Status'),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
      Fluttertoast.showToast(
        msg: 'Gagal memuat detail pesanan',
        backgroundColor: const Color(0xFFDA1212),
        textColor: Colors.white,
      );
    }
  }

  Future<void> _checkPaymentStatus() async {
    setState(() => _isLoading = true);
    try {
      final result = await OrderService.checkPaymentStatus(_order);
      setState(() {
        _order = Order.fromJson(result['order']);
      });
      Fluttertoast.showToast(
        msg: 'Status pembayaran diperbarui',
        backgroundColor: const Color(0xFF041562),
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Gagal memeriksa status pembayaran',
        backgroundColor: const Color(0xFFDA1212),
        textColor: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _proceedToPayment() async {
    if (_order.isPaid) return;

    setState(() => _isLoading = true);
    try {
      final result = await OrderService.createPayment(_order);
      if (!mounted) return;
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
      Fluttertoast.showToast(
        msg: 'Gagal membuat pembayaran',
        backgroundColor: const Color(0xFFDA1212),
        textColor: Colors.white,
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid':
        return const Color(0xFF4CAF50); // Green
      case 'pending':
        return const Color(0xFFFF9800); // Orange
      case 'failed':
        return const Color(0xFFDA1212); // Red
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pesanan #${_order.orderNumber}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF041562),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ringkasan Pesanan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF041562),
                          ),
                        ),
                        Chip(
                          backgroundColor: _getStatusColor(_order.paymentStatus),
                          label: Text(
                            _order.paymentStatus.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Nomor Pesanan', _order.orderNumber),
                    _buildDetailRow(
                      'Tanggal', 
                      _order.createdAt.toString().substring(0, 10),
                    ),
                    _buildDetailRow(
                      'Total', 
                      _order.formattedTotalAmount,
                      isBold: true,
                      valueColor: Color(0xFFDA1212),
                    ),
                    if (_order.paymentMethod != null)
                      _buildDetailRow(
                        'Metode Pembayaran', 
                        _order.paymentMethod!,
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Items List
            Text(
              'Produk yang Dipesan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF041562),
              ),
            ),
            
            const SizedBox(height: 8),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _order.items.length,
              itemBuilder: (context, index) {
                final item = _order.items[index];
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Product Image
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFFEEEEEE),
                          ),
                          child: item.product.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.product.imageUrl!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.shopping_bag,
                                  color: Color(0xFF11468F),
                                  size: 30,
                                ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Product Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF041562),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item.quantity} x ${item.formattedPrice}',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Subtotal
                        Text(
                          'Rp ${(item.quantity * item.price).toStringAsFixed(0).replaceAllMapped(
                                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                (Match m) => '${m[1]}.',
                              )}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDA1212),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // Payment Buttons
            if (!_order.isPaid)
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF041562),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isLoading ? null : _proceedToPayment,
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'LANJUT KE PEMBAYARAN',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  TextButton(
                    onPressed: _isLoading ? null : _checkPaymentStatus,
                    child: Text(
                      'PERIKSA STATUS PEMBAYARAN',
                      style: TextStyle(
                        color: Color(0xFF11468F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, 
      {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: valueColor ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}