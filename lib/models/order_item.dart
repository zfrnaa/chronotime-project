import 'package:chrono_time/models/bag_item.dart';

class Order {
  final String id;
  final List<BagItem> items;
  final String watchName;
  final String imageUrl;
  final double totalPrice;
  final DateTime orderDate;
  final String quantity;
  late String status;
  final DateTime estimatedDelivery;

  Order({
    required this.id,
    required this.items,
    required this.watchName,
    required this.imageUrl,
    required this.totalPrice,
    required this.orderDate,
    required this.quantity,
    required this.status,
    required this.estimatedDelivery,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'watchName': watchName,
      'imageUrl': imageUrl,
      'totalPrice': totalPrice,
      'orderDate': orderDate.toIso8601String(),
      'quantity': quantity,
      'status': status,
      'estimatedDelivery': estimatedDelivery.toIso8601String(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      items: [], // You need to handle this based on your requirements
      watchName: map['watchName'],
      imageUrl: map['imageUrl'],
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      orderDate: DateTime.parse(map['orderDate']),
      quantity: map['quantity'],
      status: map['status'],
      estimatedDelivery: DateTime.parse(map['estimatedDelivery']),
    );
  }
}