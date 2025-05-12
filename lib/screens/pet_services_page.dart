import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mis_domasna/screens/service_detail_page.dart';
import 'package:mis_domasna/screens/wishlist_page.dart';
import '../models/pet_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/service_card.dart';
import 'cart_page.dart';

class PetServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDEEDD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pet Services',
              style: GoogleFonts.plusJakartaSans(
                color: Color(0xFF515950),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: sampleServices.length,
        itemBuilder: (context, index) {
          final service = sampleServices[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: ServiceCard(
              service: service,
              isHorizontal: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceDetailPage(service: service),
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentRoute: '/services'),
    );
  }
}
