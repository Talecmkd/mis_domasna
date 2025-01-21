import 'package:flutter/material.dart';
import 'package:mis_domasna/screens/category_products_page.dart';
import '../models/product.dart';
import '../widgets/app_drawer.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get unique categories from sampleProducts
    List<String> categories = sampleProducts.map((p) => p.category).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop by Category'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryCard(context, categories[index]);
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String category) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          List<Product> categoryProducts = sampleProducts.where((p) => p.category == category).toList();
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.category, size: 40),
              SizedBox(width: 16),
              Text(
                category,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
