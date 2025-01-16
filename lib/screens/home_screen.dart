import 'package:flutter/material.dart';
import '../models/pet_service.dart';
import '../models/product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/category_section.dart';
import '../widgets/featured_products_carousel.dart';
import '../widgets/pet_services_section.dart';
import '../widgets/popular_products_grid.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Product> featuredProducts = sampleProducts.where((product) => product.isFeatured).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Shop'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // TODO: Implement cart functionality
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Featured Products',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        ),
            FeaturedProductsCarousel(featuredProducts: featuredProducts),
            SizedBox(height: 16),
            CategorySection(products: sampleProducts),
            SizedBox(height: 16),
            PopularProductsGrid(products: sampleProducts),
            PetServicesSection(services: sampleServices),          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pets'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        // TODO: Implement navigation
      ),
    );
  }
}
