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
import 'package:mis_domasna/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize local storage
  await LocalStorageService.init();

  // Test Firebase connection
  try {
    print('Testing Firebase connection...');
    final testDoc = FirebaseFirestore.instance.collection('test').doc('test');
    await testDoc.set({'test': 'test'});
    print('Successfully wrote to Firestore!');
    await testDoc.delete();
    print('Successfully deleted test document!');
  } catch (e) {
    print('Error testing Firebase connection: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) {
          final storeProvider = StoreProvider();
          // Initialize store data
          storeProvider.initializeStore();
          return storeProvider;
        }),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return MaterialApp(
          title: 'Pet Shop App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
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
          },
        );
      },
    );
  }
}
