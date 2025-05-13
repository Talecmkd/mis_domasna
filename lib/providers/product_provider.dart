import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => [..._products];
  bool get isLoading => _isLoading;

  // Initialize products stream
  void initializeProducts() {
    _firestoreService.getProducts().listen(
      (updatedProducts) {
        _products = updatedProducts;
        notifyListeners();
      },
      onError: (error) {
        print('Error in products stream: $error');
      },
    );
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Check if the current user has rated a product
  bool hasUserRatedProduct(String productId) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return false;
    
    final product = getProductById(productId);
    return product?.hasUserRated(userId) ?? false;
  }

  // Get the current user's rating for a product
  double? getUserRating(String productId) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return null;
    
    final product = getProductById(productId);
    return product?.getUserRating(userId);
  }

  Future<void> updateProductRating(String productId, double rating) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User must be logged in to rate products');
      }

      _isLoading = true;
      notifyListeners();

      // Update rating in Firebase
      await _firestoreService.updateProductRating(productId, rating);

      // The product will be automatically updated through the stream
      // No need to manually update the local state

    } catch (e) {
      print('Error updating product rating: $e');
      throw Exception('Failed to update product rating: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 