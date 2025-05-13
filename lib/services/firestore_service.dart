import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/pet_service.dart';
import '../models/wishlist.dart';
import '../models/cart.dart';
import '../models/order.dart' as app_order;
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID or throw error
  String _getCurrentUserId() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
  }

  // Get user-specific collection reference
  CollectionReference<Map<String, dynamic>> _getUserCollection(String collection) {
    return _firestore
        .collection('users')
        .doc(_getCurrentUserId())
        .collection(collection)
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snapshot, _) => snapshot.data()!,
          toFirestore: (data, _) => data,
        );
  }

  // Products Collection Reference
  CollectionReference<Map<String, dynamic>> get _productsCollection =>
      _firestore.collection('products');

  // Services Collection Reference
  CollectionReference<Map<String, dynamic>> get _servicesCollection =>
      _firestore.collection('services');

  // Wishlist Collection Reference
  CollectionReference<Map<String, dynamic>> get _wishlistCollection =>
      _getUserCollection('wishlist');

  // Cart Collection Reference
  CollectionReference<Map<String, dynamic>> get _cartCollection =>
      _getUserCollection('cart');

  // Orders Collection Reference
  CollectionReference<Map<String, dynamic>> get _ordersCollection =>
      _getUserCollection('orders');

  // Initialize sample data
  Future<void> initializeSampleData() async {
    try {
      print('Starting to initialize sample data...');
      
      // Check if products collection is empty
      final productsSnapshot = await _productsCollection.get();
      if (productsSnapshot.docs.isEmpty) {
        print('Products collection is empty, adding sample products...');
        // Add sample products
        for (var product in sampleProducts) {
          print('Adding product: ${product.name}');
          await _productsCollection.doc(product.id).set(product.toMap());
        }
      } else {
        print('Products collection already has ${productsSnapshot.docs.length} documents');
      }

      // Check if services collection is empty
      final servicesSnapshot = await _servicesCollection.get();
      if (servicesSnapshot.docs.isEmpty) {
        print('Services collection is empty, adding sample services...');
        // Add sample services
        for (var service in sampleServices) {
          print('Adding service: ${service.name}');
          await _servicesCollection.doc(service.id).set({
            'id': service.id,
            'name': service.name,
            'icon': service.icon.codePoint,
            'description': service.description,
            'price': service.price,
            'imageUrl': service.imageUrl,
            'duration': service.duration,
          });
        }
      } else {
        print('Services collection already has ${servicesSnapshot.docs.length} documents');
      }
      
      print('Sample data initialization completed successfully');
    } catch (e) {
      print('Error initializing sample data: $e');
      throw Exception('Failed to initialize sample data: $e');
    }
  }

  // Get all products
  Stream<List<Product>> getProducts() {
    try {
      print('Getting products stream...');
      return _productsCollection.snapshots().map((snapshot) {
        print('Received ${snapshot.docs.length} products');
        return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
      });
    } catch (e) {
      print('Error getting products: $e');
      rethrow;
    }
  }

  // Get featured products
  Stream<List<Product>> getFeaturedProducts() {
    try {
      print('Getting featured products stream...');
      return _productsCollection
          .where('isFeatured', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        print('Received ${snapshot.docs.length} featured products');
        return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
      });
    } catch (e) {
      print('Error getting featured products: $e');
      rethrow;
    }
  }

  // Get products by category
  Stream<List<Product>> getProductsByCategory(String category) {
    try {
      print('Getting products stream for category: $category');
      return _productsCollection
          .where('category', isEqualTo: category)
          .snapshots()
          .map((snapshot) {
        print('Received ${snapshot.docs.length} products for category $category');
        return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
      });
    } catch (e) {
      print('Error getting products by category: $e');
      rethrow;
    }
  }

  // Get all services
  Stream<List<PetService>> getServices() {
    try {
      print('Getting services stream...');
      return _servicesCollection.snapshots().map((snapshot) {
        print('Received ${snapshot.docs.length} services');
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return PetService(
            id: data['id'],
            name: data['name'],
            icon: IconData(data['icon'], fontFamily: 'MaterialIcons'),
            description: data['description'],
            price: data['price'].toDouble(),
            imageUrl: data['imageUrl'],
            duration: data['duration'],
          );
        }).toList();
      });
    } catch (e) {
      print('Error getting services: $e');
      rethrow;
    }
  }

  // Cart Operations
  Future<void> addToCart(Product product) async {
    try {
      await _getUserCollection('cart').doc(product.id).set(product.toMap());
    } catch (e) {
      print('Error adding to cart: $e');
      throw Exception('Failed to add to cart: $e');
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      await _getUserCollection('cart').doc(productId).delete();
    } catch (e) {
      print('Error removing from cart: $e');
      throw Exception('Failed to remove from cart: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      final cartRef = _getUserCollection('cart');
      final cartDocs = await cartRef.get();
      
      final batch = _firestore.batch();
      for (var doc in cartDocs.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      print('Error clearing cart: $e');
      throw Exception('Failed to clear cart: $e');
    }
  }

  // Wishlist Operations
  Future<void> addToWishlist(Product product) async {
    try {
      print('Adding product ${product.id} to wishlist...');
      final wishlistItem = WishlistItem(
        id: product.id,
        productId: product.id,
        dateAdded: DateTime.now(),
        product: product,
      );
      await _getUserCollection('wishlist').doc(product.id).set(wishlistItem.toMap());
      print('Successfully added product to wishlist');
    } catch (e) {
      print('Error adding to wishlist: $e');
      throw Exception('Failed to add to wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      print('Removing item $productId from wishlist...');
      await _getUserCollection('wishlist').doc(productId).delete();
      print('Successfully removed item from wishlist');
    } catch (e) {
      print('Error removing from wishlist: $e');
      throw Exception('Failed to remove from wishlist: $e');
    }
  }

  Stream<List<WishlistItem>> getWishlistItems() {
    try {
      print('Getting wishlist stream...');
      return _wishlistCollection
          .orderBy('dateAdded', descending: true)
          .snapshots()
          .map((snapshot) {
        print('Received ${snapshot.docs.length} wishlist items');
        return snapshot.docs.map((doc) {
          final data = doc.data();
          // Ensure the document ID is included in the data
          data['id'] = doc.id;
          return WishlistItem.fromMap(data);
        }).toList();
      });
    } catch (e) {
      print('Error getting wishlist: $e');
      rethrow;
    }
  }

  Future<List<Product>> getWishlistProducts(List<String> productIds) async {
    try {
      print('Getting products for wishlist...');
      final products = await Future.wait(
        productIds.map((id) => _productsCollection.doc(id).get()),
      );
      return products
          .where((doc) => doc.exists)
          .map((doc) => Product.fromMap(doc.data()!))
          .toList();
    } catch (e) {
      print('Error getting wishlist products: $e');
      throw Exception('Failed to get wishlist products: $e');
    }
  }

  // Orders Operations
  Future<void> createOrder(List<CartItem> items, double totalAmount) async {
    try {
      print('Creating new order for user ${_getCurrentUserId()}...');
      
      final orderData = {
        'userId': _getCurrentUserId(),
        'dateTime': Timestamp.now(),
        'totalAmount': totalAmount,
        'products': items.map((item) => {
          'productId': item.product.id,
          'name': item.product.name,
          'price': item.product.price,
          'quantity': item.quantity,
          'imageUrl': item.product.imageUrl,
        }).toList(),
      };

      await _ordersCollection.add(orderData);
      print('Order created successfully');
    } catch (e) {
      print('Error creating order: $e');
      throw Exception('Failed to create order: $e');
    }
  }

  Stream<List<app_order.Order>> getOrders() {
    try {
      print('Getting orders stream for user ${_getCurrentUserId()}...');
      return _ordersCollection
          .snapshots()
          .map((snapshot) {
            print('Received ${snapshot.docs.length} orders from Firestore');
            // Sort the orders in memory instead
            final orders = snapshot.docs.map((doc) {
              try {
                final data = doc.data();
                print('Processing order document: ${doc.id}');
                print('Order data: $data');
                
                final products = (data['products'] as List?)?.map((item) {
                  print('Processing product: $item');
                  return Product(
                    id: item['productId'] ?? '',
                    name: item['name'] ?? '',
                    price: (item['price'] ?? 0).toDouble(),
                    imageUrl: item['imageUrl'] ?? '',
                    description: '', // These fields aren't needed for order display
                    category: '',
                    isFeatured: false,
                  );
                })?.toList() ?? [];

                return app_order.Order(
                  id: doc.id,
                  products: products,
                  totalAmount: (data['totalAmount'] ?? 0).toDouble(),
                  dateTime: (data['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
                );
              } catch (e, stackTrace) {
                print('Error processing order document ${doc.id}: $e');
                print('Stack trace: $stackTrace');
                rethrow;
              }
            }).toList();
            
            // Sort in memory
            orders.sort((a, b) => b.dateTime.compareTo(a.dateTime));
            return orders;
          });
    } catch (e, stackTrace) {
      print('Error getting orders: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Get wishlist for current user with products
  Stream<List<Product>> getWishlist() {
    try {
      print('Getting wishlist stream with products...');
      return _getUserCollection('wishlist').snapshots().map((snapshot) {
        print('Received ${snapshot.docs.length} wishlist items');
        return snapshot.docs.map((doc) {
          final data = doc.data();
          if (data['product'] != null) {
            return Product.fromMap(data['product']);
          }
          // If product data is not embedded, return null and filter it out
          return null;
        }).whereType<Product>().toList();  // This filters out null values
      });
    } catch (e) {
      print('Error getting wishlist: $e');
      rethrow;
    }
  }

  // Get cart for current user
  Stream<List<Product>> getCart() {
    return _cartCollection
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Product.fromMap(data);
      }).toList();
    });
  }

  // Get user profile
  Stream<Map<String, dynamic>> getUserProfile() {
    return _firestore
        .collection('users')
        .doc(_getCurrentUserId())
        .snapshots()
        .map((doc) => doc.data() ?? {});
  }

  // Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(_getCurrentUserId())
        .update(data);
  }

  // Update product rating
  Future<void> updateProductRating(String productId, double newRating) async {
    try {
      final userId = _getCurrentUserId();
      print('Updating rating for product $productId by user $userId...');
      
      // Get the current product data
      final productDoc = await _productsCollection.doc(productId).get();
      if (!productDoc.exists) {
        throw Exception('Product not found');
      }

      final productData = productDoc.data()!;
      Map<String, dynamic> currentRatings = Map<String, dynamic>.from(productData['userRatings'] ?? {});
      
      // Add or update the rating
      currentRatings[userId] = newRating;

      // Update the product document
      await _productsCollection.doc(productId).update({
        'userRatings': currentRatings,
      });

      print('Successfully updated product rating for user $userId');
    } catch (e) {
      print('Error updating product rating: $e');
      throw Exception('Failed to update product rating: $e');
    }
  }
} 