import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/app_drawer.dart';
import 'product_detail_page.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Product> wishlistItems = sampleProducts.take(3).toList();

  void _deleteItem(Product product) {
    setState(() {
      wishlistItems.removeWhere((item) => item.id == product.id);
    });
  }

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
            _deleteItem(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${product.name} removed from wishlist')),
            );
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: product),
            ),
          );
        },
      ),
    );
  }
}
