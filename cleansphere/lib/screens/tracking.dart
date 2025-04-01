import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class TruckMonitoringScreen extends StatefulWidget {
  const TruckMonitoringScreen({super.key});

  @override
  State<TruckMonitoringScreen> createState() => _TruckMonitoringScreenState();
}

class _TruckMonitoringScreenState extends State<TruckMonitoringScreen> {
  final MapController _mapController = MapController();

  final List<LatLng> _truckLocations = [
    const LatLng(21.1325, 79.0734), // Uday Nagar, Nagpur
    const LatLng(21.1458, 79.0882), // IT Park, Nagpur
    const LatLng(21.1285, 79.1050), // Sakkardara Lake
    const LatLng(21.1451, 79.1004), // Dharampeth College
    const LatLng(21.1335, 79.0844), // Chatrapati Square
    const LatLng(21.1300, 79.0600), // Laxmi Nagar
  ];

  final List<Color> _truckColors = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation(); //
  }

  List<LatLng> _getNearbyTrucks(LatLng userLocation, double radiusKm) {
    List<LatLng> nearbyTrucks = [];

    for (LatLng truck in _truckLocations) {
      double distance = _calculateDistance(userLocation, truck);
      if (distance <= radiusKm) {
        nearbyTrucks.add(truck);
      }
    }

    return nearbyTrucks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Custom app bar height
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreen], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: const Text(
              'Truck Monitoring',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: const LatLng(21.1458, 79.0882),
                zoom: 12.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.app',
                ),

                MarkerLayer(
                  markers: [
                    Marker(
                      point: _myLocation,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.red,
                        size: 45,
                      ),
                    ),
                    ..._nearbyTrucks.map(
                      (truck) => Marker(
                        point: truck,
                        width: 60,
                        height: 60,
                        child: const Icon(
                          Icons.local_shipping,
                          color: Colors.green,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),

                PolylineLayer(
                  polylines:
                      _truckLocations.map((truckLocation) {
                        return Polyline(
                          points: [_myLocation, truckLocation],
                          strokeWidth: 4.0,
                          color: Colors.black.withOpacity(0.6),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),

          // Container(
          //   padding: const EdgeInsets.all(16.0),
          //   color: Colors.white,
          //   child: Column(
          //     children: [
          //       const Text(
          //         'Truck Locations',
          //         style: TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.black,
          //         ),
          //       ),
          //       const SizedBox(height: 10),
          //       _buildTruckInfo(
          //         'Truck 1',
          //         'Mumbai',
          //         'Garbage Collection',
          //         Colors.green,
          //         0,
          //       ),
          //       _buildTruckInfo(
          //         'Truck 2',
          //         'Thane',
          //         'Garbage Disposal',
          //         Colors.blue,
          //         1,
          //       ),
          //       _buildTruckInfo(
          //         'Truck 3',
          //         'Navi Mumbai',
          //         'Garbage Collection',
          //         Colors.orange,
          //         2,
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              children: [
                const Text(
                  'Nearby Truck Locations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                // ✅ Display nearby trucks dynamically
                if (_nearbyTrucks.isEmpty)
                  const Text(
                    'No nearby trucks found.',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  )
                else
                  ..._nearbyTrucks.asMap().entries.map((entry) {
                    int index = entry.key;
                    LatLng truck = entry.value;

                    return _buildTruckInfo(
                      'Truck ${index + 1}',
                      '${truck.latitude.toStringAsFixed(4)}, ${truck.longitude.toStringAsFixed(4)}',
                      'Garbage Collection',
                      Colors.green, // You can randomize or customize colors
                      index,
                    );
                  }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTruckInfo(
    String truck,
    String location,
    String status,
    Color color,
    int index,
  ) {
    String eta = _calculateETA(_nearbyTrucks[index]);
    return Card(
      color: color.withOpacity(0.1),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.local_shipping, color: color),
        title: Text(
          truck,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: Text('$status  • Arrive in: $eta'),
        trailing: Icon(Icons.arrow_forward, color: color),
        onTap: () {
          // Move to the truck location on map
          _mapController.move(_nearbyTrucks[index], 14.0);
        },
      ),
    );
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371.0; // Radius of the Earth in km

    double lat1 = _degreesToRadians(start.latitude);
    double lon1 = _degreesToRadians(start.longitude);
    double lat2 = _degreesToRadians(end.latitude);
    double lon2 = _degreesToRadians(end.longitude);

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // Distance in km
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  LatLng _myLocation = const LatLng(0, 0); // Default value
  List<LatLng> _nearbyTrucks = [];

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _myLocation = LatLng(position.latitude, position.longitude);
      _nearbyTrucks = _getNearbyTrucks(_myLocation, 4.5);
    });

    // Center map on user location
    _mapController.move(_myLocation, 14.0);
  }

  String _calculateETA(LatLng truckLocation) {
    const double truckSpeedKmPerHour = 30.0; // Average truck speed (km/h)

    double distance = _calculateDistance(_myLocation, truckLocation);

    // Time in hours
    double timeInHours = distance / truckSpeedKmPerHour;

    // Convert time to minutes and hours
    int hours = timeInHours.floor();
    int minutes = ((timeInHours - hours) * 60).round();

    if (hours > 0) {
      return '$hours hr ${minutes} min';
    } else {
      return '$minutes min';
    }
  }
}
