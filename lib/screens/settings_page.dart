import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_drawer.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FCF7),
      appBar: AppBar(
        backgroundColor: Color(0xFFF7FCF7),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF0D1C0D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 16.9,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5F685F),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildSectionTitle('Account'),
                _buildListItem('Profile', trailing: Icons.arrow_forward_ios),
                _buildListItem('Payment', trailing: Icons.arrow_forward_ios),

                _buildSectionTitle('Preferences'),
                _buildSwitchItem(
                  'Dark Mode',
                  _darkModeEnabled,
                      (value) => setState(() => _darkModeEnabled = value),
                ),
                _buildListItem('Language',
                  subtitle: 'English',
                  onTap: _showLanguageDialog,
                ),
                _buildSwitchItem(
                  'Push Notifications',
                  _notificationsEnabled,
                      (value) => setState(() => _notificationsEnabled = value),
                ),

                _buildSectionTitle('About'),
                _buildListItem('Privacy Policy'),
                _buildListItem('Terms of Service'),
                _buildListItem('Version', subtitle: '1.0.0'),
              ],
            ),
          ),
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16.9,
          fontWeight: FontWeight.w600,
          color: Color(0xFF606860),
        ),
      ),
    );
  }

  Widget _buildListItem(String title, {
    String? subtitle,
    IconData? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14.8,
          fontWeight: FontWeight.w600,
          color: Color(0xFF7B827B),
        ),
      ),
      subtitle: subtitle != null ? Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 14.2,
          fontWeight: FontWeight.w600,
          color: Color(0xFF828881),
        ),
      ) : null,
      trailing: trailing != null ? Icon(
        trailing,
        color: Color(0xFF0D1C0D),
        size: 18,
      ) : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14.8,
          fontWeight: FontWeight.w600,
          color: Color(0xFF767D76),
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Color(0xFF4F964F),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Color(0xFFF7FCF7),
        border: Border(top: BorderSide(color: Color(0xFFE8F2E8))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', false),
          _buildNavItem(Icons.search, 'Categories', false),
          _buildNavItem(Icons.card_giftcard, 'Services', false),
          _buildNavItem(Icons.receipt, 'Orders', false),
          _buildNavItem(Icons.person, 'Profile', true),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('English'),
                  onTap: () {
                    setState(() {
                      _selectedLanguage = 'English';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('Spanish'),
                  onTap: () {
                    setState(() {
                      _selectedLanguage = 'Spanish';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                // Add more languages as needed
              ],
            ),
          ),
        );
      },
    );
  }
}
