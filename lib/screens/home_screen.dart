import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mis_domasna/screens/wishlist_page.dart';
import '../models/pet_service.dart';
import '../models/product.dart';
import '../providers/store_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
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
  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    
    if (storeProvider.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${storeProvider.error}'),
              ElevatedButton(
                onPressed: () => storeProvider.initializeStore(),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (storeProvider.isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final products = storeProvider.products;
    final featuredProducts = storeProvider.featuredProducts;
    final services = storeProvider.services;

    return Scaffold(
      backgroundColor: Color(0xFFF7FCF7),
      appBar: AppBar(
        backgroundColor: Color(0xFFF7FCF7),
        elevation: 0,
        title: Text(
          'My Pet Shop',
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
          IconButton(
            icon: Icon(Icons.favorite_border_outlined, color: Color(0xFF4F964F)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WishlistPage()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => storeProvider.initializeStore(),
        child: SingleChildScrollView(
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
              if (featuredProducts.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No featured products available'),
                  ),
                )
              else
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
                products: products,
                onSelectCategory: storeProvider.setSelectedCategory,
                selectedCategory: storeProvider.selectedCategory,
            ),
              if (products.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No products available'),
                  ),
                )
              else
                PopularProductsGrid(products: products),
              if (services.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No services available'),
                  ),
                )
              else
                PetServicesSection(services: services),
          ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentRoute: '/',)
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        switch (label) {
          case 'Home':
            Navigator.pushReplacementNamed(context, '/');
            break;
          case 'Categories':
            Navigator.pushNamed(context, '/categories');
            break;
          case 'Services':
            Navigator.pushNamed(context, '/services');
            break;
          case 'Orders':
            Navigator.pushNamed(context, '/orders');
            break;
          case 'Profile':
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
      child: Column(
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
      ),
    );
  }

}

