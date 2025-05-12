import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pet_service.dart';
import '../screens/service_detail_page.dart';
import '../widgets/service_card.dart';

class PetServicesSection extends StatelessWidget {
  final List<PetService> services;

  PetServicesSection({required this.services});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pet Services',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D1C0D),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/services');
                },
                child: Text(
                  'See All',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4F964F),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            itemBuilder: (context, index) {
              return ServiceCard(
                service: services[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceDetailPage(service: services[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
