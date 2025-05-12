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
  String _selectedPaymentMethod = '';
  Map<String, String> _cardInfo = {};

  @override
  void initState() {
    super.initState();
    // TODO: Load saved payment method from persistent storage
    _selectedPaymentMethod = ''; // Load from storage
  }

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
                _buildListItem('Payment', trailing: Icons.arrow_forward_ios, onTap: () => _showPaymentScreen(context)),

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
                _buildListItem('Privacy Policy', onTap: () => _showPrivacyPolicy(context)),
                _buildListItem('Terms of Service', onTap: () => _showTermsOfService(context)),
                _buildListItem('Version', subtitle: '1.0.0'),
                _buildListItem('Support'),

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
      onTap: onTap ?? () {
        if (title == 'Support') {
          Navigator.pushNamed(context, '/support');
        }
      },
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

  void _showPaymentScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Methods',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D1C0D),
              ),
            ),
            SizedBox(height: 20),
            if (_selectedPaymentMethod.isNotEmpty && _cardInfo.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFE7F3E8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF4F964F)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Payment Method',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D1C0D),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${_selectedPaymentMethod} - ${_cardInfo['number']?.substring(_cardInfo['number']!.length - 4) ?? ''}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Color(0xFF4F964F),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
            _buildPaymentMethod(
              'Credit/Debit Card',
              Icons.credit_card,
              () => _showCardInputDialog(context),
              isSelected: _selectedPaymentMethod == 'Credit/Debit Card',
            ),
            _buildPaymentMethod(
              'PayPal',
              Icons.payment,
              () => _selectPaymentMethod('PayPal'),
              isSelected: _selectedPaymentMethod == 'PayPal',
            ),
            _buildPaymentMethod(
              'Apple Pay',
              Icons.apple,
              () => _selectPaymentMethod('Apple Pay'),
              isSelected: _selectedPaymentMethod == 'Apple Pay',
            ),
            _buildPaymentMethod(
              'Google Pay',
              Icons.g_mobiledata,
              () => _selectPaymentMethod('Google Pay'),
              isSelected: _selectedPaymentMethod == 'Google Pay',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(String title, IconData icon, VoidCallback onTap, {bool isSelected = false}) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF4F964F) : Color(0xFFE7F3E8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: isSelected ? Colors.white : Color(0xFF4F964F)),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isSelected ? Color(0xFF4F964F) : Color(0xFF0D1C0D),
        ),
      ),
      trailing: isSelected 
          ? Icon(Icons.check_circle, color: Color(0xFF4F964F))
          : Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _selectPaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
      // TODO: Save to persistent storage
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment method updated to $method')),
    );
  }

  void _showCardInputDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final cardNumberController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();
    final nameController = TextEditingController();

    if (_cardInfo.isNotEmpty) {
      cardNumberController.text = _cardInfo['number'] ?? '';
      expiryController.text = _cardInfo['expiry'] ?? '';
      nameController.text = _cardInfo['name'] ?? '';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Card',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: cardNumberController,
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    hintText: '4111 1111 1111 1111',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter card number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: expiryController,
                        decoration: InputDecoration(
                          labelText: 'Expiry',
                          hintText: 'MM/YY',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: cvvController,
                        decoration: InputDecoration(
                          labelText: 'CVV',
                          hintText: '123',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Cardholder Name',
                    hintText: 'JOHN DOE',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cardholder name';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  _selectedPaymentMethod = 'Credit/Debit Card';
                  _cardInfo = {
                    'number': cardNumberController.text,
                    'expiry': expiryController.text,
                    'name': nameController.text,
                  };
                  // TODO: Save to persistent storage
                });
                Navigator.pop(context); // Close card input dialog
                Navigator.pop(context); // Close payment methods sheet
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Card added successfully')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1AE51A),
            ),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFF7FCF7),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF0D1C0D)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Privacy Policy',
              style: GoogleFonts.inter(
                fontSize: 16.9,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5F685F),
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Color(0xFF767D76),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal information.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Color(0xFF0D1C0D),
                  ),
                ),
                // Add more privacy policy content here
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFF7FCF7),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF0D1C0D)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Terms of Service',
              style: GoogleFonts.inter(
                fontSize: 16.9,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5F685F),
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Color(0xFF767D76),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'By using our service, you agree to these terms. Please read them carefully.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Color(0xFF0D1C0D),
                  ),
                ),
                // Add more terms of service content here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
