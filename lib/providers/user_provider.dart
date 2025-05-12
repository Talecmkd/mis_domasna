import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../services/local_storage_service.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;
  bool _isOnline = true; // Track connectivity status

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOnline => _isOnline;

  // Initialize user profile with offline support
  Future<void> initializeUserProfile() async {
    if (_auth.currentUser == null) {
      _userProfile = null;
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final userId = _auth.currentUser!.uid;

      // Try to load from local storage first
      _userProfile = await LocalStorageService.getUserProfile();

      // If online, fetch from Firestore and update local storage
      if (_isOnline) {
        final doc = await _firestore.collection('users').doc(userId).get();

        if (doc.exists) {
          _userProfile = UserProfile.fromMap(doc.data()!);
          // Update local storage
          await LocalStorageService.saveUserProfile(_userProfile!);
        } else if (_userProfile == null) {
          // Create new profile if it doesn't exist anywhere
          _userProfile = UserProfile(
            uid: userId,
            email: _auth.currentUser!.email!,
            name: _auth.currentUser!.displayName ?? 'User',
            photoUrl: _auth.currentUser!.photoURL,
          );
          // Save to both Firestore and local storage
          await _firestore.collection('users').doc(userId).set(_userProfile!.toMap());
          await LocalStorageService.saveUserProfile(_userProfile!);
        }
      }
    } catch (e) {
      print('Error initializing user profile: $e');
      _error = e.toString();
      // If there's an error and we have cached data, use that
      if (_userProfile == null) {
        _userProfile = await LocalStorageService.getUserProfile();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update profile with offline support
  Future<void> updateProfile({
    String? name,
    String? photoUrl,
    String? phoneNumber,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (_userProfile == null) throw Exception('User profile not initialized');
      if (_auth.currentUser == null) throw Exception('No user signed in');

      final userId = _auth.currentUser!.uid;
      final updatedProfile = _userProfile!.copyWith(
        name: name,
        photoUrl: photoUrl,
        phoneNumber: phoneNumber,
      );

      // Save to local storage first
      await LocalStorageService.saveUserProfile(updatedProfile);
      _userProfile = updatedProfile;

      // If online, sync with Firestore
      if (_isOnline) {
        await _firestore
            .collection('users')
            .doc(userId)
            .set(updatedProfile.toMap(), SetOptions(merge: true));
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add address with offline support
  Future<void> addAddress(UserAddress address) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (_auth.currentUser == null) throw Exception('No user signed in');
      if (_userProfile == null) {
        await initializeUserProfile();
        if (_userProfile == null) throw Exception('User profile not initialized');
      }

      final updatedAddresses = [..._userProfile!.addresses, address];
      final updatedProfile = _userProfile!.copyWith(addresses: updatedAddresses);

      // Save to local storage first
      await LocalStorageService.saveUserProfile(updatedProfile);
      _userProfile = updatedProfile;

      // If online, sync with Firestore
      if (_isOnline) {
        await _firestore
            .collection('users')
            .doc(_userProfile!.uid)
            .update({
              'addresses': updatedAddresses.map((addr) => addr.toMap()).toList(),
            });
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Remove address with offline support
  Future<void> removeAddress(int index) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (_userProfile == null) throw Exception('User profile not initialized');
      if (index < 0 || index >= _userProfile!.addresses.length) {
        throw Exception('Invalid address index');
      }

      final updatedAddresses = List<UserAddress>.from(_userProfile!.addresses)..removeAt(index);
      final updatedProfile = _userProfile!.copyWith(addresses: updatedAddresses);

      // Save to local storage first
      await LocalStorageService.saveUserProfile(updatedProfile);
      _userProfile = updatedProfile;

      // If online, sync with Firestore
      if (_isOnline) {
        await _firestore
            .collection('users')
            .doc(_userProfile!.uid)
            .update({
              'addresses': updatedAddresses.map((addr) => addr.toMap()).toList(),
            });
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Set online status and sync if needed
  Future<void> setOnlineStatus(bool isOnline) async {
    _isOnline = isOnline;
    if (isOnline) {
      // Sync local changes with Firestore
      await syncWithFirestore();
    }
    notifyListeners();
  }

  // Sync local data with Firestore
  Future<void> syncWithFirestore() async {
    if (!_isOnline || _userProfile == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_userProfile!.uid)
          .set(_userProfile!.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('Error syncing with Firestore: $e');
    }
  }

  // Clear user profile
  Future<void> clearUserProfile() async {
    _userProfile = null;
    _error = null;
    await LocalStorageService.clearAllData();
    notifyListeners();
  }

  // Add this method before the signOut method
  Future<void> updatePassword(String currentPassword, String newPassword) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) throw Exception('No user signed in');

      // Reauthenticate user before changing password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      
      // Update password
      await user.updatePassword(newPassword);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await clearUserProfile();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }
} 