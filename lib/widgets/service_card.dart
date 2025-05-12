import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pet_service.dart';

class ServiceCard extends StatelessWidget {
  final PetService service;
  final VoidCallback? onTap;
  final bool isHorizontal;

  const ServiceCard({
    Key? key,
    required this.service,
    this.onTap,
    this.isHorizontal = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isHorizontal ? 200 : null,
      margin: EdgeInsets.only(right: isHorizontal ? 16 : 0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    service.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          service.icon,
                          size: 16,
                          color: Color(0xFF4F964F),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            service.name,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0D1C0D),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      service.description,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        color: Color(0xFF4F964F),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${service.price.toStringAsFixed(0)}',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D1C0D),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFFE8F3E8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            service.duration,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12,
                              color: Color(0xFF4F964F),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 