import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'user_provider.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Getters
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Sign in with email and password
  Future<void> signIn(String email, String password, BuildContext context) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.signInWithEmailAndPassword(email, password);
      
      // Initialize user profile after successful sign in
      if (_user != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.initializeUserProfile();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register with email and password
  Future<void> register(String email, String password, String name, BuildContext context) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.registerWithEmailAndPassword(email, password, name);
      
      // Initialize user profile after successful registration
      if (_user != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.initializeUserProfile();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign out
  Future<void> signOut(BuildContext context) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Clear user profile before signing out
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.clearUserProfile();

      await _authService.signOut();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.resetPassword(email);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update profile
  Future<void> updateProfile(String name, String? photoUrl) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.updateUserProfile(name, photoUrl);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 