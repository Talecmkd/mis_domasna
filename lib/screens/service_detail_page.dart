// lib/screens/service_detail_page.dart
import 'package:flutter/material.dart';
import '../models/pet_service.dart';

class ServiceDetailPage extends StatelessWidget {
  final PetService service;

  ServiceDetailPage({required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(
                service.icon,
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${service.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  Text(service.description),
                  SizedBox(height: 24),
                  Text(
                    'What to expect:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  _buildExpectationItem(context, 'Professional and experienced staff'),
                  _buildExpectationItem(context, 'High-quality equipment and products'),
                  _buildExpectationItem(context, 'Personalized care for your pet'),
                  SizedBox(height: 24),
                  ElevatedButton(
                    child: Text('Book Now'),
                    onPressed: () {
                      // TODO: Implement booking functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Booking functionality coming soon!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpectationItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
