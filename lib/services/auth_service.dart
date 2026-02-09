import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Mock API URL - In real app, use your backend URL
  static const String _baseUrl = 'https://api.yathran.com';
  static const String _loginEndpoint = '/auth/login';
  static const String _signupEndpoint = '/auth/signup';

  Future<void> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // In real app, make actual API call
      // final response = await http.post(
      //   Uri.parse('$_baseUrl$_loginEndpoint'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({
      //     'email': email,
      //     'password': password,
      //   }),
      // );

      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   _handleLoginSuccess(data);
      // } else {
      //   _handleError('Invalid credentials');
      // }

      // Mock implementation for demo
      await Future.delayed(Duration(seconds: 2));

      if (email.isNotEmpty && password.isNotEmpty) {
        _handleLoginSuccess({
          'user': {
            'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
            'name': email.split('@')[0],
            'email': email,
            'profileImageUrl': null,
          },
          'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        });
      } else {
        _handleError('Please enter email and password');
      }
    } catch (e) {
      _handleError('Network error: ${e.toString()}');
    }
  }

  Future<void> signup(String email, String password, String name) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // In real app, make actual API call
      // final response = await http.post(
      //   Uri.parse('$_baseUrl$_signupEndpoint'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({
      //     'name': name,
      //     'email': email,
      //     'password': password,
      //   }),
      // );

      // if (response.statusCode == 201) {
      //   final data = json.decode(response.body);
      //   _handleSignupSuccess(data);
      // } else {
      //   _handleError('Registration failed');
      // }

      // Mock implementation for demo
      await Future.delayed(Duration(seconds: 2));

      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        _handleSignupSuccess({
          'user': {
            'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
            'name': name,
            'email': email,
            'profileImageUrl': null,
          },
          'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        });
      } else {
        _handleError('Please fill all fields');
      }
    } catch (e) {
      _handleError('Network error: ${e.toString()}');
    }
  }

  void _handleLoginSuccess(Map<String, dynamic> data) {
    _currentUser = User.fromJson(data['user']);
    _isLoggedIn = true;
    _saveToken(data['token']);
    _saveUserData(data['user']);
    _setLoading(false);
    notifyListeners();
  }

  void _handleSignupSuccess(Map<String, dynamic> data) {
    _currentUser = User.fromJson(data['user']);
    _isLoggedIn = true;
    _saveToken(data['token']);
    _saveUserData(data['user']);
    _setLoading(false);
    notifyListeners();
  }

  void _handleError(String message) {
    _errorMessage = message;
    _setLoading(false);
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _saveToken(String token) {
    // In real app, save token to secure storage
    print('Token saved: $token');
  }

  void _saveUserData(Map<String, dynamic> userData) {
    // In real app, save user data to local storage
    print('User data saved: $userData');
  }

  void guestLogin() {
    _currentUser = User.guest();
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    // In real app, call logout API and clear tokens
    _currentUser = null;
    _isLoggedIn = false;
    _errorMessage = null;
    _clearLocalData();
    notifyListeners();
  }

  void _clearLocalData() {
    // Clear tokens and user data from storage
    print('Clearing local data');
  }

  Future<void> checkAuthStatus() async {
    // Check if user is already logged in (from local storage)
    await Future.delayed(Duration(milliseconds: 500));

    // Mock: Check if there's a saved token
    final hasToken = false; // In real app, check secure storage

    if (hasToken) {
      // In real app, validate token with backend
      // _currentUser = User.fromJson(savedUserData);
      // _isLoggedIn = true;
    }

    notifyListeners();
  }

  void updateUserProfile(User updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }
}