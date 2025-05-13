import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/map_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            title: 'Home',
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.category,
            title: 'Categories',
            onTap: () => Navigator.pushNamed(context, '/categories'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.pets,
            title: 'Pet Services',
            onTap: () => Navigator.pushNamed(context, '/services'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: Theme.of(context).dividerColor, thickness: 1),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.shopping_cart,
            title: 'My Cart',
            onTap: () => Navigator.pushNamed(context, '/cart'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.favorite,
            title: 'Wishlist',
            onTap: () => Navigator.pushNamed(context, '/wishlist'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.receipt,
            title: 'Orders',
            onTap: () => Navigator.pushNamed(context, '/orders'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: Theme.of(context).dividerColor, thickness: 1),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () => Navigator.pushNamed(context, '/support'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            title: 'Sign Out',
            isSignOut: true,
            onTap: () {
              // TODO: Implement sign out
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 30,
            child: Icon(
              Icons.person,
              size: 30,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'John Doe',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            'john.doe@example.com',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSignOut = false,
  }) {
    final color = isSignOut
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.onSurface;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
        size: 22,
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      onTap: onTap,
    );
  }
}
