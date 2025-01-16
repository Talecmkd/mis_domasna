import 'product.dart';

class Order {
  final String id;
  final List<Product> products;
  final double totalAmount;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.products,
    required this.totalAmount,
    required this.dateTime,
  });
}

// Sample orders data
List<Order> sampleOrders = [
  Order(
    id: '1',
    products: [sampleProducts[0], sampleProducts[1]],
    totalAmount: 44.98,
    dateTime: DateTime.now().subtract(Duration(days: 2)),
  ),
  Order(
    id: '2',
    products: [sampleProducts[2], sampleProducts[3]],
    totalAmount: 119.98,
    dateTime: DateTime.now().subtract(Duration(days: 5)),
  ),
];
