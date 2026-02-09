import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Google Places API (Mock implementation)
  Future<List<Map<String, dynamic>>> getPlaces(String query) async {
    // Mock data for demonstration
    return [
      {
        'name': 'Eiffel Tower',
        'address': 'Champ de Mars, Paris',
        'rating': 4.7,
        'crowdLevel': 'High',
        'cost': 25.0,
      },
      {
        'name': 'Louvre Museum',
        'address': 'Rue de Rivoli, Paris',
        'rating': 4.8,
        'crowdLevel': 'Low',
        'cost': 15.0,
      },
    ];
  }

  // OpenWeatherMap API (Mock implementation)
  Future<Map<String, dynamic>> getWeather(String city) async {
    return {
      'temperature': 22,
      'condition': 'Sunny',
      'humidity': 65,
      'windSpeed': 12,
    };
  }

  // Crowd Prediction (Mock implementation)
  Future<String> predictCrowd(String place, DateTime time) async {
    // Simple algorithm based on day of week and time
    if (time.weekday >= 6) { // Weekend
      if (time.hour >= 10 && time.hour <= 16) {
        return 'High';
      }
      return 'Medium';
    } else { // Weekday
      if (time.hour >= 11 && time.hour <= 14) {
        return 'Medium';
      }
      return 'Low';
    }
  }

  // Route Optimization (Mock implementation)
  Future<List<String>> optimizeRoute(List<String> places) async {
    // Simple TSP-like ordering
    return places;
  }

  // Eventbrite Events (Mock implementation)
  Future<List<Map<String, dynamic>>> getEvents(String city) async {
    return [
      {
        'name': 'Music Festival',
        'date': '2024-06-15',
        'location': 'Central Park',
      },
    ];
  }
}