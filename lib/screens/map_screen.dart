import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yathran/services/notification_service.dart';

class MapScreen extends StatefulWidget {
  final bool showCrowdHeatmap;
  final LatLng? initialCenter;
  final List<MapMarker>? markers;

  MapScreen({
    this.showCrowdHeatmap = true,
    this.initialCenter,
    this.markers,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  late MapController _mapController;
  LatLng? _currentLocation;
  List<CrowdZone> _crowdZones = [];
  List<MapMarker> _markers = [];
  bool _isLoading = true;
  bool _showCrowdHeatmap = true;
  bool _showMarkers = true;
  bool _showTraffic = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _requestLocationPermission();
    await _getCurrentLocation();
    await _loadCrowdData();
    await _loadMarkers();

    setState(() => _isLoading = false);
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      print('Location permission granted');
    } else {
      NotificationService().sendNotification(
        context: context,
        title: 'Location Access Required',
        message: 'Enable location to see crowd data',
        type: 'warning',
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      // Default to Paris if location fails
      setState(() {
        _currentLocation = LatLng(48.8566, 2.3522); // Paris
      });
    }
  }

  Future<void> _loadCrowdData() async {
    // Simulated crowd data - in real app, fetch from API
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _crowdZones = [
        CrowdZone(
          center: LatLng(48.8584, 2.2945), // Eiffel Tower
          radius: 200,
          crowdLevel: 'Very High',
          lastUpdated: DateTime.now().subtract(Duration(minutes: 30)),
          confidence: 0.9,
        ),
        CrowdZone(
          center: LatLng(48.8606, 2.3376), // Louvre
          radius: 150,
          crowdLevel: 'High',
          lastUpdated: DateTime.now().subtract(Duration(minutes: 45)),
          confidence: 0.8,
        ),
        CrowdZone(
          center: LatLng(48.8867, 2.3431), // Montmartre
          radius: 300,
          crowdLevel: 'Medium',
          lastUpdated: DateTime.now().subtract(Duration(minutes: 60)),
          confidence: 0.7,
        ),
        CrowdZone(
          center: LatLng(48.8595, 2.2936), // Seine River
          radius: 100,
          crowdLevel: 'Low',
          lastUpdated: DateTime.now().subtract(Duration(minutes: 90)),
          confidence: 0.6,
        ),
      ];
    });
  }

  Future<void> _loadMarkers() async {
    // Load markers from widget or default markers
    if (widget.markers != null && widget.markers!.isNotEmpty) {
      _markers = widget.markers!;
    } else {
      // Default markers for demonstration
      _markers = [
        MapMarker(
          position: LatLng(48.8584, 2.2945),
          title: 'Eiffel Tower',
          description: 'Iconic iron lattice tower',
          type: 'landmark',
          crowdLevel: 'Very High',
        ),
        MapMarker(
          position: LatLng(48.8606, 2.3376),
          title: 'Louvre Museum',
          description: 'World\'s largest art museum',
          type: 'museum',
          crowdLevel: 'High',
        ),
        MapMarker(
          position: LatLng(48.8867, 2.3431),
          title: 'Montmartre',
          description: 'Historic artists district',
          type: 'cultural',
          crowdLevel: 'Medium',
        ),
        MapMarker(
          position: LatLng(48.8595, 2.2936),
          title: 'Seine River Cruise',
          description: 'Scenic boat tour',
          type: 'activity',
          crowdLevel: 'Low',
        ),
      ];
    }
  }

  Color _getCrowdColor(String crowdLevel) {
    switch (crowdLevel.toLowerCase()) {
      case 'very high':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.yellow;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getCrowdBorderColor(String crowdLevel) {
    switch (crowdLevel.toLowerCase()) {
      case 'very high':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.yellow;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getMarkerIcon(String type) {
    switch (type.toLowerCase()) {
      case 'landmark':
        return Icons.flag;
      case 'museum':
        return Icons.museum;
      case 'cultural':
        return Icons.account_balance;
      case 'activity':
        return Icons.directions_boat;
      case 'restaurant':
        return Icons.restaurant;
      case 'shopping':
        return Icons.shopping_cart;
      default:
        return Icons.place;
    }
  }

  Widget _buildAnimatedMarker(MapMarker marker) {
    return MarkerLayer(
      markers: [
        Marker(
          point: marker.position,
          width: 50,
          height: 50,
          builder: (context) => GestureDetector(
            onTap: () => _showMarkerDetails(marker),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + 0.1 * _animationController.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _getCrowdBorderColor(marker.crowdLevel).withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                      border: Border.all(
                        color: _getCrowdBorderColor(marker.crowdLevel),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _getMarkerIcon(marker.type),
                        color: _getCrowdBorderColor(marker.crowdLevel),
                        size: 24,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showMarkerDetails(MapMarker marker) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildMarkerBottomSheet(marker),
    );
  }

  Widget _buildMarkerBottomSheet(MapMarker marker) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getCrowdColor(marker.crowdLevel).withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getCrowdBorderColor(marker.crowdLevel),
                    width: 2,
                  ),
                ),
                child: Icon(
                  _getMarkerIcon(marker.type),
                  color: _getCrowdBorderColor(marker.crowdLevel),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      marker.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F62A7),
                      ),
                    ),
                    Text(
                      marker.description,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Crowd Information
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: _getCrowdColor(marker.crowdLevel).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _getCrowdBorderColor(marker.crowdLevel),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.people, color: _getCrowdBorderColor(marker.crowdLevel)),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Crowd Level: ${marker.crowdLevel}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getCrowdBorderColor(marker.crowdLevel),
                        ),
                      ),
                      Text(
                        'Updated 30 minutes ago',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getCrowdBorderColor(marker.crowdLevel),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    marker.crowdLevel,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          // Alternative Suggestions
          if (marker.crowdLevel == 'High' || marker.crowdLevel == 'Very High')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Less Crowded Alternatives:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildAlternativeSuggestion('Arc de Triomphe', '15 mins away', 'Low'),
                _buildAlternativeSuggestion('Musée d\'Orsay', '20 mins away', 'Medium'),
                _buildAlternativeSuggestion('Luxembourg Gardens', '25 mins away', 'Low'),
              ],
            ),

          SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Add to itinerary
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add to Trip'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF4AB4DE)),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Get directions
                    _showDirections(marker);
                  },
                  icon: Icon(Icons.directions),
                  label: Text('Directions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2F62A7),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildAlternativeSuggestion(String name, String distance, String crowdLevel) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _getCrowdColor(crowdLevel),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                crowdLevel[0],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(distance, style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  void _showDirections(MapMarker marker) {
    NotificationService().sendRouteUpdate(
      context,
      'Directions to ${marker.title} calculated',
      15,
    );

    // In real app, open navigation with the route
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Directions to ${marker.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.directions_walk, color: Color(0xFF4AB4DE)),
              title: Text('Walking'),
              subtitle: Text('25 minutes • 2.1 km'),
            ),
            ListTile(
              leading: Icon(Icons.directions_bus, color: Color(0xFF4AB4DE)),
              title: Text('Public Transport'),
              subtitle: Text('15 minutes • 1 transfer'),
            ),
            ListTile(
              leading: Icon(Icons.directions_car, color: Color(0xFF4AB4DE)),
              title: Text('Car/Taxi'),
              subtitle: Text('10 minutes • Traffic: Medium'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              NotificationService().sendNotification(
                context: context,
                title: 'Navigation Started',
                message: 'Follow the route to ${marker.title}',
                type: 'success',
              );
            },
            child: Text('Start Navigation'),
          ),
        ],
      ),
    );
  }

  void _zoomToLocation(LatLng location) {
    _mapController.move(location, 16);
  }

  void _toggleCrowdHeatmap() {
    setState(() => _showCrowdHeatmap = !_showCrowdHeatmap);
  }

  void _toggleMarkers() {
    setState(() => _showMarkers = !_showMarkers);
  }

  void _toggleTraffic() {
    setState(() => _showTraffic = !_showTraffic);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Color(0xFF2F62A7),
        ),
      );
    }

    final center = widget.initialCenter ?? _currentLocation ?? LatLng(48.8566, 2.3522);

    return Scaffold(
      backgroundColor: Color(0xFFEEDBCC),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: center,
              zoom: 13.0,
              maxZoom: 18.0,
              minZoom: 3.0,
              interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
            children: [
              // OpenStreetMap Tile Layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.yathran.app',
              ),

              // Traffic Layer (if enabled)
              if (_showTraffic)
                TileLayer(
                  urlTemplate: 'https://{s}.tile.thunderforest.com/transport/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),

              // Crowd Heatmap Layers (Circle Markers instead of CircleLayer)
              if (_showCrowdHeatmap)
                for (var zone in _crowdZones)
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: zone.center,
                        radius: zone.radius / 2, // Adjusted for better visibility
                        color: _getCrowdColor(zone.crowdLevel).withOpacity(0.3),
                        borderColor: _getCrowdBorderColor(zone.crowdLevel),
                        borderStrokeWidth: 2.0,
                      ),
                    ],
                  ),

              // Markers
              if (_showMarkers)
                for (var marker in _markers)
                  _buildAnimatedMarker(marker),

              // Current Location Marker
              MarkerLayer(
                markers: [
                  if (_currentLocation != null)
                    Marker(
                      point: _currentLocation!,
                      width: 40,
                      height: 40,
                      builder: (context) => Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Top Controls
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search places or addresses...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Color(0xFF4AB4DE)),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.my_location, color: Color(0xFF4AB4DE)),
                    onPressed: () {
                      if (_currentLocation != null) {
                        _zoomToLocation(_currentLocation!);
                      }
                    },
                  ),
                ),
                onSubmitted: (query) {
                  // Search functionality
                },
              ),
            ),
          ),

          // Crowd Legend
          Positioned(
            top: 120,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Crowd Levels',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F62A7),
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildLegendItem('Very High', Colors.red),
                  _buildLegendItem('High', Colors.orange),
                  _buildLegendItem('Medium', Colors.yellow),
                  _buildLegendItem('Low', Colors.green),
                ],
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 100,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  onPressed: _toggleCrowdHeatmap,
                  backgroundColor: _showCrowdHeatmap ? Color(0xFF2F62A7) : Colors.grey,
                  child: Icon(
                    Icons.whatshot,
                    color: Colors.white,
                  ),
                  tooltip: 'Toggle Crowd Heatmap',
                ),
                SizedBox(height: 10),
                FloatingActionButton.small(
                  onPressed: _toggleMarkers,
                  backgroundColor: _showMarkers ? Color(0xFF3B8AC3) : Colors.grey,
                  child: Icon(
                    Icons.place,
                    color: Colors.white,
                  ),
                  tooltip: 'Toggle Markers',
                ),
                SizedBox(height: 10),
                FloatingActionButton.small(
                  onPressed: _toggleTraffic,
                  backgroundColor: _showTraffic ? Color(0xFF4AB4DE) : Colors.grey,
                  child: Icon(
                    Icons.traffic,
                    color: Colors.white,
                  ),
                  tooltip: 'Toggle Traffic',
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    if (_currentLocation != null) {
                      _zoomToLocation(_currentLocation!);
                    }
                  },
                  backgroundColor: Color(0xFF2F62A7),
                  child: Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                  tooltip: 'My Location',
                ),
              ],
            ),
          ),

          // Crowd Summary
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.insights, color: Color(0xFF4AB4DE)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Crowd Summary',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F62A7),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${_crowdZones.length} areas monitored • ${_crowdZones.where((z) => z.crowdLevel == 'High' || z.crowdLevel == 'Very High').length} crowded zones',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Show detailed crowd report
                      _showCrowdReport();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4AB4DE),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    child: Text('Details'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  void _showCrowdReport() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crowd Analysis Report',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F62A7),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Last Updated: ${DateTime.now().toString()}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            for (var zone in _crowdZones)
              Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getCrowdColor(zone.crowdLevel).withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getCrowdBorderColor(zone.crowdLevel),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.people,
                          color: _getCrowdBorderColor(zone.crowdLevel),
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Radius: ${zone.radius}m • Confidence: ${(zone.confidence * 100).toInt()}%',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Crowd Level: ${zone.crowdLevel}',
                            style: TextStyle(
                              color: _getCrowdBorderColor(zone.crowdLevel),
                            ),
                          ),
                          Text(
                            'Updated: ${zone.lastUpdated.difference(DateTime.now()).inMinutes.abs()} mins ago',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2F62A7),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Close Report'),
            ),
          ],
        ),
      ),
    );
  }
}

class CrowdZone {
  final LatLng center;
  final double radius; // in meters
  final String crowdLevel;
  final DateTime lastUpdated;
  final double confidence;

  CrowdZone({
    required this.center,
    required this.radius,
    required this.crowdLevel,
    required this.lastUpdated,
    required this.confidence,
  });
}

class MapMarker {
  final LatLng position;
  final String title;
  final String description;
  final String type;
  final String crowdLevel;

  MapMarker({
    required this.position,
    required this.title,
    required this.description,
    required this.type,
    required this.crowdLevel,
  });
}