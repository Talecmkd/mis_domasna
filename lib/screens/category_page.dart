import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mis_domasna/screens/category_products_page.dart';
import '../models/product.dart';
import '../widgets/app_drawer.dart';

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

    return Scaffold(
      backgroundColor: Color(0xFFF7FCF7),
      appBar: AppBar(
        backgroundColor: Color(0xFFF7FCF7),
        elevation: 0,
        title: Text(
          'Pet Supplies',
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
              Navigator.pushNamed(context, '/cart');
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
          Divider(height: 1, color: Color(0xFFD1E8D1)),
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
    );
  }

  Widget _buildCategoryTab(String label, bool isSelected) {
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
                color: isSelected ? Color(0xFF0D1C0D) : Color(0xFF4F964F),
              ),
            ),
            SizedBox(height: 13),
            if (isSelected)
              Container(
                height: 3,
                width: 29,
                color: Color(0xFF0D1C0D),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String category) {
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
                        color: Color(0xFF0D1C0D),
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
                              color: Color(0xFF4F964F),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1AE61A),
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
                              color: Color(0xFF0D1C0D),
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
