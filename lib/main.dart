import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
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
import 'package:mis_domasna/providers/store_provider.dart';
import 'package:mis_domasna/providers/auth_provider.dart';
import 'package:mis_domasna/providers/user_provider.dart';
import 'package:mis_domasna/providers/product_provider.dart';
import 'package:mis_domasna/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/local_storage_service.dart';
import 'screens/map_screen.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Initialize local storage
    await LocalStorageService.init();

    // Initialize providers
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (ctx) {
            final storeProvider = StoreProvider();
            storeProvider.initializeStore();
            return storeProvider;
          }),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print('Error during initialization: $e');
    // You might want to show some error UI here
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error initializing app: $e'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (ctx) {
                  final productProvider = ProductProvider();
                  productProvider.initializeProducts();
                  return productProvider;
                }),
                ChangeNotifierProvider(create: (_) => Cart()),
              ],
              child: MaterialApp(
                title: 'Pet Shop App',
                debugShowCheckedModeBanner: false,
                theme: themeProvider.currentTheme,
                home: authProvider.isAuthenticated ? HomePage() : LoginScreen(),
                routes: {
                  '/categories': (context) => CategoryPage(),
                  '/services': (context) => PetServicesPage(),
                  '/orders': (context) => OrdersPage(),
                  '/wishlist': (context) => WishlistPage(),
                  '/support': (context) => HelpSupportPage(),
                  '/settings': (context) => SettingsPage(),
                  '/profile': (context) => ProfilePage(),
                  '/cart': (context) => CartPage(),
                  '/map': (context) => MapScreen(),
                },
              ),
            );
          },
        );
      },
    );
  }
}
