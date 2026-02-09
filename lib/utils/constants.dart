class AppConstants {
  // Colors
  static const primaryColor = 0xFF2F62A7; // Deep Ocean Blue
  static const secondaryColor = 0xFF3B8AC3; // Ocean Blue
  static const highlightColor = 0xFF4AB4DE; // Light Aqua Blue
  static const backgroundColor = 0xFFEEDBCC; // Sand/Cream

  // API Keys (Replace with your actual keys)
  static const googlePlacesApiKey = 'YOUR_GOOGLE_PLACES_API_KEY';
  static const openWeatherApiKey = 'YOUR_OPENWEATHER_API_KEY';

  // API Endpoints
  static const placesApiBaseUrl = 'https://maps.googleapis.com/maps/api/place';
  static const weatherApiBaseUrl = 'https://api.openweathermap.org/data/2.5';

  // Mood Options
  static const List<Map<String, String>> moods = [
    {'name': 'Romantic', 'emoji': '❤️'},
    {'name': 'Playful', 'emoji': '🎢'},
    {'name': 'Devotional', 'emoji': '🛕'},
    {'name': 'Nature', 'emoji': '🌿'},
    {'name': 'Adventure', 'emoji': '🏔️'},
    {'name': 'Food Exploration', 'emoji': '🍜'},
    {'name': 'Family Bonding', 'emoji': '👨‍👩‍👧'},
    {'name': 'Photography', 'emoji': '📸'},
    {'name': 'Shopping', 'emoji': '🛍️'},
  ];

  // Interests
  static const List<String> interests = [
    'Historical Sites',
    'Beaches',
    'Mountains',
    'Shopping',
    'Food',
    'Museums',
    'Nightlife',
    'Adventure Sports',
    'Nature Walks',
    'Photography Spots',
    'Art Galleries',
    'Local Markets',
    'Wineries',
    'Theme Parks',
    'Wildlife',
    'Architecture',
    'Festivals',
    'Cultural Shows',
  ];

  // Trip Types
  static const List<String> tripTypes = [
    'Solo',
    'Family',
    'Friends',
    'Couple',
    'Business',
    'Backpacking',
  ];
}