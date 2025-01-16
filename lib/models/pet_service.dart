import 'package:flutter/material.dart';

class PetService {
  final String id;
  final String name;
  final IconData icon;
  final String description;
  final double price;

  PetService({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.price,
  });
}
final List<PetService> sampleServices = [
  PetService(
    id: '1',
    name: 'Grooming',
    icon: Icons.content_cut,
    description: 'Professional pet grooming services',
    price: 30.00,
  ),
  PetService(
    id: '2',
    name: 'Training',
    icon: Icons.pets,
    description: 'Behavior training for dogs and cats',
    price: 50.00,
  ),
  PetService(
    id: '3',
    name: 'Vet Consultation',
    icon: Icons.local_hospital,
    description: 'Routine check-ups and health consultations',
    price: 75.00,
  ),
  PetService(
    id: '4',
    name: 'Boarding',
    icon: Icons.home,
    description: 'Safe and comfortable pet boarding',
    price: 40.00,
  ),
];
