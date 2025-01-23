import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mis_domasna/screens/wishlist_page.dart';
import '../models/order.dart';
import '../widgets/app_drawer.dart';
import 'package:intl/intl.dart';

import '../widgets/bottom_nav_bar.dart';
import 'cart_page.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FCF7),
      appBar: AppBar(
        backgroundColor: Color(0xFFF7FCF7),
        elevation: 0,
        title: Text(
          'Orders',
          style: GoogleFonts.beVietnamPro(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0D1C0D),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Color(0xFF0D1C0D)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite_border_outlined, color: Color(0xFF4F964F)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WishlistPage()),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: sampleOrders.isEmpty
          ? Center(child: Text('No orders yet!'))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Today',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D1C0D),
                ),
              ),
            ),
            _buildTodayOrders(),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Past',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D1C0D),
                ),
              ),
            ),
            _buildPastOrders(),
          ],
        ),
      ),
        bottomNavigationBar: BottomNavBar(currentRoute: '/orders',)
    );

  }

  Widget _buildOrderItem(BuildContext context, Order order) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 93,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(order.products.first.imageUrl),
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
                  'Order number: ${order.id}',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0D1C0D),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Order date: ${DateFormat('dd/MM/yy').format(order.dateTime)}',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    color: Color(0xFF4F964F),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    color: Color(0xFF4F964F),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios,
              color: Color(0xFF0D1C0D),
              size: 24,
            ),
            onPressed: () {
              // Navigate to order details
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTodayOrders() {
    final today = DateTime.now();
    return Builder(
      builder: (context) => Column(
        children: sampleOrders
            .where((order) => order.dateTime.day == today.day)
            .map((order) => _buildOrderItem(context, order))
            .toList(),
      ),
    );
  }
  Widget _buildPastOrders() {
    final today = DateTime.now();
    return Builder(
      builder: (context) => Column(
        children: sampleOrders
            .where((order) => order.dateTime.day != today.day)
            .map((order) => _buildOrderItem(context, order))
            .toList(),
      ),
    );
  }
}
