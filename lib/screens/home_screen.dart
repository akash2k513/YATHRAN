import 'package:flutter/material.dart';
import 'package:yathran/screens/trip_creation_screen.dart';
import 'package:yathran/screens/profile_screen.dart';
import 'package:yathran/screens/trending_destinations_screen.dart';
import 'package:yathran/screens/crowd_insights_screen.dart';
import 'package:yathran/screens/map_screen.dart';
import 'package:yathran/screens/settings_screen.dart';
import 'package:yathran/models/trip_model.dart';
import 'package:provider/provider.dart';
import 'package:yathran/services/auth_service.dart';
import 'package:yathran/services/notification_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final PageController _carouselController = PageController(viewportFraction: 0.85);
  int _currentCarouselIndex = 0;

  // Top Places Carousel Data
  final List<Map<String, dynamic>> topPlaces = [
    {
      'id': '1',
      'name': 'Santorini, Greece',
      'image': 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=800&h=400&fit=crop',
      'description': 'White-washed buildings with stunning sunset views',
      'crowdLevel': 'Medium',
      'bestTime': 'May - October',
      'moods': ['Romantic', 'Photography', 'Relaxation'],
      'priceRange': '2200 USD',
    },
    {
      'id': '2',
      'name': 'Kyoto, Japan',
      'image': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800&h=400&fit=crop',
      'description': 'Ancient temples and traditional culture',
      'crowdLevel': 'High',
      'bestTime': 'Spring & Autumn',
      'moods': ['Cultural', 'Spiritual', 'Food Exploration'],
      'priceRange': '2400 USD',
    },
    {
      'id': '3',
      'name': 'Swiss Alps',
      'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=400&fit=crop',
      'description': 'Majestic mountains and adventure sports',
      'crowdLevel': 'Low',
      'bestTime': 'June - September',
      'moods': ['Adventure', 'Nature', 'Family'],
      'priceRange': '3500 USD',
    },
    {
      'id': '4',
      'name': 'Bali, Indonesia',
      'image': 'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?w=800&h=400&fit=crop',
      'description': 'Tropical paradise with spiritual retreats',
      'crowdLevel': 'Medium',
      'bestTime': 'April - October',
      'moods': ['Adventure', 'Relaxation', 'Spiritual'],
      'priceRange': '1000 USD',
    },
    {
      'id': '5',
      'name': 'Dubai, UAE',
      'image': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800&h=400&fit=crop',
      'description': 'Modern architecture and luxury experiences',
      'crowdLevel': 'High',
      'bestTime': 'November - March',
      'moods': ['Shopping', 'Luxury', 'Adventure'],
      'priceRange': '10000 USD',
    },
  ];

  // AI Travel Suggestions based on user history
  List<Map<String, dynamic>> aiSuggestions = [
    {
      'destination': 'Bali, Indonesia',
      'reason': 'Perfect for Adventure & Nature lovers',
      'moods': ['Adventure', 'Nature', 'Relaxation'],
      'crowdLevel': 'Medium',
      'bestTime': 'April - October',
    },
    {
      'destination': 'Kyoto, Japan',
      'reason': 'Best for Cultural & Food Experience',
      'moods': ['Cultural', 'Food Exploration', 'Photography'],
      'crowdLevel': 'High',
      'bestTime': 'Spring & Autumn',
    },
    {
      'destination': 'Swiss Alps',
      'reason': 'Ideal for Nature & Adventure',
      'moods': ['Nature', 'Adventure', 'Family'],
      'crowdLevel': 'Low',
      'bestTime': 'June - September',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    // Auto-rotate carousel
    _startCarouselAutoRotation();
  }

  void _startCarouselAutoRotation() {
    Future.delayed(Duration(seconds: 5), () {
      if (_carouselController.hasClients && mounted) {
        int nextPage = _currentCarouselIndex + 1;
        if (nextPage >= topPlaces.length) nextPage = 0;
        _carouselController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startCarouselAutoRotation();
      }
    });
  }

  void _logout() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.logout();
    Navigator.pushReplacementNamed(context, '/auth');
  }

  void _showProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(),
      ),
    );
  }

  void _showSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
  }

  void _viewTrendingDestinations() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrendingDestinationsScreen(),
      ),
    );
  }

  void _viewCrowdInsights() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrowdInsightsScreen(),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
      // Home - already here
        break;
      case 1:
      // Explore - show map
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapScreen(
              showCrowdHeatmap: true,
            ),
          ),
        );
        break;
      case 2:
      // AI Companion
        Navigator.pushNamed(context, '/ai-companion');
        break;
      case 3:
      // Settings
        _showSettings();
        break;
    }
  }

  Color _getCrowdColor(String crowdLevel) {
    switch (crowdLevel.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Color(0xFFEEDBCC),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // App Bar with user info
            SliverAppBar(
              expandedHeight: 150.0,
              floating: false,
              pinned: true,
              backgroundColor: Color(0xFF2F62A7),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'YĀTHRAN',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
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
                    padding: EdgeInsets.only(top: 100, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, ${authService.currentUser?.name ?? 'Traveler'}!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Ready for your next adventure?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    NotificationService().sendNotification(
                      context: context,
                      title: 'Smart Alert',
                      message: 'No new notifications. All systems operational.',
                      type: 'info',
                    );
                  },
                ),
              ],
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Places Carousel
                    _buildTopPlacesCarousel(),
                    SizedBox(height: 30),

                    // Quick Features Grid - Improved UI
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F62A7),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Everything you need for smart travel planning',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 15),
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.4,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      children: [
                        _buildQuickAction(
                          title: 'Plan New Trip',
                          icon: Icons.add_location_alt,
                          color: Color(0xFF2F62A7),
                          gradientColors: [
                            Color(0xFF2F62A7),
                            Color(0xFF3B8AC3),
                          ],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripCreationScreen(),
                              ),
                            );
                          },
                        ),
                        _buildQuickAction(
                          title: 'Live Map',
                          icon: Icons.map,
                          color: Color(0xFF4AB4DE),
                          gradientColors: [
                            Color(0xFF4AB4DE),
                            Color(0xFF3B8AC3),
                          ],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapScreen(
                                  showCrowdHeatmap: true,
                                ),
                              ),
                            );
                          },
                        ),
                        _buildQuickAction(
                          title: 'Trending',
                          icon: Icons.trending_up,
                          color: Color(0xFF4AB4DE),
                          gradientColors: [
                            Color(0xFF4AB4DE),
                            Color(0xFF3B8AC3),
                          ],
                          onTap: _viewTrendingDestinations,
                        ),
                        _buildQuickAction(
                          title: 'Crowd Insights',
                          icon: Icons.insights,
                          color: Color(0xFF2F62A7),
                          gradientColors: [
                            Color(0xFF2F62A7),
                            Color(0xFF3B8AC3),
                          ],
                          onTap: _viewCrowdInsights,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    // AI Travel Suggestions
                    _buildSectionHeader(
                      title: 'AI Travel Suggestions',
                      subtitle: 'Personalized based on your interests',
                    ),
                    SizedBox(height: 10),
                    ...aiSuggestions.map((suggestion) => _buildSuggestionCard(suggestion)).toList(),
                    SizedBox(height: 20),

                    // Popular Categories
                    _buildSectionHeader(
                      title: 'Popular Categories',
                      subtitle: 'Browse by travel interests',
                    ),
                    SizedBox(height: 10),
                    _buildCategoryGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTopPlacesCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Places to Visit Now',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F62A7),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF4AB4DE).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFF4AB4DE)),
              ),
              child: Text(
                '${_currentCarouselIndex + 1}/${topPlaces.length}',
                style: TextStyle(
                  color: Color(0xFF4AB4DE),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'AI-curated destinations based on current season and crowd levels',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 20),
        // FIXED: Added height constraint to prevent overflow
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 300, // Increased to accommodate all content
          ),
          child: PageView.builder(
            controller: _carouselController,
            itemCount: topPlaces.length,
            onPageChanged: (index) {
              setState(() => _currentCarouselIndex = index);
            },
            itemBuilder: (context, index) {
              final place = topPlaces[index];
              return _buildCarouselItem(place, index);
            },
          ),
        ),
        SizedBox(height: 15),
        Center(
          child: SmoothPageIndicator(
            controller: _carouselController,
            count: topPlaces.length,
            effect: ExpandingDotsEffect(
              activeDotColor: Color(0xFF2F62A7),
              dotColor: Colors.grey[300]!,
              dotHeight: 8,
              dotWidth: 8,
              spacing: 8,
              expansionFactor: 3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(Map<String, dynamic> place, int index) {
    bool isActive = index == _currentCarouselIndex;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isActive ? 0.2 : 0.1),
            blurRadius: isActive ? 20 : 10,
            spreadRadius: isActive ? 2 : 1,
            offset: Offset(0, isActive ? 5 : 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 280, // Fixed height to prevent overflow
          child: Stack(
            children: [
              // Background Image
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(place['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                    ],
                  ),
                ),
              ),

              // Content - Added constraints to prevent text overflow
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Crowd Level Badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getCrowdColor(place['crowdLevel']).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people, size: 14, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            place['crowdLevel'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),

                    // Place Name
                    Text(
                      place['name'],
                      style: TextStyle(
                        fontSize: 20, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),

                    // Description
                    Text(
                      place['description'],
                      style: TextStyle(
                        fontSize: 13, // Reduced font size
                        color: Colors.white.withOpacity(0.9),
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),

                    // Details Row
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 12, color: Colors.white70),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            place['bestTime'],
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 15),
                        Icon(Icons.attach_money, size: 12, color: Colors.white70),
                        SizedBox(width: 4),
                        Text(
                          place['priceRange'],
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Mood Tags - Limited to 2 lines
                    Container(
                      height: 32, // Fixed height for tags
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: (place['moods'] as List<String>)
                            .take(3)
                            .map((mood) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Text(
                            mood,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9, // Reduced font size
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Action Buttons - Made more compact
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TripCreationScreen(),
                                ),
                              );
                            },
                            icon: Icon(Icons.airplanemode_active, size: 14),
                            label: Text('Plan Trip', style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2F62A7),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.info_outline, color: Colors.white, size: 18),
                            onPressed: () {
                              _showPlaceDetails(place);
                            },
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Favorite Button
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.favorite_border, color: Colors.white, size: 18),
                    onPressed: () {
                      NotificationService().sendNotification(
                        context: context,
                        title: 'Added to Favorites',
                        message: '${place['name']} added to your favorites',
                        type: 'success',
                      );
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required String title,
    required IconData icon,
    required Color color,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: 10,
              bottom: 10,
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  icon,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2F62A7),
          ),
        ),
        SizedBox(height: 5),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionCard(Map<String, dynamic> suggestion) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TripCreationScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4AB4DE),
                      Color(0xFF3B8AC3),
                    ],
                  ),
                ),
                child: Icon(Icons.lightbulb_outline, color: Colors.white, size: 30),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion['destination'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F62A7),
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(
                      suggestion['reason'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getCrowdColor(suggestion['crowdLevel']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.people, size: 12, color: _getCrowdColor(suggestion['crowdLevel'])),
                              SizedBox(width: 4),
                              Text(
                                suggestion['crowdLevel'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _getCrowdColor(suggestion['crowdLevel']),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          suggestion['bestTime'],
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Color(0xFF4AB4DE)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    List<Map<String, dynamic>> categories = [
      {
        'title': 'Beach',
        'icon': Icons.beach_access,
        'color': Colors.blue,
        'count': '12 places',
      },
      {
        'title': 'Mountain',
        'icon': Icons.terrain,
        'color': Colors.green,
        'count': '8 places',
      },
      {
        'title': 'City',
        'icon': Icons.location_city,
        'color': Colors.orange,
        'count': '15 places',
      },
      {
        'title': 'Cultural',
        'icon': Icons.account_balance,
        'color': Colors.purple,
        'count': '10 places',
      },
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.8,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: categories.map((category) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              // Navigate to category-based search
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(12), // Reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36, // Reduced size
                        height: 36,
                        decoration: BoxDecoration(
                          color: category['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8), // Reduced radius
                        ),
                        child: Icon(
                          category['icon'],
                          color: category['color'],
                          size: 20, // Reduced icon size
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.chevron_right, color: Colors.grey, size: 18),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    category['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15, // Slightly reduced
                      color: Color(0xFF2F62A7),
                    ),
                  ),
                  Text(
                    category['count'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy),
              label: 'AI',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFF2F62A7),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          elevation: 10,
        ),
      ),
    );
  }

  void _showPlaceDetails(Map<String, dynamic> place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85, // Reduced slightly
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Image
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  image: DecorationImage(
                    image: NetworkImage(place['image']),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
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
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place['name'],
                            style: TextStyle(
                              fontSize: 24, // Reduced
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2F62A7),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getCrowdColor(place['crowdLevel']),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            place['crowdLevel'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    Text(
                      place['description'],
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 20),

                    // Details Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        _buildDetailItem(Icons.calendar_today, 'Best Time', place['bestTime']),
                        _buildDetailItem(Icons.attach_money, 'Price Range', place['priceRange']),
                        _buildDetailItem(Icons.people, 'Crowd Level', place['crowdLevel']),
                        _buildDetailItem(Icons.star, 'AI Rating', '4.8/5'),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Moods
                    Text(
                      'Perfect For:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F62A7),
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: (place['moods'] as List<String>)
                          .map((mood) => Chip(
                        label: Text(mood),
                        backgroundColor: Color(0xFF4AB4DE).withOpacity(0.1),
                        avatar: Icon(
                          _getMoodIcon(mood),
                          color: Color(0xFF4AB4DE),
                        ),
                      ))
                          .toList(),
                    ),
                    SizedBox(height: 20),

                    // Why Visit Now
                    Text(
                      'Why Visit Now:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F62A7),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color(0xFFEEDBCC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• Perfect weather conditions',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            '• Lower prices than peak season',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            '• Cultural festivals happening',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            '• Less crowded than usual',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TripCreationScreen(),
                                ),
                              );
                            },
                            icon: Icon(Icons.airplanemode_active),
                            label: Text('Plan Trip Here'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2F62A7),
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.share, color: Color(0xFF4AB4DE)),
                          onPressed: () {
                            // Share place
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Color(0xFF4AB4DE).withOpacity(0.1),
                            padding: EdgeInsets.all(15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF4AB4DE), size: 20),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F62A7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getMoodIcon(String mood) {
    switch (mood.toLowerCase()) {
      case 'romantic':
        return Icons.favorite;
      case 'adventure':
        return Icons.terrain;
      case 'nature':
        return Icons.park;
      case 'cultural':
        return Icons.account_balance;
      case 'relaxation':
        return Icons.spa;
      case 'shopping':
        return Icons.shopping_bag;
      case 'food exploration':
        return Icons.restaurant;
      case 'photography':
        return Icons.camera_alt;
      default:
        return Icons.emoji_emotions;
    }
  }
}