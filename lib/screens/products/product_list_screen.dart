// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../api/api_service.dart';
// import '../../models/product.dart';
// import '../../providers/auth_provider.dart';
// import 'package:iot_client_app/api/order_service.dart';
// import '../orders/order_detail_screen.dart';

// class ProductListScreen extends StatefulWidget {
//   const ProductListScreen({Key? key}) : super(key: key);

//   @override
//   _ProductListScreenState createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends State<ProductListScreen> {
//   late Future<List<Product>> _productsFuture;
//   bool _isLoading = false;
//   final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

//   @override
//   void initState() {
//     super.initState();
//     _productsFuture = ApiService.getProducts();
//   }

//   Future<void> _refreshProducts() async {
//     setState(() {
//       _productsFuture = ApiService.getProducts();
//     });
//   }

//   // Future<void> _logout() async {
//   //   if (!mounted) return;
//   //   setState(() => _isLoading = true);
//   //   await Provider.of<AuthProvider>(context, listen: false).logout();
//   //   if (!mounted) return;
//   //   Navigator.pushReplacementNamed(context, '/login');
//   // }

//   void _showPurchaseDialog(BuildContext context, Product product) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Purchase Product'),
//         content: Text('Are you sure you want to purchase ${product.name} for ${product.formattedPrice}?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await _purchaseProduct(product);
//             },
//             child: const Text('Purchase'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _purchaseProduct(Product product) async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);
    
//     try {
//       final order = await OrderService.createOrder(product);
//       if (!mounted) return;
      
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => OrderDetailScreen(order: order),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to create order: ${e.toString()}')),
//       );
//     } finally {
//       if (!mounted) return;
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldMessengerKey,
//       appBar: AppBar(
//         title: const Text('Produk'),
//         actions: [
//           // IconButton(
//           //   icon: const Icon(Icons.logout),
//           //   onPressed: _isLoading ? null : _logout,
//           // ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshProducts,
//         child: FutureBuilder<List<Product>>(
//           future: _productsFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('No products available'));
//             } else {
//               return ListView.builder(
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   final product = snapshot.data![index];
//                   return Card(
//                     child: ListTile(
//                       leading: product.imageUrl != null
//                           ? ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.network(
//                                 product.imageUrl!,
//                                 width: 50,
//                                 height: 50,
//                                 fit: BoxFit.cover,
//                                 loadingBuilder: (
//                                   context,
//                                   child,
//                                   loadingProgress,
//                                 ) {
//                                   if (loadingProgress == null) return child;
//                                   return SizedBox(
//                                     width: 50,
//                                     height: 50,
//                                     child: Center(
//                                       child: CircularProgressIndicator(
//                                         value: loadingProgress.expectedTotalBytes != null
//                                             ? loadingProgress.cumulativeBytesLoaded /
//                                                 loadingProgress.expectedTotalBytes!
//                                             : null,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 errorBuilder: (context, error, stackTrace) => Container(
//                                   width: 50,
//                                   height: 50,
//                                   color: Colors.grey[200],
//                                   child: const Icon(Icons.devices, size: 30),
//                                 ),
//                               ),
//                             )
//                           : Container(
//                               width: 50,
//                               height: 50,
//                               color: Colors.grey[200],
//                               child: const Icon(Icons.devices, size: 30),
//                             ),
//                       title: Text(product.name),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(product.description),
//                           const SizedBox(height: 4),
//                           Text('Price: ${product.formattedPrice}'),
//                           // Text('Stock: ${product.availableStock}'),
//                         ],
//                       ),
//                       onTap: () {
//                         _showPurchaseDialog(context, product);
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
import '../../api/api_service.dart';
import '../../models/product.dart';
import '../../providers/auth_provider.dart';
import 'package:iot_client_app/api/order_service.dart';
import '../orders/order_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productsFuture;
  bool _isLoading = false;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = 
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _productsFuture = ApiService.getProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _productsFuture = ApiService.getProducts();
    });
  }

  void _showPurchaseDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Beli Produk',
          style: TextStyle(
            color: Color(0xFF041562),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Anda yakin ingin membeli ${product.name} seharga ${product.formattedPrice}?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Color(0xFF11468F)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFDA1212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await _purchaseProduct(product);
            },
            child: const Text('Beli Sekarang', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          ),
        ],
      ),
    );
  }

  Future<void> _purchaseProduct(Product product) async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      final order = await OrderService.createOrder(product);
      if (!mounted) return;
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailScreen(order: order),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat pesanan: ${e.toString()}'),
          backgroundColor: Color(0xFFDA1212),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        title: const Text('Daftar Produk'),
      ),
      body: RefreshIndicator(
        color: Color(0xFF041562),
        onRefresh: _refreshProducts,
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFF041562),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Memuat produk...',
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
                    SizedBox(height: 16),
                    Text(
                      'Gagal memuat produk',
                      style: TextStyle(
                        color: Color(0xFF041562),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Silakan coba lagi',
                      style: TextStyle(color: Color(0xFF11468F)),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF041562),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _refreshProducts,
                      child: Text('Muat Ulang'),
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
                      Icons.shopping_bag_outlined,
                      color: Color(0xFF11468F),
                      size: 48,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Tidak ada produk tersedia',
                      style: TextStyle(
                        color: Color(0xFF041562),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _showPurchaseDialog(context, product),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Product Image
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xFFEEEEEE),
                                ),
                                child: product.imageUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          product.imageUrl!,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                        loadingProgress.expectedTotalBytes!
                                                    : null,
                                                color: Color(0xFF041562),
                                              ),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) => 
                                              Icon(Icons.broken_image, color: Color(0xFF11468F)),
                                        ),
                                      )
                                    : Icon(
                                        Icons.shopping_bag,
                                        color: Color(0xFF11468F),
                                        size: 40,
                                      ),
                              ),
                              SizedBox(width: 16),
                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                        color: Color(0xFF041562),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      product.description,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      product.formattedPrice,
                                      style: TextStyle(
                                        color: Color(0xFFDA1212),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
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