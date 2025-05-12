import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';

class LocalStorageService {
  static const String userBoxName = 'userBox';
  static const String settingsBoxName = 'settingsBox';
  static const String paymentBoxName = 'paymentBox';

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserProfileAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserAddressAdapter());
    }

    // Open boxes
    await Hive.openBox<UserProfile>(userBoxName);
    await Hive.openBox(settingsBoxName);
    await Hive.openBox(paymentBoxName);
  }

  // User Profile Methods
  static Future<void> saveUserProfile(UserProfile profile) async {
    final box = await Hive.openBox<UserProfile>(userBoxName);
    await box.put('currentUser', profile);
  }

  static Future<UserProfile?> getUserProfile() async {
    final box = await Hive.openBox<UserProfile>(userBoxName);
    return box.get('currentUser');
  }

  // Settings Methods
  static Future<void> saveSetting(String key, dynamic value) async {
    final box = await Hive.openBox(settingsBoxName);
    await box.put(key, value);
  }

  static Future<dynamic> getSetting(String key) async {
    final box = await Hive.openBox(settingsBoxName);
    return box.get(key);
  }

  // Payment Methods
  static Future<void> savePaymentMethod(Map<String, dynamic> paymentInfo) async {
    final box = await Hive.openBox(paymentBoxName);
    await box.put('currentPayment', paymentInfo);
  }

  static Future<Map<String, dynamic>?> getPaymentMethod() async {
    final box = await Hive.openBox(paymentBoxName);
    return box.get('currentPayment');
  }

  // Clear Data
  static Future<void> clearAllData() async {
    await Hive.deleteBoxFromDisk(userBoxName);
    await Hive.deleteBoxFromDisk(settingsBoxName);
    await Hive.deleteBoxFromDisk(paymentBoxName);
  }
} 