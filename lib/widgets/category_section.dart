import 'package:flutter/material.dart';
import '../models/product.dart';

class CategorySection extends StatelessWidget {
  final List<Product> products;

  CategorySection({required this.products});

  List<String> get categories {
    return products.map((product) => product.category).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ChoiceChip(
                  label: Text(categories[index]),
                  selected: false,
                  onSelected: (selected) {
                    if (selected) {
                      // TODO: Implement category selection logic
                      print('Selected category: ${categories[index]}');
                    }
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
