import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/api_service.dart';
import '../../models/product.dart';
import '../../providers/auth_provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productsFuture;
  bool _isLoading = false;

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

  Future<void> _logout() async {
    setState(() => _isLoading = true);
    await Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _isLoading ? null : _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No products available'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final product = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      // Di bagian ListTile
                      leading:
                          product.imageUrl != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.imageUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.devices,
                                          size: 30,
                                        ),
                                      ),
                                ),
                              )
                              : Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[200],
                                child: const Icon(Icons.devices, size: 30),
                              ),
                      title: Text(product.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.description),
                          const SizedBox(height: 4),
                          Text('Price: ${product.formattedPrice}'),
                          Text('Stock: ${product.availableStock}'),
                        ],
                      ),
                      onTap: () {
                        // Navigate to product detail
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
