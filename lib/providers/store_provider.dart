import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/pet_service.dart';
import '../models/wishlist.dart';
import '../services/firestore_service.dart';
import 'package:flutter/foundation.dart';

class StoreProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Product> _products = [];
  List<Product> _featuredProducts = [];
  List<PetService> _services = [];
  List<WishlistItem> _wishlistItems = [];
  List<Product> _wishlistProducts = [];
  String? _selectedCategory;
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  List<Product> get featuredProducts => _featuredProducts;
  List<PetService> get services => _services;
  List<WishlistItem> get wishlistItems => _wishlistItems;
  List<Product> get wishlistProducts => _wishlistProducts;
  String? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize the store data
  Future<void> initializeStore() async {
    try {
      print('Starting store initialization...');
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Initialize sample data if needed
      await _firestoreService.initializeSampleData();
      print('Sample data initialized successfully');
      
      // Listen to products stream
      _firestoreService.getProducts().listen(
        (products) {
          print('Received ${products.length} products from stream');
          _products = products;
          notifyListeners();
        },
        onError: (error) {
          print('Error in products stream: $error');
          _error = 'Error loading products: $error';
          notifyListeners();
        },
      );

      // Listen to featured products stream
      _firestoreService.getFeaturedProducts().listen(
        (featuredProducts) {
          print('Received ${featuredProducts.length} featured products from stream');
          _featuredProducts = featuredProducts;
          notifyListeners();
        },
        onError: (error) {
          print('Error in featured products stream: $error');
          _error = 'Error loading featured products: $error';
          notifyListeners();
        },
      );

      // Listen to services stream
      _firestoreService.getServices().listen(
        (services) {
          print('Received ${services.length} services from stream');
          _services = services;
          notifyListeners();
        },
        onError: (error) {
          print('Error in services stream: $error');
          _error = 'Error loading services: $error';
          notifyListeners();
        },
      );

      // Listen to wishlist stream
      _firestoreService.getWishlistItems().listen(
        (wishlistItems) async {
          print('Received ${wishlistItems.length} wishlist items from stream');
          _wishlistItems = wishlistItems;
          // Get the actual products for wishlist items
          if (wishlistItems.isNotEmpty) {
            try {
              _wishlistProducts = await _firestoreService.getWishlistProducts(
                wishlistItems.map((item) => item.productId).toList(),
              );
              print('Loaded ${_wishlistProducts.length} wishlist products');
            } catch (e) {
              print('Error loading wishlist products: $e');
              _error = 'Error loading wishlist products: $e';
            }
          } else {
            _wishlistProducts = [];
          }
          notifyListeners();
        },
        onError: (error) {
          print('Error in wishlist stream: $error');
          _error = 'Error loading wishlist: $error';
          notifyListeners();
        },
      );

      _isLoading = false;
      notifyListeners();
      print('Store initialization completed');
    } catch (e) {
      print('Error during store initialization: $e');
      _error = 'Failed to initialize store: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Wishlist Operations
  Future<void> addToWishlist(Product product) async {
    try {
      await _firestoreService.addToWishlist(product);
      // Update local state
      final newItem = WishlistItem(
        id: product.id,
        productId: product.id,
        dateAdded: DateTime.now(),
        product: product,
      );
      _wishlistItems = [..._wishlistItems, newItem];
      _wishlistProducts = [..._wishlistProducts, product];
      notifyListeners();
    } catch (e) {
      _error = 'Error adding to wishlist: $e';
      notifyListeners();
      throw e;
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      await _firestoreService.removeFromWishlist(productId);
      // Update local state
      _wishlistItems.removeWhere((item) => item.id == productId);
      _wishlistProducts.removeWhere((product) => product.id == productId);
      notifyListeners();
    } catch (e) {
      _error = 'Error removing from wishlist: $e';
      notifyListeners();
      throw e;
    }
  }

  bool isInWishlist(String productId) {
    return _wishlistItems.any((item) => item.productId == productId);
  }

  String? getWishlistItemId(String productId) {
    final item = _wishlistItems.firstWhere(
      (item) => item.productId == productId,
      orElse: () => WishlistItem(id: '', productId: '', dateAdded: DateTime.now()),
    );
    return item.id.isEmpty ? null : item.id;
  }

  // Set selected category
  void setSelectedCategory(String? category) {
    try {
      print('Setting category to: $category');
      _selectedCategory = category;
      if (category != null) {
        _firestoreService.getProductsByCategory(category).listen(
          (products) {
            print('Received ${products.length} products for category $category');
            _products = products;
            notifyListeners();
          },
          onError: (error) {
            print('Error loading products for category $category: $error');
            _error = 'Error loading category products: $error';
            notifyListeners();
          },
        );
      } else {
        _firestoreService.getProducts().listen(
          (products) {
            print('Received ${products.length} products (all categories)');
            _products = products;
            notifyListeners();
          },
          onError: (error) {
            print('Error loading all products: $error');
            _error = 'Error loading products: $error';
            notifyListeners();
          },
        );
      }
    } catch (e) {
      print('Error setting category: $e');
      _error = 'Error changing category: $e';
      notifyListeners();
    }
  }

  // Get products by category
  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  // Get unique categories
  List<String> get categories {
    return _products.map((product) => product.category).toSet().toList();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 