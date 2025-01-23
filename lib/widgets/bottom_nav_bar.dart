// lib/widgets/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatelessWidget {
  final String currentRoute;

  const BottomNavBar({Key? key, required this.currentRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF7FCF7),
        border: Border(top: BorderSide(color: Color(0xFFE8F2E8))),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, Icons.home, 'Home', currentRoute == '/'),
            _buildNavItem(context, Icons.search, 'Categories', currentRoute == '/categories'),
            _buildNavItem(context, Icons.card_giftcard, 'Services', currentRoute == '/services'),
            _buildNavItem(context, Icons.receipt, 'Orders', currentRoute == '/orders'),
            _buildNavItem(context, Icons.person, 'Profile', currentRoute == '/profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (label == 'Home') {
          Navigator.pushReplacementNamed(context, '/');
        } else {
          Navigator.pushNamed(context, '/${label.toLowerCase()}');
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Color(0xFF0D1C0D) : Color(0xFF4F964F),
            size: 24,
          ),
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? Color(0xFF0D1C0D) : Color(0xFF4F964F),
            ),
          ),
        ],
      ),
    );
  }
}
