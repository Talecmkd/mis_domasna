// lib/screens/wishlist_page.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/app_drawer.dart';

class WishlistPage extends StatelessWidget {
  // For this example, we'll use a subset of sampleProducts as wishlist items
  final List<Product> wishlistItems = sampleProducts.take(3).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wishlist'),
      ),
      drawer: AppDrawer(),
      body: wishlistItems.isEmpty
          ? Center(child: Text('Your wishlist is empty!'))
          : ListView.builder(
        itemCount: wishlistItems.length,
        itemBuilder: (ctx, i) => _buildWishlistItem(context, wishlistItems[i]),
      ),
    );
  }

  Widget _buildWishlistItem(BuildContext context, Product product) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.network(
          product.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(product.name),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            // TODO: Implement remove from wishlist functionality
            print('Remove ${product.name} from wishlist');
          },
        ),
        onTap: () {
          // TODO: Navigate to product details page
          print('View details of ${product.name}');
        },
      ),
    );
  }
}
