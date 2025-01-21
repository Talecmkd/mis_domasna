import 'package:flutter/material.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Categories',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              String category =
              index == 0 ? 'All' : categories[index - 1];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == (index == 0 ? null : category),
                  onSelected: (selected) {
                    onSelectCategory(selected ? (index == 0 ? null : category) : null);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
