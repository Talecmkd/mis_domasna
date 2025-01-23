import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';

class CategorySection extends StatelessWidget {
  final List<Product> products;
  final Function(String?) onSelectCategory;
  final String? selectedCategory;

  CategorySection({
    required this.products,
    required this.onSelectCategory,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    List<String> categories = products.map((p) => p.category).toSet().toList();

    return Container(
      height: 66,
      padding: EdgeInsets.only(bottom: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1, // +1 for "All" category
        itemBuilder: (context, index) {
          String category = index == 0 ? 'All' : categories[index - 1];
          bool isSelected = selectedCategory == (index == 0 ? null : category);

          return GestureDetector(
            onTap: () {
              onSelectCategory(isSelected ? null : (index == 0 ? null : category));
            },
            child: Container(
              margin: EdgeInsets.only(right: 32),
              height: 53,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category,
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
        },
      ),
    );
  }
}
