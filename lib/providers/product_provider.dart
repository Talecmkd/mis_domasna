import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = sampleProducts;

  List<Product> get products => [..._products];

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  void updateProductRating(String productId, double rating) {
    final productIndex = _products.indexWhere((product) => product.id == productId);
    if (productIndex >= 0) {
      // In a real app, this would be persisted to a backend
      final product = _products[productIndex];
      final updatedProduct = Product(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        category: product.category,
        isFeatured: product.isFeatured,
        rating: rating,
      );
      _products[productIndex] = updatedProduct;
      notifyListeners();
    }
  }
} 