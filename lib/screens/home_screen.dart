import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui'; // Required for ImageFilter (Glassmorphism)
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';

// --- Placeholder Imports (Replace with your actual files) ---
import 'package:yathran/screens/trip_creation_screen.dart';
import 'package:yathran/screens/profile_screen.dart';
import 'package:yathran/screens/trending_destinations_screen.dart';
import 'package:yathran/screens/crowd_insights_screen.dart';
import 'package:yathran/screens/map_screen.dart';
import 'package:yathran/screens/settings_screen.dart';
import 'package:yathran/screens/favorites_screen.dart';
import 'package:yathran/screens/ai_companion_screen.dart';
import 'package:yathran/services/auth_service.dart';
import 'package:yathran/services/notification_service.dart';
// ---------------------------------------------------------

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Navigation State
  int _selectedIndex = 0;

  // Animation Controllers
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final PageController _carouselController = PageController(viewportFraction: 0.85);
  int _currentCarouselIndex = 0;

  // --- MOCK DATA ---
  final List<Map<String, dynamic>> topPlaces = [
    {
      'id': '1',
      'name': 'Santorini, Greece',
      'image': 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=800&h=400&fit=crop',
      'description': 'White-washed buildings with stunning sunset views',
      'crowdLevel': 'Medium',
      'bestTime': 'May - Oct',
      'moods': ['Romantic', 'Photography', 'Relaxation'],
      'priceRange': '\$2,200',
    },
    {
      'id': '2',
      'name': 'Kyoto, Japan',
      'image': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800&h=400&fit=crop',
      'description': 'Ancient temples and traditional culture',
      'crowdLevel': 'High',
      'bestTime': 'Spring/Fall',
      'moods': ['Cultural', 'Spiritual', 'Food'],
      'priceRange': '\$2,400',
    },
    {
      'id': '3',
      'name': 'Swiss Alps',
      'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=400&fit=crop',
      'description': 'Majestic mountains and adventure sports',
      'crowdLevel': 'Low',
      'bestTime': 'Jun - Sep',
      'moods': ['Adventure', 'Nature', 'Family'],
      'priceRange': '\$3,500',
    },
    {
      'id': '4',
      'name': 'Bali, Indonesia',
      'image': 'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?w=800&h=400&fit=crop',
      'description': 'Tropical paradise with spiritual retreats',
      'crowdLevel': 'Medium',
      'bestTime': 'Apr - Oct',
      'moods': ['Adventure', 'Relax', 'Spiritual'],
      'priceRange': '\$1,000',
    },
  ];

  List<Map<String, dynamic>> aiSuggestions = [
    {
      'destination': 'Bali, Indonesia',
      'reason': 'Perfect for your Adventure & Nature interests',
      'moods': ['Adventure', 'Nature'],
      'crowdLevel': 'Medium',
      'bestTime': 'Apr - Oct',
    },
    {
      'destination': 'Kyoto, Japan',
      'reason': 'High match for Cultural experiences',
      'moods': ['Cultural', 'Food'],
      'crowdLevel': 'High',
      'bestTime': 'Mar - May',
    },
  ];

  final List<Map<String, dynamic>> travelStories = [
    {
      'title': 'Hidden Gems of Bali',
      'author': 'Sarah Miller',
      'readTime': '5 min',
      'likes': 245,
      'image': 'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?w=400&h=300&fit=crop',
      'category': 'Adventure',
      'excerpt': 'Discover secret waterfalls and local warungs...',
    },
    {
      'title': 'Tokyo on a Budget',
      'author': 'David Chen',
      'readTime': '7 min',
      'likes': 189,
      'image': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop',
      'category': 'Budget',
      'excerpt': 'Experience authentic Japan without breaking the bank...',
    },
  ];

  @override
  void initState() {
    super.initState();
    // System UI cleanup
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    // Animation setup
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutQuart),
    );
    _fadeController.forward();

    // Start auto-scroll
    _startCarouselAutoRotation();
  }

  void _startCarouselAutoRotation() {
    Future.delayed(Duration(seconds: 6), () {
      if (_carouselController.hasClients && mounted) {
        int nextPage = _currentCarouselIndex + 1;
        if (nextPage >= topPlaces.length) nextPage = 0;
        _carouselController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 900),
          curve: Curves.fastLinearToSlowEaseIn,
        );
        _startCarouselAutoRotation();
      }
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  Color _getCrowdColor(String crowdLevel) {
    switch (crowdLevel.toLowerCase()) {
      case 'low': return Color(0xFF66BB6A); // Green
      case 'medium': return Color(0xFFFFA726); // Orange
      case 'high': return Color(0xFFEF5350); // Red
      default: return Colors.grey;
    }
  }

  // --- Page Switcher Logic ---
  Widget _getPage(int index) {
    switch (index) {
      case 0: return _buildHomeContent();
      case 1: return MapScreen(showCrowdHeatmap: true);
      case 2: return FavoritesScreen();
      case 3: return AICompanionScreen();
      case 4: return SettingsScreen();
      default: return _buildHomeContent();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // extendBody allows content to flow behind the floating navbar
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA), // Very light grey-white for modern feel
      extendBody: true,
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (Widget child, Animation<double> animation) {
          // Subtle zoom-fade transition
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedIndex),
          child: _getPage(_selectedIndex),
        ),
      ),
      bottomNavigationBar: _buildDynamicFloatingNavBar(),
    );
  }

  // ---------------------------------------------------------------------------
  // UI COMPONENTS
  // ---------------------------------------------------------------------------

  // 1. Floating Navigation Bar
  Widget _buildDynamicFloatingNavBar() {
    return Container(
      padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 25,
                  spreadRadius: 0,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
                _buildNavItem(1, Icons.explore_rounded, Icons.explore_outlined, 'Explore'),
                _buildNavItem(2, Icons.favorite_rounded, Icons.favorite_border_rounded, 'Saved'),
                _buildNavItem(3, Icons.smart_toy_rounded, Icons.smart_toy_outlined, 'AI'),
                _buildNavItem(4, Icons.settings_rounded, Icons.settings_outlined, 'Config'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData selectedIcon, IconData unselectedIcon, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF2F62A7).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : unselectedIcon,
              color: isSelected ? Color(0xFF2F62A7) : Colors.grey[500],
              size: 24,
            ),
            if (isSelected) ...[
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Color(0xFF2F62A7),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 2. Main Home Content
  Widget _buildHomeContent() {
    final authService = Provider.of<AuthService>(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          // Advanced Sliver App Bar
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Color(0xFF2F62A7),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient Background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF154486),
                          Color(0xFF2F62A7),
                          Color(0xFF5AB6DF),
                        ],
                      ),
                    ),
                  ),
                  // Decorative Circles
                  Positioned(
                    top: -50, right: -50,
                    child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withOpacity(0.05)),
                  ),
                  Positioned(
                    bottom: -30, left: -30,
                    child: CircleAvatar(radius: 80, backgroundColor: Colors.white.withOpacity(0.05)),
                  ),
                  // Text Content
                  Positioned(
                    bottom: 30, left: 24, right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'YĀTHRAN',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 3.0,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withOpacity(0.5)),
                              ),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: Icon(Icons.person, color: Colors.white, size: 20),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Hello, ${authService.currentUser?.name ?? 'Traveler'}',
                          style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.9)),
                        ),
                        Text(
                          'Where do you want to go?',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () => NotificationService().sendNotification(
                  context: context,
                  title: 'System',
                  message: 'No new alerts.',
                  type: 'info',
                ),
              ),
            ],
          ),

          // Content Body
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 120), // Padding for Floating Navbar
              child: Column(
                children: [
                  SizedBox(height: 24),
                  _buildTopPlacesCarousel(),
                  SizedBox(height: 32),

                  // Quick Actions Grid (Robust Layout)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildSectionHeader('Quick Actions', 'Smart tools'),
                        SizedBox(height: 16),
                        _buildResponsiveQuickActionsGrid(),
                      ],
                    ),
                  ),

                  SizedBox(height: 32),

                  // AI Suggestions
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildSectionHeader('AI Suggestions', 'Curated for you'),
                        SizedBox(height: 16),
                        ...aiSuggestions.map((s) => _buildSuggestionCard(s)).toList(),
                      ],
                    ),
                  ),

                  SizedBox(height: 32),

                  // Travel Stories
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildSectionHeader('Travel Stories', 'Inspiration'),
                        SizedBox(height: 16),
                        _buildTravelStories(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // WIDGET BUILDERS
  // ---------------------------------------------------------------------------

  Widget _buildSectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A3E6D))),
            Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500)),
          ],
        ),
        Icon(Icons.more_horiz, color: Colors.grey[400]),
      ],
    );
  }

  // --- 3. Robust Grid with LayoutBuilder ---
  Widget _buildResponsiveQuickActionsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate item width based on available width
        final double itemWidth = (constraints.maxWidth - 16) / 2;
        // Define a fixed height you want for your buttons
        final double itemHeight = 90.0;
        // Calculate exact ratio
        final double ratio = itemWidth / itemHeight;

        return GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: ratio, // Dynamic ratio prevents overflow
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildQuickActionBtn(
                'New Trip', Icons.add_location_alt_outlined,
                [Color(0xFF2F62A7), Color(0xFF4C8DCE)],
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => TripCreationScreen()))
            ),
            _buildQuickActionBtn(
                'Live Map', Icons.map_outlined,
                [Color(0xFF4AB4DE), Color(0xFF6AC9EF)],
                    () => _onItemTapped(1)
            ),
            _buildQuickActionBtn(
                'Trending', Icons.trending_up,
                [Color(0xFFFFA726), Color(0xFFFFCC80)],
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => TrendingDestinationsScreen()))
            ),
            _buildQuickActionBtn(
                'Insights', Icons.insights,
                [Color(0xFF7E57C2), Color(0xFF9575CD)],
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => CrowdInsightsScreen()))
            ),
          ],
        );
      },
    );
  }

  // --- FIX APPLIED HERE: ADJUSTED PADDING/SPACING FOR TRENDING TEXT ---
  Widget _buildQuickActionBtn(String title, IconData icon, List<Color> colors, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: colors[0].withOpacity(0.3), blurRadius: 10, offset: Offset(0, 5)),
        ],
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            // UPDATED: Reduced Horizontal Padding to 12
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Container(
                  // UPDATED: Reduced Icon Container Padding to 6
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                // UPDATED: Reduced Spacing width to 8
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.fade, // Handle text gently if it still touches edges
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- 4. Carousel ---
  Widget _buildTopPlacesCarousel() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top Picks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              SmoothPageIndicator(
                controller: _carouselController,
                count: topPlaces.length,
                effect: ExpandingDotsEffect(
                    dotHeight: 6, dotWidth: 6,
                    activeDotColor: Color(0xFF2F62A7),
                    dotColor: Colors.grey[300]!
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _carouselController,
            itemCount: topPlaces.length,
            onPageChanged: (index) => setState(() => _currentCarouselIndex = index),
            itemBuilder: (context, index) {
              return _buildCarouselItem(topPlaces[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(Map<String, dynamic> place, int index) {
    bool isActive = index == _currentCarouselIndex;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: isActive ? 0 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2F62A7).withOpacity(isActive ? 0.25 : 0.05),
            blurRadius: isActive ? 20 : 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(place['image'], fit: BoxFit.cover),
            // Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(place['name'], style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () => _showPlaceDetails(place),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                          child: Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.people_outline, size: 14, color: Colors.white70),
                      SizedBox(width: 4),
                      Text(place['crowdLevel'], style: TextStyle(color: Colors.white70, fontSize: 12)),
                      SizedBox(width: 12),
                      Icon(Icons.attach_money, size: 14, color: Colors.white70),
                      Text(place['priceRange'], style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 5. Suggestions Card ---
  Widget _buildSuggestionCard(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TripCreationScreen())),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(14)),
                  child: Icon(Icons.auto_awesome, color: Color(0xFF2F62A7)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['destination'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A3E6D))),
                      SizedBox(height: 4),
                      Text(item['reason'], style: TextStyle(color: Colors.grey[600], fontSize: 13), maxLines: 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- 6. Stories ---
  Widget _buildTravelStories() {
    return Column(
      children: travelStories.map((story) {
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: Offset(0, 4))],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                child: Image.network(story['image'], width: 100, height: 110, fit: BoxFit.cover),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Color(0xFFE1F5FE), borderRadius: BorderRadius.circular(6)),
                        child: Text(story['category'], style: TextStyle(fontSize: 10, color: Color(0xFF29B6F6), fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 6),
                      Text(story['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 4),
                      Text(story['excerpt'], style: TextStyle(fontSize: 11, color: Colors.grey[600]), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // --- 7. Modal Bottom Sheet (Details) ---
  void _showPlaceDetails(Map<String, dynamic> place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: ListView(
              controller: controller,
              padding: EdgeInsets.all(0),
              children: [
                Stack(
                  children: [
                    Image.network(place['image'], height: 300, width: double.infinity, fit: BoxFit.cover),
                    Positioned(
                      top: 16, right: 16,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: CircleAvatar(backgroundColor: Colors.black38, child: Icon(Icons.close, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(place['name'], style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A3E6D))),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: _getCrowdColor(place['crowdLevel']), borderRadius: BorderRadius.circular(12)),
                            child: Text(place['crowdLevel'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(place['description'], style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5)),
                      SizedBox(height: 24),

                      // --- ROBUST DETAILS GRID ---
                      LayoutBuilder(
                          builder: (context, constraints) {
                            // Force a comfortable height for detail items (e.g., 60px)
                            final itemWidth = (constraints.maxWidth - 12) / 2;
                            final ratio = itemWidth / 60.0;

                            return GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: ratio,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              children: [
                                _buildDetailItem(Icons.calendar_month, 'Best Time', place['bestTime']),
                                _buildDetailItem(Icons.paid, 'Price', place['priceRange']),
                                _buildDetailItem(Icons.groups, 'Crowd', place['crowdLevel']),
                                _buildDetailItem(Icons.star, 'Rating', '4.9/5.0'),
                              ],
                            );
                          }
                      ),

                      SizedBox(height: 24),
                      Text('Perfect For', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A3E6D))),
                      SizedBox(height: 12),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: (place['moods'] as List<String>).map((m) => Chip(
                          label: Text(m),
                          backgroundColor: Color(0xFFE3F2FD),
                          labelStyle: TextStyle(color: Color(0xFF2F62A7)),
                          avatar: Icon(Icons.check, size: 16, color: Color(0xFF2F62A7)),
                        )).toList(),
                      ),
                      SizedBox(height: 40),

                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TripCreationScreen())),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2F62A7),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 5,
                            shadowColor: Color(0xFF2F62A7).withOpacity(0.4),
                          ),
                          child: Text('Plan Trip Here', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF4AB4DE), size: 20),
          SizedBox(width: 10),
          Expanded( // Prevents overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500]), maxLines: 1),
                Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF2F62A7), fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}