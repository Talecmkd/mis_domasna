import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../providers/store_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import 'product_detail_page.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FBF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Wishlist',
          style: GoogleFonts.inter(
            color: Color(0xFF384238),
            fontSize: 27,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, child) {
          if (storeProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${storeProvider.error}'),
                  ElevatedButton(
                    onPressed: () => storeProvider.initializeStore(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (storeProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final wishlistProducts = storeProvider.wishlistProducts;

          if (wishlistProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Color(0xFF9AC49A),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C170D),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add items you love to your wishlist',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Color(0xFF6C736B),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1AE51A),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'Start Shopping',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C170D),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: wishlistProducts.length,
            itemBuilder: (context, index) => _buildWishlistItem(
              context,
              wishlistProducts[index],
              storeProvider,
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentRoute: '/wishlist'),
    );
  }

  Widget _buildWishlistItem(
    BuildContext context,
    Product product,
    StoreProvider storeProvider,
  ) {
    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: Colors.red.shade100,
        child: Icon(Icons.delete, color: Colors.red),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Remove from Wishlist'),
            content: Text('Do you want to remove this item from your wishlist?'),
            actions: [
              TextButton(
                child: Text('No'),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        storeProvider.removeFromWishlist(product.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} removed from wishlist'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                storeProvider.addToWishlist(product);
              },
            ),
          ),
        );
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(product: product),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1C170D),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9AC49A),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    final cart = Provider.of<Cart>(context, listen: false);
                    cart.addItem(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to cart'),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            cart.removeItem(product.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
