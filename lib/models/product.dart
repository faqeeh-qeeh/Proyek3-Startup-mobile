import '../utils/constants.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String? image;
  final int availableStock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
    required this.availableStock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price:
          json['price'] is String
              ? double.parse(json['price'])
              : json['price'].toDouble(),
      image: json['image'],
      availableStock: json['available_stock'] ?? 0,
    );
  }

  String get formattedPrice {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String? get imageUrl {
    if (image == null || image!.isEmpty) return null;
    return Constants.imageUrl(image);
  }
}
