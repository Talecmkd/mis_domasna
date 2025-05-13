import 'package:flutter/material.dart';

class NavigationUtils {
  static int getIndexFromRoute(String route) {
    switch (route) {
      case '/':
        return 0;
      case '/categories':
        return 1;
      case '/services':
        return 2;
      case '/orders':
        return 3;
      case '/profile':
        return 4;
      default:
        return 0;
    }
  }

  static String getRouteFromIndex(int index) {
    switch (index) {
      case 0:
        return '/';
      case 1:
        return '/categories';
      case 2:
        return '/services';
      case 3:
        return '/orders';
      case 4:
        return '/profile';
      default:
        return '/';
    }
  }

  static void handleNavigation(BuildContext context, int index) {
    final route = getRouteFromIndex(index);
    if (route == '/') {
      Navigator.pushReplacementNamed(context, route);
    } else {
      Navigator.pushNamed(context, route);
    }
  }
} 