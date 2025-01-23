import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pet_service.dart';
import '../models/product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/category_section.dart';
import '../widgets/featured_products_carousel.dart';
import '../widgets/pet_services_section.dart';
import '../widgets/popular_products_grid.dart';
import 'cart_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategory;

  void selectCategory(String? category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = selectedCategory == null
        ? sampleProducts
        : sampleProducts.where((product) => product.category == selectedCategory).toList();

    List<Product> featuredProducts = filteredProducts.where((product) => product.isFeatured).toList();

    return Scaffold(
      backgroundColor: Color(0xFFF7FCF7),
      appBar: AppBar(
        backgroundColor: Color(0xFFF7FCF7),
        elevation: 0,
        title: Text(
          'Pet Shop',
          style: GoogleFonts.beVietnamPro(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0D1C0D),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Color(0xFF0D1C0D)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFFE8F2E8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(Icons.search, color: Color(0xFF4F964F)),
                    ),
                    Expanded(
                      child: Text(
                        'Search pet products, services...',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          color: Color(0xFF4F964F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FeaturedProductsCarousel(featuredProducts: featuredProducts),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text(
                'Categories',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D1C0D),
                ),
              ),
            ),
            CategorySection(
              products: sampleProducts,
              onSelectCategory: selectCategory,
              selectedCategory: selectedCategory,
            ),
            PopularProductsGrid(products: filteredProducts),
            PetServicesSection(services: sampleServices),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF7FCF7),
          border: Border(top: BorderSide(color: Color(0xFFE8F2E8))),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', true),
              _buildNavItem(Icons.search, 'Categories', false),
              _buildNavItem(Icons.card_giftcard, 'Services', false),
              _buildNavItem(Icons.receipt, 'Orders', false),
              _buildNavItem(Icons.person, 'Profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? Color(0xFF0D1C0D) : Color(0xFF4F964F),
          size: 24,
        ),
        Text(
          label,
          style: GoogleFonts.beVietnamPro(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? Color(0xFF0D1C0D) : Color(0xFF4F964F),
          ),
        ),
      ],
    );
  }
}

