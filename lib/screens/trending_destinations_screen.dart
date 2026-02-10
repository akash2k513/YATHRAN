import 'package:flutter/material.dart';
import 'package:yathran/screens/trip_creation_screen.dart'; // Add this import

class TrendingDestinationsScreen extends StatefulWidget {
  @override
  _TrendingDestinationsScreenState createState() => _TrendingDestinationsScreenState();
}

class _TrendingDestinationsScreenState extends State<TrendingDestinationsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<Map<String, dynamic>> trendingDestinations = [
    {
      'id': '1',
      'name': 'Santorini, Greece',
      'image': 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=400',
      'trend': '+42%',
      'reason': 'Perfect romantic getaway with stunning views',
      'crowd': 'High',
      'bestFor': ['Romantic', 'Photography', 'Relaxation'],
      'rating': 4.8,
      'priceRange': '\$1,500-\$3,000',
      'bestTime': 'May - October',
    },
    {
      'id': '2',
      'name': 'Kyoto, Japan',
      'image': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=400',
      'trend': '+35%',
      'reason': 'Cultural heritage and cherry blossom season',
      'crowd': 'High',
      'bestFor': ['Cultural', 'Food', 'Nature'],
      'rating': 4.7,
      'priceRange': '\$1,200-\$2,500',
      'bestTime': 'Spring & Autumn',
    },
    {
      'id': '3',
      'name': 'Bali, Indonesia',
      'image': 'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?w=400',
      'trend': '+28%',
      'reason': 'Affordable luxury and spiritual retreats',
      'crowd': 'Medium',
      'bestFor': ['Adventure', 'Spiritual', 'Nature'],
      'rating': 4.6,
      'priceRange': '\$800-\$1,500',
      'bestTime': 'April - October',
    },
    {
      'id': '4',
      'name': 'Swiss Alps',
      'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
      'trend': '+25%',
      'reason': 'Pristine nature and adventure sports',
      'crowd': 'Low',
      'bestFor': ['Adventure', 'Nature', 'Family'],
      'rating': 4.9,
      'priceRange': '\$2,000-\$4,000',
      'bestTime': 'June - September',
    },
    {
      'id': '5',
      'name': 'Dubai, UAE',
      'image': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=400',
      'trend': '+20%',
      'reason': 'Modern architecture and luxury shopping',
      'crowd': 'Medium',
      'bestFor': ['Shopping', 'Luxury', 'Adventure'],
      'rating': 4.5,
      'priceRange': '\$1,800-\$3,500',
      'bestTime': 'November - March',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showTripPlanningDialog(BuildContext context, Map<String, dynamic> destination) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Plan Trip to ${destination['name']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Great choice! ${destination['name']} is trending at ${destination['trend']}.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 15),
              ListTile(
                leading: Icon(Icons.star, color: Colors.amber),
                title: Text('Rating'),
                subtitle: Text('${destination['rating']}/5.0'),
              ),
              ListTile(
                leading: Icon(Icons.people, color: _getCrowdColor(destination['crowd'])),
                title: Text('Crowd Level'),
                subtitle: Text(destination['crowd']),
              ),
              ListTile(
                leading: Icon(Icons.attach_money, color: Colors.green),
                title: Text('Price Range'),
                subtitle: Text(destination['priceRange']),
              ),
              ListTile(
                leading: Icon(Icons.calendar_today, color: Color(0xFF4AB4DE)),
                title: Text('Best Time'),
                subtitle: Text(destination['bestTime']),
              ),
              SizedBox(height: 10),
              Text(
                'Perfect for:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Wrap(
                spacing: 8,
                children: (destination['bestFor'] as List<String>)
                    .map((category) => Chip(
                  label: Text(category),
                  backgroundColor: Color(0xFF4AB4DE).withOpacity(0.1),
                ))
                    .toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog

              // Navigate to TripCreationScreen with destination data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TripCreationScreen(
                    destinationData: destination,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2F62A7),
            ),
            child: Text('Create Trip Plan'),
          ),
        ],
      ),
    );
  }

  void _showTripSuccessSnackbar(BuildContext context, String destinationName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trip Planned Successfully!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Your trip to $destinationName has been added to your itinerary.'),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'View Itinerary',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to itinerary screen
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEDBCC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: Color(0xFF2F62A7),
            flexibleSpace: FlexibleSpaceBar(
              // REMOVED the title property to prevent overlapping
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2F62A7),
                      Color(0xFF3B8AC3),
                      Color(0xFF4AB4DE),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 50), // Increased from 30 to 50
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40), // Added spacing at top
                      Icon(Icons.trending_up, size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        'Trending Destinations', // Moved from title to here
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'AI-powered trending analysis',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final destination = trendingDestinations[index];
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildDestinationCard(destination, context),
                  );
                },
                childCount: trendingDestinations.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(Map<String, dynamic> destination, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Section
          Container(
            height: 220,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(destination['image']),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // Trend Badge
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.trending_up, size: 14, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          destination['trend'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Destination Name
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Text(
                    destination['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reason
                Text(
                  destination['reason'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 15),

                // Stats Row
                Row(
                  children: [
                    // Crowd Level
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getCrowdColor(destination['crowd']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getCrowdColor(destination['crowd']).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.people, size: 14, color: _getCrowdColor(destination['crowd'])),
                          SizedBox(width: 6),
                          Text(
                            destination['crowd'],
                            style: TextStyle(
                              color: _getCrowdColor(destination['crowd']),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),

                    // Rating
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amber.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          SizedBox(width: 6),
                          Text(
                            '${destination['rating']}',
                            style: TextStyle(
                              color: Colors.amber[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),

                    // Best Time
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFF4AB4DE).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xFF4AB4DE).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: Color(0xFF4AB4DE)),
                          SizedBox(width: 6),
                          Text(
                            destination['bestTime'],
                            style: TextStyle(
                              color: Color(0xFF4AB4DE),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                // Categories
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (destination['bestFor'] as List<String>)
                      .map((category) => Chip(
                    label: Text(
                      category,
                      style: TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Color(0xFF4AB4DE).withOpacity(0.1),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ))
                      .toList(),
                ),
                SizedBox(height: 20),

                // Plan Trip Button - UPDATED
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to TripCreationScreen with destination data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TripCreationScreen(
                            destinationData: destination,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.airplanemode_active, size: 20),
                    label: Text(
                      'Plan Trip Here',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2F62A7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCrowdColor(String crowdLevel) {
    switch (crowdLevel.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}