import 'package:cloud_firestore/cloud_firestore.dart';
import 'product.dart';

class WishlistItem {
  final String id;
  final String productId;
  final DateTime dateAdded;
  final Product? product;

  WishlistItem({
    required this.id,
    required this.productId,
    required this.dateAdded,
    this.product,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'dateAdded': Timestamp.fromDate(dateAdded),
      if (product != null) 'product': product!.toMap(),
    };
  }

  factory WishlistItem.fromMap(Map<String, dynamic> map) {
    return WishlistItem(
      id: map['id'] ?? '',
      productId: map['productId'] ?? '',
      dateAdded: (map['dateAdded'] as Timestamp).toDate(),
      product: map['product'] != null ? Product.fromMap(map['product']) : null,
    );
  }

  WishlistItem copyWith({
    String? id,
    String? productId,
    DateTime? dateAdded,
    Product? product,
  }) {
    return WishlistItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      dateAdded: dateAdded ?? this.dateAdded,
      product: product ?? this.product,
    );
  }
} 