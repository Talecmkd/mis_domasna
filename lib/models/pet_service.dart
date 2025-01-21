import 'package:flutter/material.dart';

class PetService {
  final String id;
  final String name;
  final IconData icon;
  final String description;
  final double price;
  final String imageUrl;
  final String duration;

  PetService({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.duration,
  });
}

final List<PetService> sampleServices = [
  PetService(
    id: '1',
    name: 'Grooming',
    icon: Icons.content_cut,
    description: 'Professional pet grooming services',
    price: 30.00,
    imageUrl: 'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?q=80&w=1000&auto=format&fit=crop',
    duration: '1hr',
  ),
  PetService(
    id: '2',
    name: 'Training',
    icon: Icons.pets,
    description: 'Behavior training for dogs and cats',
    price: 50.00,
    imageUrl: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?q=80&w=1000&auto=format&fit=crop',
    duration: '2hrs',
  ),
  PetService(
    id: '3',
    name: 'Vet Consultation',
    icon: Icons.local_hospital,
    description: 'Routine check-ups and health consultations',
    price: 75.00,
    imageUrl: 'https://images.unsplash.com/photo-1517849845537-4d257902454a?q=80&w=1000&auto=format&fit=crop',
    duration: '30min',
  ),
  PetService(
    id: '4',
    name: 'Boarding',
    icon: Icons.home,
    description: 'Safe and comfortable pet boarding',
    price: 40.00,
    imageUrl: 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?q=80&w=1000&auto=format&fit=crop',
    duration: '24hrs',
  ),
];
