import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_drawer.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = 'Allison Wong';
  String _email = 'allisonwong@gmail.com';
  String _phone = '1(650)555-1234';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 223,
                height: 235,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1000&auto=format&fit=crop'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildProfileItem(Icons.person, _name),
            _buildProfileItem(Icons.email, _email),
            _buildProfileItem(Icons.phone, _phone),
            _buildProfileItem(Icons.lock, 'Password', showArrow: true),
            _buildProfileItem(Icons.location_on, 'Shipping Address', showArrow: true),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {},
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
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String text, {bool showArrow = false}) {
    return Container(
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
    );
  }
}
