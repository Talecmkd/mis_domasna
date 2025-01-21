import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mis_domasna/screens/category_page.dart';
import 'package:mis_domasna/screens/help_support_page.dart';
import 'package:mis_domasna/screens/home_screen.dart';
import 'package:mis_domasna/screens/orders_page.dart';
import 'package:mis_domasna/screens/pet_services_page.dart';
import 'package:mis_domasna/screens/profile_page.dart';
import 'package:mis_domasna/screens/settings_page.dart';
import 'package:mis_domasna/screens/wishlist_page.dart';
import 'package:mis_domasna/models/cart.dart';
import 'package:mis_domasna/screens/cart_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Cart(),
      child: MaterialApp(
        title: 'Pet Shop App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
        routes: {
          '/categories': (context) => CategoryPage(),
          '/services': (context) => PetServicesPage(),
          '/orders': (context) => OrdersPage(),
          '/wishlist': (context) => WishlistPage(),
          '/support': (context) => HelpSupportPage(),
          '/settings': (context) => SettingsPage(),
          '/profile': (context) => ProfilePage(),
          '/cart': (context) => CartPage(),
        },
      ),
    );
  }
}
