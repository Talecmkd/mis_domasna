import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFF7FCF7),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(),
          SizedBox(height: 16),
          _buildDrawerItem(
            icon: Icons.person,
            text: 'My Profile',
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          _buildDrawerItem(
            icon: Icons.category,
            text: 'Shop by Category',
            onTap: () => Navigator.pushNamed(context, '/categories'),
          ),
          _buildDrawerItem(
            icon: Icons.pets,
            text: 'Pet Services',
            onTap: () => Navigator.pushNamed(context, '/services'),
          ),
          _buildDrawerItem(
            icon: Icons.shopping_cart,
            text: 'My Orders',
            onTap: () => Navigator.pushNamed(context, '/orders'),
          ),
          _buildDrawerItem(
            icon: Icons.favorite,
            text: 'Wishlist',
            onTap: () => Navigator.pushNamed(context, '/wishlist'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: Color(0xFFE8F2E8), thickness: 1),
          ),
          _buildDrawerItem(
            icon: Icons.help_outline,
            text: 'Help & Support',
            onTap: () => Navigator.pushNamed(context, '/support'),
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: 'Settings',
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: Color(0xFFE8F2E8), thickness: 1),
          ),
          _buildDrawerItem(
            icon: Icons.exit_to_app,
            text: 'Sign Out',
            onTap: () {
              // TODO: Implement sign out logic
              print('Sign out tapped');
            },
            isSignOut: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 60, 16, 16),
      decoration: BoxDecoration(
        color: Color(0xFFE8F2E8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Color(0xFF4F964F),
            child: Text(
              'MT',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Mihail Talev",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0D1C0D),
            ),
          ),
          SizedBox(height: 4),
          Text(
            "mihail.talev@hotmail.com",
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Color(0xFF4F964F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
    bool isSignOut = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSignOut ? Color(0xFF4F964F) : Color(0xFF0D1C0D),
        size: 24,
      ),
      title: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isSignOut ? Color(0xFF4F964F) : Color(0xFF0D1C0D),
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
