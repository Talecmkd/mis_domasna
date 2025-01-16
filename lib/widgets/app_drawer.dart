import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(),
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
          Divider(),
          _buildDrawerItem(
            icon: Icons.help,
            text: 'Help & Support',
            onTap: () => Navigator.pushNamed(context, '/support'),
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: 'Settings',
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          Divider(),
          _buildDrawerItem(
            icon: Icons.exit_to_app,
            text: 'Sign Out',
            onTap: () {
              // TODO: Implement sign out logic
              print('Sign out tapped');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text("Mihail Talev"),
      accountEmail: Text("mihail.talev@hotmail.com"),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.person,
          size: 50,
          color: Colors.blue,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}
