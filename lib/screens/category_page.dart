import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mis_domasna/screens/category_products_page.dart';
import 'package:mis_domasna/screens/wishlist_page.dart';
import '../models/product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import 'cart_page.dart';
import '../utils/navigation_utils.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String? selectedTab;

  List<String> filterCategories(List<String> categories, String? filter) {
    if (filter == null) return categories;
    return categories.where((category) =>
        category.toLowerCase().contains(filter.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> allCategories = sampleProducts.map((p) => p.category).toSet().toList();
    List<String> filteredCategories = filterCategories(allCategories, selectedTab);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Pet Supplies',
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
      body: Column(
        children: [
          Container(
            height: 66,
            padding: EdgeInsets.only(bottom: 12),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryTab('Dog', selectedTab == 'Dog'),
                _buildCategoryTab('Cat', selectedTab == 'Cat'),
                _buildCategoryTab('Bird', selectedTab == 'Bird'),
                _buildCategoryTab('Fish', selectedTab == 'Fish'),
                _buildCategoryTab('Small Pet', selectedTab == 'Small Pet'),
              ],
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(context, filteredCategories[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: NavigationUtils.getIndexFromRoute('/categories'),
        onTap: (index) => NavigationUtils.handleNavigation(context, index),
      ),
    );
  }

  Widget _buildCategoryTab(String label, bool isSelected) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTab = selectedTab == label ? null : label;
            });
          },
          child: Container(
            margin: EdgeInsets.only(right: 32),
            height: 53,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? theme.colorScheme.onSurface : theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 13),
                if (isSelected)
                  Container(
                    height: 3,
                    width: 29,
                    color: theme.colorScheme.onSurface,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, String category) {
    final theme = Theme.of(context);
    final Map<String, String> categoryImages = {
      'Dog Food': 'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?q=80&w=1000&auto=format&fit=crop',
      'Cat Toys': 'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?q=80&w=1000&auto=format&fit=crop',
      'Bedding': 'https://images.unsplash.com/photo-1576201836106-db1758fd1c97?q=80&w=1000&auto=format&fit=crop',
      'Fish Supplies': 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?q=80&w=1000&auto=format&fit=crop',
      'Bird Supplies': 'https://images.unsplash.com/photo-1522858547137-f1dcec554f55?q=80&w=1000&auto=format&fit=crop',
      'Small Pet Supplies': 'https://images.unsplash.com/photo-1548767797-d8c844163c4c?q=80&w=1000&auto=format&fit=crop'
    };

    return Container(
      height: 242,
      margin: EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 0,
        color: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            List<Product> categoryProducts = sampleProducts
                .where((p) => p.category == category)
                .toList();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryProductsPage(
                  category: category,
                  products: categoryProducts,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    image: DecorationImage(
                      image: NetworkImage(categoryImages[category] ?? 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?q=80&w=1000&auto=format&fit=crop'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Nutritious and delicious',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: theme.colorScheme.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: Size(0, 30),
                          ),
                          child: Text(
                            'Shop now',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onPrimary,
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
