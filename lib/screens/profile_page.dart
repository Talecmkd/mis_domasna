import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import 'change_password_screen.dart';
import 'shipping_address_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Initialize user profile when page loads
    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).initializeUserProfile();
    });
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
          'Profile',
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

          final user = userProvider.userProfile;
          if (user == null) {
            return Center(
              child: Text('Error loading profile'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 223,
                        height: 235,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: user.photoUrl != null
                                ? NetworkImage(user.photoUrl!)
                                : NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1000&auto=format&fit=crop'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundColor: Color(0xFF1AE51A),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, color: Color(0xFF1C170D)),
                            onPressed: () {
                              // TODO: Implement profile picture upload
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _buildProfileItem(Icons.settings, "Settings"),
                _buildProfileItem(Icons.person, user.name),
                _buildProfileItem(Icons.email, user.email),
                _buildProfileItem(Icons.phone, user.phoneNumber ?? 'Add phone number'),
                _buildProfileItem(
                  Icons.lock,
                  'Password',
                  showArrow: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                  ),
                ),
                _buildProfileItem(
                  Icons.location_on,
                  'Shipping Address',
                  showArrow: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShippingAddressScreen()),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.signOut(context);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/',
                          (route) => false,
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error signing out: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE7F3E8),
                      minimumSize: Size(double.infinity, 38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(color: Color(0xFFEDF4ED)),
                      ),
                    ),
                    child: Text(
                      'Log Out',
                      style: GoogleFonts.inter(
                        fontSize: 13.3,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5D695D),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(currentRoute: '/profile'),
    );
  }

  Widget _buildProfileItem(IconData icon, String text, {bool showArrow = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {
        if (text == "Settings") {
          Navigator.pushNamed(context, '/settings');
        }
      },
      child: Container(
        height: 52,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Color(0xFFDDEEDD),
                borderRadius: BorderRadius.circular(7.25),
              ),
              child: Icon(icon, color: Color(0xFF7D857D), size: 20),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 14.6,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7D857D),
                ),
              ),
            ),
            if (showArrow)
              Icon(Icons.arrow_forward_ios, color: Color(0xFF7D857D), size: 18),
          ],
        ),
      ),
    );
  }
}
