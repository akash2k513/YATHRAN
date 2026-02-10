import 'package:flutter/material.dart';
import 'package:yathran/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _airplaneController;
  late AnimationController _cloudController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _airplaneAnimation;
  late Animation<double> _airplaneOpacityAnimation;
  late Animation<double> _cloudAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Main animation controller (3 seconds)
    _controller = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    // Airplane animation controller
    _airplaneController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );

    // Cloud animation controller
    _cloudController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();

    // Logo scale animation - bouncy entrance
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    // Logo rotation animation - slight rotation effect
    _rotationAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Opacity animation for text
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    // Airplane movement animation - flies across screen
    _airplaneAnimation = Tween<double>(begin: -0.3, end: 1.2).animate(
      CurvedAnimation(
        parent: _airplaneController,
        curve: Curves.easeInOut,
      ),
    );

    // Airplane opacity - fades in and out
    _airplaneOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 60),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_airplaneController);

    // Cloud movement animation
    _cloudAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_cloudController);

    _controller.forward();
    _airplaneController.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Check authentication status
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.checkAuthStatus();

    await Future.delayed(Duration(milliseconds: 3000));

    if (authService.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _airplaneController.dispose();
    _cloudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A5F),
              Color(0xFF2F62A7),
              Color(0xFF4AB4DE),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated clouds in background
            AnimatedBuilder(
              animation: _cloudAnimation,
              builder: (context, child) {
                return Stack(
                  children: [
                    _buildCloud(-100 + _cloudAnimation.value * screenWidth, 80, 0.3),
                    _buildCloud(-50 + _cloudAnimation.value * screenWidth * 0.7, 150, 0.2),
                    _buildCloud(-150 + _cloudAnimation.value * screenWidth * 1.2, 220, 0.25),
                    _buildCloud(-80 + _cloudAnimation.value * screenWidth * 0.9, screenHeight * 0.6, 0.2),
                    _buildCloud(-120 + _cloudAnimation.value * screenWidth * 1.1, screenHeight * 0.7, 0.3),
                  ],
                );
              },
            ),

            // Main content
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo with rotation
                      Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                                BoxShadow(
                                  color: Color(0xFF4AB4DE).withOpacity(0.5),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Globe/World icon background
                                CustomPaint(
                                  size: Size(140, 140),
                                  painter: GlobePainter(),
                                ),
                                // Airplane icon overlay
                                Transform.rotate(
                                  angle: -math.pi / 4,
                                  child: Icon(
                                    Icons.flight,
                                    size: 60,
                                    color: Color(0xFF2F62A7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // App Name with fade-in
                      Opacity(
                        opacity: _opacityAnimation.value,
                        child: Text(
                          'YĀTHRAN',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 4,
                            shadows: [
                              Shadow(
                                blurRadius: 15,
                                color: Colors.black.withOpacity(0.4),
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),

                      // Tagline
                      Opacity(
                        opacity: _opacityAnimation.value,
                        child: Text(
                          'Smart Travel. Balanced Experiences.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            fontStyle: FontStyle.italic,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      SizedBox(height: 60),

                      // Enhanced loading indicator
                      Opacity(
                        opacity: _opacityAnimation.value,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withOpacity(0.3),
                                ),
                                strokeWidth: 2,
                              ),
                            ),
                            Container(
                              width: 55,
                              height: 55,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withOpacity(0.6),
                                ),
                                strokeWidth: 3,
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF4AB4DE),
                                ),
                                strokeWidth: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),

                      // Loading Text
                      Opacity(
                        opacity: _opacityAnimation.value,
                        child: Text(
                          'Initializing AI Travel Planner...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      // Feature Highlights
                      if (_opacityAnimation.value > 0.6)
                        Opacity(
                          opacity: (_opacityAnimation.value - 0.6) * 2.5,
                          child: Padding(
                            padding: EdgeInsets.only(top: 35),
                            child: Column(
                              children: [
                                FeatureHighlight(text: '✓ Mood-Based Planning'),
                                FeatureHighlight(text: '✓ Crowd Prediction'),
                                FeatureHighlight(text: '✓ AI Optimization'),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),

            // Flying airplane animation
            AnimatedBuilder(
              animation: _airplaneController,
              builder: (context, child) {
                return Positioned(
                  left: screenWidth * _airplaneAnimation.value,
                  top: screenHeight * 0.25 + math.sin(_airplaneAnimation.value * math.pi) * 30,
                  child: Opacity(
                    opacity: _airplaneOpacityAnimation.value,
                    child: Transform.rotate(
                      angle: math.pi / 12, // Slight upward angle
                      child: Icon(
                        Icons.airplanemode_active,
                        size: 50,
                        color: Colors.white.withOpacity(0.9),
                        shadows: [
                          Shadow(
                            blurRadius: 20,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloud(double left, double top, double opacity) {
    if (left > MediaQuery.of(context).size.width) {
      left = -100;
    }

    return Positioned(
      left: left,
      top: top,
      child: Opacity(
        opacity: opacity,
        child: Icon(
          Icons.cloud,
          size: 80,
          color: Colors.white.withOpacity(0.2),
        ),
      ),
    );
  }
}

// Custom painter for globe background in logo
class GlobePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF2F62A7).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Draw meridians (vertical lines)
    for (int i = 0; i < 4; i++) {
      final path = Path();
      for (double t = -math.pi / 2; t <= math.pi / 2; t += 0.1) {
        final x = center.dx + radius * math.cos(t) * math.cos(i * math.pi / 4);
        final y = center.dy + radius * math.sin(t);
        if (t == -math.pi / 2) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }

    // Draw parallels (horizontal lines)
    for (int i = -1; i <= 1; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.8),
        i * math.pi / 6,
        math.pi,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class FeatureHighlight extends StatelessWidget {
  final String text;

  FeatureHighlight({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.85),
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}