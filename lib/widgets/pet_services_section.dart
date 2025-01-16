import 'package:flutter/material.dart';
import '../models/pet_service.dart';

class PetServicesSection extends StatelessWidget {
  final List<PetService> services;

  PetServicesSection({required this.services});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Pet Services',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            itemBuilder: (context, index) {
              return _buildServiceCard(context, services[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, PetService service) {
    return Container(
      width: 120,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () {
            // TODO: Implement service selection logic
            print('Selected service: ${service.name}');
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(service.icon, size: 40, color: Theme.of(context).primaryColor),
              SizedBox(height: 8),
              Text(
                service.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '\$${service.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
