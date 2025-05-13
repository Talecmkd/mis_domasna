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
import 'map_screen.dart';
import '../utils/navigation_utils.dart';
import '../widgets/custom_loading_indicator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        body: CustomLoadingIndicator(
          message: 'Loading products and services...',
        ),
      );
    }

    final products = storeProvider.products;
    final featuredProducts = storeProvider.featuredProducts;
    final services = storeProvider.services;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'My Pet Shop',
          style: GoogleFonts.beVietnamPro(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: theme.colorScheme.onSurface),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite_border_outlined, color: theme.colorScheme.primary),
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
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(Icons.search, color: theme.colorScheme.primary),
                    ),
                    Expanded(
                      child: Text(
                        'Search pet products, services...',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          color: theme.colorScheme.primary,
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
                  color: theme.colorScheme.onSurface,
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
            _buildMapButton(context),
          ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: NavigationUtils.getIndexFromRoute('/'),
        onTap: (index) => NavigationUtils.handleNavigation(context, index),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    final theme = Theme.of(context);
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
            color: isActive ? theme.colorScheme.onSurface : theme.colorScheme.primary,
            size: 24,
          ),
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? theme.colorScheme.onSurface : theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapScreen()),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.secondary,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: theme.colorScheme.onSecondary),
            SizedBox(width: 8),
            Text(
              'Find Nearby Pet Stores',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

