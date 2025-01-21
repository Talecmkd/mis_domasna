import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      body: Column(
        children: [
          Expanded(
            child: wishlistItems.isEmpty
                ? Center(child: Text('Your wishlist is empty!'))
                : ListView.builder(
              itemCount: wishlistItems.length,
              itemBuilder: (ctx, i) => _buildWishlistItem(context, wishlistItems[i]),
            ),
          ),
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildWishlistItem(BuildContext context, Product product) {
    return Container(
      height: 67,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.5),
              child: Image.network(
                product.imageUrl,
                width: 53,
                height: 53,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.inter(
                    color: Color(0xFF6C736B),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    color: Color(0xFF9AC49A),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: () => _deleteItem(product),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE8F3E8),
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Remove',
                style: GoogleFonts.inter(
                  color: Color(0xFF687568),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8F2E8))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', true),
          _buildNavItem(Icons.search, 'Categories', false),
          _buildNavItem(Icons.card_giftcard, 'Services', false),
          _buildNavItem(Icons.receipt, 'Orders', false),
          _buildNavItem(Icons.person, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Color(0xFF4F964F),
          size: 24,
        ),
        Text(
          label,
          style: GoogleFonts.beVietnamPro(
            color: Color(0xFF4F964F),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
