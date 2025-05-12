import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class ShippingAddressScreen extends StatefulWidget {
  @override
  _ShippingAddressScreenState createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _showAddAddressDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing while processing
      builder: (context) => AlertDialog(
        title: Text(
          'Add New Address',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  controller: _streetController,
                  label: 'Street Address',
                  icon: Icons.location_on,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _cityController,
                  label: 'City',
                  icon: Icons.location_city,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _stateController,
                  label: 'State',
                  icon: Icons.map,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _zipCodeController,
                  label: 'ZIP Code',
                  icon: Icons.local_post_office,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _countryController,
                  label: 'Country',
                  icon: Icons.public,
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
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return ElevatedButton(
                onPressed: userProvider.isLoading ? null : _handleAddAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1AE51A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: userProvider.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Add Address',
                        style: GoogleFonts.plusJakartaSans(
                          color: Color(0xFF1C170D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(color: Color(0xFF6C736B)),
        prefixIcon: Icon(icon, color: Color(0xFF6C736B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE8F2E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE8F2E8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF4F964F)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Future<void> _handleAddAddress() async {
    if (!_formKey.currentState!.validate()) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    try {
      final address = UserAddress(
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
        country: _countryController.text.trim(),
      );

      await userProvider.addAddress(address);

      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Address added successfully')),
      );

      // Clear form
      _streetController.clear();
      _cityController.clear();
      _stateController.clear();
      _zipCodeController.clear();
      _countryController.clear();
    } catch (e) {
      Navigator.pop(context); // Close dialog even on error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding address: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FBF7),
      appBar: AppBar(
        backgroundColor: Color(0xFFF8FBF7),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF0D1C0D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Shipping Addresses',
          style: GoogleFonts.inter(
            fontSize: 16.9,
            fontWeight: FontWeight.w600,
            color: Color(0xFF596259),
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final addresses = userProvider.userProfile?.addresses ?? [];

          if (addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off,
                    size: 64,
                    color: Color(0xFF9AC49A),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No addresses yet',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C170D),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add your first shipping address',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Color(0xFF6C736B),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return Dismissible(
                key: ValueKey(index),
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
                      title: Text('Remove Address'),
                      content: Text('Do you want to remove this address?'),
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
                  userProvider.removeAddress(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Address removed')),
                  );
                },
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.street,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1C170D),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${address.city}, ${address.state} ${address.zipCode}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: Color(0xFF6C736B),
                          ),
                        ),
                        Text(
                          address.country,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: Color(0xFF6C736B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAddressDialog,
        backgroundColor: Color(0xFF1AE51A),
        child: Icon(Icons.add, color: Color(0xFF1C170D)),
      ),
    );
  }
} 