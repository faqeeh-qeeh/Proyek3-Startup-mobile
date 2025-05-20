import 'order_item.dart';
// class Order {
//   final int id;
//   final String orderNumber;
//   final double totalAmount;
//   final String status;
//   final String paymentStatus;
//   final String? paymentMethod;
//   final String? midtransTransactionId;
//   final DateTime createdAt;
//   final List<OrderItem> items;

//   Order({
//     required this.id,
//     required this.orderNumber,
//     required this.totalAmount,
//     required this.status,
//     required this.paymentStatus,
//     this.paymentMethod,
//     this.midtransTransactionId,
//     required this.createdAt,
//     required this.items,
//   });

//   factory Order.fromJson(Map<String, dynamic> json) {
//     return Order(
//       id: json['id'],
//       orderNumber: json['order_number'],
//       totalAmount: double.parse(json['total_amount'].toString()),
//       status: json['status'],
//       paymentStatus: json['payment_status'],
//       paymentMethod: json['payment_method'],
//       midtransTransactionId: json['midtrans_transaction_id'],
//       createdAt: DateTime.parse(json['created_at']),
//       items: (json['items'] as List)
//           .map((item) => OrderItem.fromJson(item))
//           .toList(),
//     );
//   }

//   String get formattedTotalAmount {
//     return 'Rp ${totalAmount.toStringAsFixed(0).replaceAllMapped(
//           RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
//           (Match m) => '${m[1]}.',
//         )}';
//   }

//   bool get isPaid => paymentStatus == 'paid';
//   bool get isPending => paymentStatus == 'pending';
//   bool get isFailed => paymentStatus == 'failed';
// }

class Order {
  final int id;
  final int clientId;
  final String orderNumber;
  final double totalAmount;
  final String status;
  final String paymentStatus;
  final String? paymentMethod;
  final String? midtransTransactionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.clientId,
    required this.orderNumber,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    this.paymentMethod,
    this.midtransTransactionId,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      clientId: json['client_id'],
      orderNumber: json['order_number'],
      totalAmount: json['total_amount'] is String
          ? double.parse(json['total_amount'])
          : json['total_amount'].toDouble(),
      status: json['status'],
      paymentStatus: json['payment_status'],
      paymentMethod: json['payment_method'],
      midtransTransactionId: json['midtrans_transaction_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      items: json['items'] != null 
          ? (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList()
          : [], // Handle jika items null
    );
  }

  String get formattedTotalAmount {
    return 'Rp ${totalAmount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  bool get isPaid => paymentStatus == 'paid';
  bool get isPending => paymentStatus == 'pending';
  bool get isFailed => paymentStatus == 'failed';
}