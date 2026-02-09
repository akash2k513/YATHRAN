import 'package:flutter/material.dart';
import 'package:yathran/screens/trip_creation_screen.dart';
import 'package:yathran/screens/profile_screen.dart';
import 'package:yathran/screens/trending_destinations_screen.dart';
import 'package:yathran/screens/crowd_insights_screen.dart';
import 'package:yathran/screens/map_screen.dart';
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
  List<Trip> savedTrips = [];
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
      'priceRange': '14700 Dollars',
    },
    {
      'id': '2',
      'name': 'Kyoto, Japan',
      'image': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800&h=400&fit=crop',
      'description': 'Ancient temples and traditional culture',
      'crowdLevel': 'High',
      'bestTime': 'Spring & Autumn',
      'moods': ['Cultural', 'Spiritual', 'Food Exploration'],
      'priceRange': '10000 Dollars',
    },
    {
      'id': '3',
      'name': 'Swiss Alps',
      'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=400&fit=crop',
      'description': 'Majestic mountains and adventure sports',
      'crowdLevel': 'Low',
      'bestTime': 'June - September',
      'moods': ['Adventure', 'Nature', 'Family'],
      'priceRange': '13500 Dollars',
    },
    {
      'id': '4',
      'name': 'Bali, Indonesia',
      'image': 'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?w=800&h=400&fit=crop',
      'description': 'Tropical paradise with spiritual retreats',
      'crowdLevel': 'Medium',
      'bestTime': 'April - October',
      'moods': ['Adventure', 'Relaxation', 'Spiritual'],
      'priceRange': '1000 Dollars',
    },
    {
      'id': '5',
      'name': 'Dubai, UAE',
      'image': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800&h=400&fit=crop',
      'description': 'Modern architecture and luxury experiences',
      'crowdLevel': 'High',
      'bestTime': 'November - March',
      'moods': ['Shopping', 'Luxury', 'Adventure'],
      'priceRange': '7000 Dollars',
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

    // Load initial data
    _loadInitialData();
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

  void _loadInitialData() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      savedTrips = [
        Trip(
          destination: 'Paris, France',
          startDate: DateTime.now().add(Duration(days: 30)),
          endDate: DateTime.now().add(Duration(days: 37)),
          budget: 2000,
          tripType: 'Couple',
          selectedMoods: ['Romantic', 'Food Exploration', 'Photography'],
        ),
        Trip(
          destination: 'Tokyo, Japan',
          startDate: DateTime.now().add(Duration(days: 60)),
          endDate: DateTime.now().add(Duration(days: 67)),
          budget: 2500,
          tripType: 'Solo',
          selectedMoods: ['Adventure', 'Food Exploration', 'Shopping'],
        ),
      ];
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
      // Search - show search screen
        break;
      case 2:
      // Saved trips
        break;
      case 3:
        _showProfile();
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

                    // Start New Trip Card
                    _buildFeatureCard(
                      title: 'Start New Trip',
                      subtitle: 'AI-powered travel planning',
                      icon: Icons.add_circle_outline,
                      color: Color(0xFF2F62A7),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => TripCreationScreen(),
                            transitionDuration: Duration(milliseconds: 400),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),

                    // Quick Features Grid
                    Text(
                      'Quick Features',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F62A7),
                      ),
                    ),
                    SizedBox(height: 10),
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        _buildQuickFeature(
                          title: 'Saved Trips',
                          icon: Icons.bookmark,
                          count: savedTrips.length,
                          color: Color(0xFF3B8AC3),
                        ),
                        _buildQuickFeature(
                          title: 'Live Map',
                          icon: Icons.map,
                          color: Color(0xFF4AB4DE),
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
                        _buildQuickFeature(
                          title: 'Trending',
                          icon: Icons.trending_up,
                          color: Color(0xFF4AB4DE),
                          onTap: _viewTrendingDestinations,
                        ),
                        _buildQuickFeature(
                          title: 'Crowd Insights',
                          icon: Icons.people,
                          color: Color(0xFF2F62A7),
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
                    SizedBox(height: 30),

                    // Saved Trips
                    _buildSectionHeader(
                      title: 'Saved Trips',
                      subtitle: 'Your planned adventures',
                    ),
                    SizedBox(height: 10),
                    savedTrips.isEmpty
                        ? _buildEmptyState(
                      icon: Icons.travel_explore,
                      title: 'No trips saved yet',
                      subtitle: 'Start planning your first adventure!',
                    )
                        : Column(
                      children: savedTrips.map((trip) => _buildTripCard(trip)).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => TripCreationScreen(),
              transitionDuration: Duration(milliseconds: 400),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
            ),
          );
        },
        backgroundColor: Color(0xFF2F62A7),
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text('New Trip'),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
        Container(
          height: 250,
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

            // Content
            Padding(
              padding: EdgeInsets.all(20),
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
                  SizedBox(height: 10),

                  // Place Name
                  Text(
                    place['name'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),

                  // Description
                  Text(
                    place['description'],
                    style: TextStyle(
                      fontSize: 14,
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
                  SizedBox(height: 10),

                  // Details Row
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.white70),
                      SizedBox(width: 5),
                      Text(
                        place['bestTime'],
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      SizedBox(width: 20),
                      Icon(Icons.attach_money, size: 14, color: Colors.white70),
                      SizedBox(width: 5),
                      Text(
                        place['priceRange'],
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Mood Tags
                  Wrap(
                    spacing: 8,
                    children: (place['moods'] as List<String>)
                        .take(3)
                        .map((mood) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Text(
                        mood,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                  SizedBox(height: 15),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Plan trip to this place
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripCreationScreen(),
                              ),
                            );
                          },
                          icon: Icon(Icons.airplanemode_active, size: 16),
                          label: Text('Plan Trip'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2F62A7),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.info_outline, color: Colors.white),
                          onPressed: () {
                            _showPlaceDetails(place);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Favorite Button
            Positioned(
              top: 15,
              right: 15,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: () {
                    // Add to favorites
                    NotificationService().sendNotification(
                      context: context,
                      title: 'Added to Favorites',
                      message: '${place['name']} added to your favorites',
                      type: 'success',
                    );
                  },
                ),
              ),
            ),
          ],
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
        height: MediaQuery.of(context).size.height * 0.8,
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
                              fontSize: 28,
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
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
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
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(
                            '• Lower prices than peak season',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(
                            '• Cultural festivals happening',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(
                            '• Less crowded than usual',
                            style: TextStyle(color: Colors.grey[700]),
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

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.8)],
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFeature({
    required String title,
    required IconData icon,
    Color color = Colors.blue,
    int count = 0,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              if (count > 0)
                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
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
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        leading: Container(
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
        title: Text(
          suggestion['destination'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2F62A7),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(suggestion['reason']),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.people, size: 14, color: Colors.grey),
                SizedBox(width: 5),
                Text('Crowd: ${suggestion['crowdLevel']}'),
                SizedBox(width: 15),
                Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                SizedBox(width: 5),
                Text(suggestion['bestTime']),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Color(0xFF4AB4DE)),
        onTap: () {
          // Show suggestion details
        },
      ),
    );
  }

  Widget _buildTripCard(Trip trip) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xFF4AB4DE).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.location_on, color: Color(0xFF4AB4DE)),
        ),
        title: Text(
          trip.destination,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2F62A7),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              '${trip.startDate.day}/${trip.startDate.month} - ${trip.endDate.day}/${trip.endDate.month}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 5),
            Wrap(
              spacing: 5,
              children: trip.selectedMoods
                  .take(2)
                  .map((mood) => Chip(
                label: Text(mood),
                backgroundColor: Color(0xFF4AB4DE).withOpacity(0.1),
                labelStyle: TextStyle(fontSize: 10),
              ))
                  .toList(),
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Color(0xFF4AB4DE)),
        onTap: () {
          // View trip details
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Icon(icon, size: 50, color: Colors.grey[400]),
            SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Explore',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Saved',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.white,
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
}