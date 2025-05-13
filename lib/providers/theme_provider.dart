import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  bool _isDarkMode = false;
  bool _isInitialized = false;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  bool get isDarkMode => _isDarkMode;
  bool get isInitialized => _isInitialized;

  ThemeData get currentTheme => _isDarkMode 
    ? _darkTheme
    : _lightTheme;

  // Light theme
  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF4F964F),
    scaffoldBackgroundColor: Color(0xFFF7FCF7),
    cardColor: Colors.white,
    dividerColor: Color(0xFFE8F2E8),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFF7FCF7),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF0D1C0D)),
      titleTextStyle: TextStyle(
        fontSize: 16.9,
        fontWeight: FontWeight.w600,
        color: Color(0xFF5F685F),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFF7FCF7),
      selectedItemColor: Color(0xFF4F964F),
      unselectedItemColor: Color(0xFF0D1C0D).withOpacity(0.7),
    ),
    colorScheme: ColorScheme.light(
      primary: Color(0xFF4F964F),
      secondary: Color(0xFF1AE51A),
      surface: Color(0xFFF7FCF7),
      background: Color(0xFFF7FCF7),
      error: Colors.red[700]!,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF0D1C0D),
      onBackground: Color(0xFF0D1C0D),
      onError: Colors.white,
    ),
  );

  // Dark theme
  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF1AE51A),
    scaffoldBackgroundColor: Color(0xFF121212),
    cardColor: Color(0xFF1E1E1E),
    dividerColor: Color(0xFF2C2C2C),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF121212),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFFF7FCF7)),
      titleTextStyle: TextStyle(
        fontSize: 16.9,
        fontWeight: FontWeight.w600,
        color: Color(0xFFF7FCF7),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF121212),
      selectedItemColor: Color(0xFF1AE51A),
      unselectedItemColor: Color(0xFFF7FCF7).withOpacity(0.7),
    ),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF1AE51A),
      secondary: Color(0xFF4F964F),
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
      error: Colors.red[700]!,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Color(0xFFF7FCF7),
      onBackground: Color(0xFFF7FCF7),
      onError: Colors.black,
    ),
  );

  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_themeKey) ?? false;
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error loading theme preferences: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    try {
      _isDarkMode = !_isDarkMode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
      notifyListeners();
    } catch (e) {
      print('Error saving theme preference: $e');
      // Revert the change if saving failed
      _isDarkMode = !_isDarkMode;
      notifyListeners();
    }
  }
} 