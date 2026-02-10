import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yathran/services/auth_service.dart';
import 'package:yathran/screens/home_screen.dart'; // Ensure this import exists
import 'dart:ui';
import 'dart:math' as math;

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // 0 = Login, 1 = Signup
  int _selectedTabIndex = 0;

  // Animations
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // --- SMOOTH NAVIGATION TO HOME ---
  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Combined Fade and subtle Zoom effect
          var fadeAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOut);
          var scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)
          );

          return FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = Provider.of<AuthService>(context, listen: false);

    if (_selectedTabIndex == 0) {
      // Login Logic
      await authService.login(_emailController.text, _passwordController.text);
    } else {
      // Signup Logic
      if (_passwordController.text != _confirmPasswordController.text) {
        _showErrorSnackBar('Passwords do not match');
        return;
      }
      await authService.signup(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
      );
    }

    if (authService.isLoggedIn) {
      _navigateToHome(); // Use the new smooth transition
    } else if (authService.errorMessage != null) {
      _showErrorSnackBar(authService.errorMessage!);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [Icon(Icons.error_outline, color: Colors.white), SizedBox(width: 10), Expanded(child: Text(message))]),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
      ),
    );
  }

  // ... Validators ...
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Invalid email';
    return null;
  }
  String? _validatePassword(String? value) => (value != null && value.length < 6) ? 'Min 6 chars' : null;
  String? _validateName(String? value) => (value != null && value.isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE3F2FD), Color(0xFFEEDBCC)],
              ),
            ),
          ),

          // 2. Decorative Circles
          Positioned(top: -60, right: -60, child: _buildCircle(200, Color(0xFF2F62A7).withOpacity(0.1))),
          Positioned(bottom: 50, left: -40, child: _buildCircle(150, Color(0xFF4AB4DE).withOpacity(0.15))),

          // 3. Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // --- HEADER SECTION ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Rotated Plane Icon
                          Transform.rotate(
                            angle: -math.pi / 4,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFF2F62A7),
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Color(0xFF2F62A7).withOpacity(0.4), blurRadius: 10, offset: Offset(2, 4))],
                              ),
                              child: Icon(Icons.airplanemode_active, color: Colors.white, size: 28),
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            'YĀTHRAN',
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF1A3E6D), letterSpacing: 2),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'GO. DISCOVER. LIVE.',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 3),
                      ),
                      SizedBox(height: 40),

                      // --- GLASS CARD ---
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white.withOpacity(0.8)),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, 10))],
                            ),
                            child: Column(
                              children: [
                                // --- CUSTOM SLIDING TOGGLE ---
                                _buildAnimatedToggle(),
                                SizedBox(height: 30),

                                // --- FORM FIELDS WITH SMOOTH TRANSITION ---
                                AnimatedSwitcher(
                                  duration: Duration(milliseconds: 300),
                                  // This curve matches the toggle button's curve
                                  switchInCurve: Curves.easeInOut,
                                  switchOutCurve: Curves.easeInOut,
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    // Determine direction based on child Key
                                    final offsetAnimation = Tween<Offset>(
                                      begin: Offset(child.key == ValueKey('login') ? -0.05 : 0.05, 0.0),
                                      end: Offset.zero,
                                    ).animate(animation);

                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: _selectedTabIndex == 0
                                      ? _buildLoginForm(authService)
                                      : _buildSignupForm(authService),
                                ),

                                SizedBox(height: 25),

                                // --- DIVIDER ---
                                Row(
                                  children: [
                                    Expanded(child: Divider(color: Colors.grey[400])),
                                    Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("OR", style: TextStyle(color: Colors.grey[500], fontSize: 12))),
                                    Expanded(child: Divider(color: Colors.grey[400])),
                                  ],
                                ),
                                SizedBox(height: 25),

                                // --- SOCIAL LOGIN BUTTONS ---
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildSocialButton('assets/google.png', 'Google'),
                                    _buildSocialButton('assets/apple.png', 'Apple'),
                                    _buildSocialButton('assets/facebook.png', 'Facebook'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30),
                      TextButton(
                        onPressed: _navigateToHome, // Uses the smooth transition
                        child: Text("Continue as Guest", style: TextStyle(color: Color(0xFF2F62A7), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildCircle(double size, Color color) => Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color));

  // Custom Sliding Segmented Control
  Widget _buildAnimatedToggle() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          // The Sliding Pill
          AnimatedAlign(
            alignment: _selectedTabIndex == 0 ? Alignment.centerLeft : Alignment.centerRight,
            duration: Duration(milliseconds: 300), // Matches form transition duration
            curve: Curves.easeInOut,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4, // Approx half width
              margin: EdgeInsets.symmetric(horizontal: 5),
              height: 45,
              decoration: BoxDecoration(
                color: Color(0xFF2F62A7),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Color(0xFF2F62A7).withOpacity(0.3), blurRadius: 8, offset: Offset(0, 3))],
              ),
            ),
          ),
          // Text Labels
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTabIndex = 0),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 200),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _selectedTabIndex == 0 ? Colors.white : Colors.grey[600],
                        fontSize: 16,
                        fontFamily: 'Roboto', // Ensures consistent font rendering
                      ),
                      child: Text("Login"),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTabIndex = 1),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 200),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _selectedTabIndex == 1 ? Colors.white : Colors.grey[600],
                        fontSize: 16,
                        fontFamily: 'Roboto',
                      ),
                      child: Text("Sign Up"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(AuthService authService) {
    return Form(
      key: _formKey,
      child: Column(
        key: ValueKey('login'), // Key is crucial for AnimatedSwitcher
        children: [
          _buildTextField(_emailController, 'Email', Icons.email_outlined, _validateEmail),
          SizedBox(height: 15),
          _buildTextField(_passwordController, 'Password', Icons.lock_outline, _validatePassword, isPass: true),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: (){}, child: Text('Forgot Password?', style: TextStyle(color: Color(0xFF2F62A7), fontWeight: FontWeight.w600, fontSize: 12))),
          ),
          SizedBox(height: 10),
          _buildSubmitButton("LOGIN", authService),
        ],
      ),
    );
  }

  Widget _buildSignupForm(AuthService authService) {
    return Form(
      key: _formKey,
      child: Column(
        key: ValueKey('signup'), // Key is crucial for AnimatedSwitcher
        children: [
          _buildTextField(_nameController, 'Full Name', Icons.person_outline, _validateName),
          SizedBox(height: 15),
          _buildTextField(_emailController, 'Email', Icons.email_outlined, _validateEmail),
          SizedBox(height: 15),
          _buildTextField(_passwordController, 'Password', Icons.lock_outline, _validatePassword, isPass: true),
          SizedBox(height: 15),
          _buildTextField(_confirmPasswordController, 'Confirm Password', Icons.lock_outline, (val) => val != _passwordController.text ? 'Mismatch' : null, isPass: true),
          SizedBox(height: 25),
          _buildSubmitButton("CREATE ACCOUNT", authService),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, String? Function(String?)? validator, {bool isPass = false}) {
    return TextFormField(
      controller: ctrl,
      validator: validator,
      obscureText: isPass ? _obscurePassword : false,
      style: TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        prefixIcon: Icon(icon, color: Color(0xFF2F62A7), size: 20),
        suffixIcon: isPass ? IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.grey, size: 20),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ) : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.transparent)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Color(0xFF2F62A7), width: 1.5)),
      ),
    );
  }

  Widget _buildSubmitButton(String text, AuthService authService) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: authService.isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2F62A7),
          elevation: 5,
          shadowColor: Color(0xFF2F62A7).withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: authService.isLoading
            ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
      ),
    );
  }

  Widget _buildSocialButton(String assetPath, String label) {
    String iconUrl = '';
    if (label == 'Google') iconUrl = 'https://cdn-icons-png.flaticon.com/512/300/300221.png';
    if (label == 'Apple') iconUrl = 'https://cdn-icons-png.flaticon.com/512/0/747.png';
    if (label == 'Facebook') iconUrl = 'https://cdn-icons-png.flaticon.com/512/5968/5968764.png';

    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Image.network(iconUrl, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}