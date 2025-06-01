// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../api/order_service.dart';
// import '../../models/order.dart';
// import '../../providers/auth_provider.dart';
// import 'order_detail_screen.dart';

// class OrderListScreen extends StatefulWidget {
//   const OrderListScreen({Key? key}) : super(key: key);

//   @override
//   _OrderListScreenState createState() => _OrderListScreenState();
// }

// class _OrderListScreenState extends State<OrderListScreen> {
//   late Future<List<Order>> _ordersFuture;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _ordersFuture = OrderService.getOrders();
//   }

//   Future<void> _refreshOrders() async {
//     setState(() {
//       _ordersFuture = OrderService.getOrders();
//     });
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
//         title: const Text('My Orders'),
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshOrders,
//         child: FutureBuilder<List<Order>>(
//           future: _ordersFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('No orders yet'));
//             } else {
//               return ListView.builder(
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   final order = snapshot.data![index];
//                   return Card(
//                     margin: const EdgeInsets.all(8),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: _getStatusColor(order.paymentStatus),
//                         child: Text(
//                           order.orderNumber.substring(0, 2),
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       title: Text(order.orderNumber),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Total: ${order.formattedTotalAmount}'),
//                           Text('Status: ${order.paymentStatus.toUpperCase()}'),
//                           Text(
//                             'Date: ${order.createdAt.toString().substring(0, 10)}',
//                           ),
//                         ],
//                       ),
//                       trailing: const Icon(Icons.chevron_right),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => OrderDetailScreen(order: order),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/order_service.dart';
import '../../models/order.dart';
import '../../providers/auth_provider.dart';
import 'order_detail_screen.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late Future<List<Order>> _ordersFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _ordersFuture = OrderService.getOrders();
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _ordersFuture = OrderService.getOrders();
    });
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
        title: const Text(
          'Daftar Pesanan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF041562),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF041562),
        onRefresh: _refreshOrders,
        child: FutureBuilder<List<Order>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Color(0xFF041562),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Memuat pesanan...',
                      style: TextStyle(
                        color: Color(0xFF11468F),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Color(0xFFDA1212),
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat pesanan',
                      style: TextStyle(
                        color: Color(0xFF041562),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF041562),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _refreshOrders,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      color: Color(0xFF11468F),
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada pesanan',
                      style: TextStyle(
                        color: Color(0xFF041562),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pesanan Anda akan muncul di sini',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final order = snapshot.data![index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailScreen(order: order),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Status Indicator
                              Container(
                                width: 8,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: _getStatusColor(order.paymentStatus),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 16),
                              
                              // Order Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Pesanan #${order.orderNumber}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF041562),
                                            fontSize: 16,
                                          ),
                                        ),
                                        Chip(
                                          backgroundColor: _getStatusColor(order.paymentStatus)
                                              .withOpacity(0.2),
                                          label: Text(
                                            order.paymentStatus.toUpperCase(),
                                            style: TextStyle(
                                              color: _getStatusColor(order.paymentStatus),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tanggal: ${order.createdAt.toString().substring(0, 10)}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Total: ${order.formattedTotalAmount}',
                                      style: TextStyle(
                                        color: Color(0xFFDA1212),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Color(0xFF11468F),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}