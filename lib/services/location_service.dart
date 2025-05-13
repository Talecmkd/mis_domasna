import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class LocationService {
  static const String _apiKey = 'AIzaSyC_N29FtMULYYVuOZJvsI4P1DxuDqktDyU'; // Your Google Maps API key

  static Future<bool> requestLocationPermission() async {
    try {
      final status = await Permission.location.request();
      if (status.isPermanentlyDenied) {
        throw Exception('Location permission permanently denied. Please enable it in app settings.');
      }
      return status.isGranted;
    } catch (e) {
      throw Exception('Failed to request location permission: $e');
    }
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      // First check location permission
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        throw Exception('Location permission not granted. Please allow location access to use this feature.');
      }

      // Then check if location service is enabled
      final isEnabled = await isLocationEnabled();
      if (!isEnabled) {
        throw Exception('Location services are disabled. Please enable location services in your device settings.');
      }

      // Try to get location with timeout
      try {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 5),
        ).timeout(
          Duration(seconds: 10),
          onTimeout: () => throw TimeoutException('Location request timed out. Please check your internet connection and try again.'),
        );
      } on LocationServiceDisabledException {
        throw Exception('Location services are disabled. Please enable location services in your device settings.');
      } on PermissionDeniedException {
        throw Exception('Location permission denied. Please allow location access to use this feature.');
      } on TimeoutException {
        throw Exception('Location request timed out. Please check your internet connection and try again.');
      }
    } catch (e) {
      print('Error getting location: $e');
      // Rethrow the exception with our custom message if it's not already a custom exception
      if (!e.toString().contains('Exception:')) {
        throw Exception('Unable to get location. Please check your device settings and try again.');
      }
      rethrow;
    }
  }

  static Future<bool> isLocationEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      throw Exception('Failed to check location services status: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getNearbyPetStores(Position position) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
        'location=${position.latitude},${position.longitude}'
        '&radius=5000' // 5km radius
        '&type=pet_store'
        '&keyword=pet'
        '&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return List<Map<String, dynamic>>.from(data['results']);
        } else {
          throw Exception('Failed to fetch pet stores: ${data['status']}');
        }
      } else {
        throw Exception('Failed to fetch pet stores: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pet stores: $e');
      throw Exception('Failed to fetch nearby pet stores. Please try again.');
    }
  }

  static Stream<Position> getLocationUpdates() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.medium,
      distanceFilter: 50,
      timeLimit: Duration(seconds: 5),
    );
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }
} 