import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  bool _isLoading = true;
  String? _error;
  bool _isSearchingStores = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final position = await LocationService.getCurrentLocation();
      if (position == null) {
        throw Exception('Unable to get location. Please try again.');
      }

      if (mounted) {
        setState(() {
          _currentPosition = position;
          _markers.add(
            Marker(
              markerId: MarkerId('currentLocation'),
              position: LatLng(position.latitude, position.longitude),
              infoWindow: InfoWindow(title: 'Your Location'),
            ),
          );
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception:', '').trim();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  Future<void> _openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  void _animateToCurrentLocation() {
    if (_mapController != null && _currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 15,
          ),
        ),
      );
    }
  }

  Future<void> _searchNearbyPetStores() async {
    if (_currentPosition == null) return;

    try {
      setState(() {
        _isSearchingStores = true;
      });

      final stores = await LocationService.getNearbyPetStores(_currentPosition!);
      
      if (mounted) {
        setState(() {
          // Keep the current location marker
          final currentLocationMarker = _markers.firstWhere(
            (marker) => marker.markerId == MarkerId('currentLocation'),
            orElse: () => Marker(
              markerId: MarkerId('currentLocation'),
              position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            ),
          );

          // Clear existing markers and add back the current location
          _markers.clear();
          _markers.add(currentLocationMarker);

          // Add markers for pet stores
          for (final store in stores) {
            final location = store['geometry']['location'];
            _markers.add(
              Marker(
                markerId: MarkerId('store_${store['place_id']}'),
                position: LatLng(location['lat'], location['lng']),
                infoWindow: InfoWindow(
                  title: store['name'],
                  snippet: store['vicinity'],
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              ),
            );
          }

          _isSearchingStores = false;
        });

        // Adjust camera to show all markers
        if (stores.isNotEmpty) {
          _fitMarkersOnScreen();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearchingStores = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to find nearby pet stores. Please try again.'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _searchNearbyPetStores,
            ),
          ),
        );
      }
    }
  }

  Future<void> _fitMarkersOnScreen() async {
    if (_markers.isEmpty || _mapController == null) return;

    double minLat = 90.0;
    double maxLat = -90.0;
    double minLng = 180.0;
    double maxLng = -180.0;

    for (final marker in _markers) {
      if (marker.position.latitude < minLat) minLat = marker.position.latitude;
      if (marker.position.latitude > maxLat) maxLat = marker.position.latitude;
      if (marker.position.longitude < minLng) minLng = marker.position.longitude;
      if (marker.position.longitude > maxLng) maxLng = marker.position.longitude;
    }

    await _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        100.0, // padding
      ),
    );
  }

  Widget _buildErrorWidget() {
    String buttonText = 'Try Again';
    VoidCallback action = _initializeMap;
    
    if (_error!.contains('permission')) {
      buttonText = 'Open Settings';
      action = _openAppSettings;
    } else if (_error!.contains('disabled') || _error!.contains('Location services')) {
      buttonText = 'Open Location Settings';
      action = _openLocationSettings;
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: action,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1AE51A),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 16, color: Color(0xFF1C170D)),
              ),
            ),
            if (buttonText != 'Try Again') ...[
              SizedBox(height: 12),
              TextButton(
                onPressed: _initializeMap,
                child: Text('Try Again Instead'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Pet Stores'),
        backgroundColor: Color(0xFFF7FCF7),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF0D1C0D)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!_isLoading && _error == null && _currentPosition != null) ...[
            FloatingActionButton(
              heroTag: 'search',
              backgroundColor: Color(0xFF1AE51A),
              onPressed: _isSearchingStores ? null : _searchNearbyPetStores,
              child: _isSearchingStores
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Color(0xFF1C170D),
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(Icons.search, color: Color(0xFF1C170D)),
            ),
            SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'location',
              backgroundColor: Color(0xFF1AE51A),
              child: Icon(Icons.my_location, color: Color(0xFF1C170D)),
              onPressed: _initializeMap,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF1AE51A)),
            SizedBox(height: 16),
            Text('Getting your location...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return _buildErrorWidget();
    }

    if (_currentPosition == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'Unable to get location',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _initializeMap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1AE51A),
              ),
              child: Text('Try Again'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
            zoom: 15,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (controller) {
            setState(() {
              _mapController = controller;
            });
          },
        ),
        if (_isSearchingStores)
          Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF1AE51A)),
                  SizedBox(height: 16),
                  Text(
                    'Searching for nearby pet stores...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
} 