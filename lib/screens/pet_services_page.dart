import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mis_domasna/screens/service_detail_page.dart';
import '../models/pet_service.dart';
import '../widgets/app_drawer.dart';

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
              style: GoogleFonts.inter(
                color: Color(0xFF515950),
                fontSize: 16.9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        itemCount: sampleServices.length,
        itemBuilder: (context, index) {
          return _buildServiceCard(context, sampleServices[index]);
        },
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildServiceCard(BuildContext context, PetService service) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: GoogleFonts.inter(
                      color: Color(0xFF586058),
                      fontSize: 15.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${service.name}, ${service.duration}',
                    style: GoogleFonts.inter(
                      color: Color(0xFF98C197),
                      fontSize: 12.9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServiceDetailPage(service: service),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE8F3E8),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.5),
                      ),
                    ),
                    child: Text(
                      'Book \$${service.price.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        color: Color(0xFF606C60),
                        fontSize: 12.9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(service.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildBottomNavBar() {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Color(0xFFF7FCF7),
        border: Border(
          top: BorderSide(color: Color(0xFFE8F2E8)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', true),
          _buildNavItem(Icons.search, 'Categories', true),
          _buildNavItem(Icons.card_giftcard, 'Services', false),
          _buildNavItem(Icons.receipt, 'Orders', true),
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
          color: isActive ? Color(0xFF4F964F) : Color(0xFF0D1C0D),
          size: 24,
        ),
        Text(
          label,
          style: GoogleFonts.beVietnamPro(
            color: isActive ? Color(0xFF4F964F) : Color(0xFF0D1C0D),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
