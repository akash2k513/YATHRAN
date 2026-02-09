import 'package:flutter/material.dart';

class TrendingDestinationsScreen extends StatefulWidget {
  @override
  _TrendingDestinationsScreenState createState() => _TrendingDestinationsScreenState();
}

class _TrendingDestinationsScreenState extends State<TrendingDestinationsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<Map<String, dynamic>> trendingDestinations = [
    {
      'name': 'Santorini, Greece',
      'image': 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=400',
      'trend': '+42%',
      'reason': 'Perfect romantic getaway with stunning views',
      'crowd': 'High',
      'bestFor': ['Romantic', 'Photography', 'Relaxation'],
    },
    {
      'name': 'Kyoto, Japan',
      'image': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=400',
      'trend': '+35%',
      'reason': 'Cultural heritage and cherry blossom season',
      'crowd': 'High',
      'bestFor': ['Cultural', 'Food', 'Nature'],
    },
    {
      'name': 'Bali, Indonesia',
      'image': 'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?w=400',
      'trend': '+28%',
      'reason': 'Affordable luxury and spiritual retreats',
      'crowd': 'Medium',
      'bestFor': ['Adventure', 'Spiritual', 'Nature'],
    },
    {
      'name': 'Swiss Alps',
      'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400', // Fixed URL
      'trend': '+25%',
      'reason': 'Pristine nature and adventure sports',
      'crowd': 'Low',
      'bestFor': ['Adventure', 'Nature', 'Family'],
    },
    {
      'name': 'Dubai, UAE',
      'image': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=400',
      'trend': '+20%',
      'reason': 'Modern architecture and luxury shopping',
      'crowd': 'Medium',
      'bestFor': ['Shopping', 'Luxury', 'Adventure'],
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
              title: Text('Trending Destinations'),
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
                  padding: EdgeInsets.only(bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.trending_up, size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        'AI-powered trending analysis',
                        style: TextStyle(color: Colors.white70),
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
                    child: _buildDestinationCard(destination),
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

  Widget _buildDestinationCard(Map<String, dynamic> destination) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              image: DecorationImage(
                image: NetworkImage(destination['image']),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      destination['trend'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 15,
                  child: Text(
                    destination['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination['reason'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: _getCrowdColor(destination['crowd'])),
                    SizedBox(width: 5),
                    Text(
                      'Crowd: ${destination['crowd']}',
                      style: TextStyle(
                        color: _getCrowdColor(destination['crowd']),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.trending_up, size: 16, color: Colors.green),
                    SizedBox(width: 5),
                    Text(
                      'Trending',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: (destination['bestFor'] as List<String>)
                      .map((category) => Chip(
                    label: Text(category),
                    backgroundColor: Color(0xFF4AB4DE).withOpacity(0.1),
                    labelStyle: TextStyle(fontSize: 12),
                  ))
                      .toList(),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add to trip planning
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2F62A7),
                    minimumSize: Size(double.infinity, 45),
                  ),
                  child: Text('Plan Trip Here'),
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