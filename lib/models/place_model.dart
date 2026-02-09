import 'dart:math';

class Place {
  String id;
  String name;
  String address;
  String? description;
  double latitude;
  double longitude;
  double rating;
  int totalRatings;
  List<String> categories;
  List<String> moods; // Associated travel moods
  Map<String, double> prices; // activity -> price
  OpeningHours? openingHours;
  List<String> photos;
  double popularityScore; // 0-100
  int averageVisitDuration; // in minutes
  List<String> amenities;
  bool isAccessibilityFriendly;
  String contactNumber;
  String website;
  double distanceFromUser; // in km

  Place({
    required this.id,
    required this.name,
    required this.address,
    this.description,
    required this.latitude,
    required this.longitude,
    this.rating = 0.0,
    this.totalRatings = 0,
    this.categories = const [],
    this.moods = const [],
    this.prices = const {},
    this.openingHours,
    this.photos = const [],
    this.popularityScore = 50.0,
    this.averageVisitDuration = 60,
    this.amenities = const [],
    this.isAccessibilityFriendly = false,
    this.contactNumber = '',
    this.website = '',
    this.distanceFromUser = 0.0,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'totalRatings': totalRatings,
      'categories': categories,
      'moods': moods,
      'prices': prices,
      'openingHours': openingHours?.toJson(),
      'photos': photos,
      'popularityScore': popularityScore,
      'averageVisitDuration': averageVisitDuration,
      'amenities': amenities,
      'isAccessibilityFriendly': isAccessibilityFriendly,
      'contactNumber': contactNumber,
      'website': website,
      'distanceFromUser': distanceFromUser,
    };
  }

  // Create from JSON
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      description: json['description'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      rating: json['rating']?.toDouble() ?? 0.0,
      totalRatings: json['totalRatings'] ?? 0,
      categories: List<String>.from(json['categories'] ?? []),
      moods: List<String>.from(json['moods'] ?? []),
      prices: Map<String, double>.from(json['prices'] ?? {}),
      openingHours: json['openingHours'] != null
          ? OpeningHours.fromJson(json['openingHours'])
          : null,
      photos: List<String>.from(json['photos'] ?? []),
      popularityScore: json['popularityScore']?.toDouble() ?? 50.0,
      averageVisitDuration: json['averageVisitDuration'] ?? 60,
      amenities: List<String>.from(json['amenities'] ?? []),
      isAccessibilityFriendly: json['isAccessibilityFriendly'] ?? false,
      contactNumber: json['contactNumber'] ?? '',
      website: json['website'] ?? '',
      distanceFromUser: json['distanceFromUser']?.toDouble() ?? 0.0,
    );
  }

  // Get price range
  String get priceRange {
    if (prices.isEmpty) return 'Free';

    final priceValues = prices.values.toList();
    priceValues.sort();

    final minPrice = priceValues.first;
    final maxPrice = priceValues.last;

    if (minPrice == maxPrice) return '\$${minPrice.toStringAsFixed(2)}';
    return '\$${minPrice.toStringAsFixed(2)} - \$${maxPrice.toStringAsFixed(2)}';
  }

  // Get average price
  double get averagePrice {
    if (prices.isEmpty) return 0.0;
    final sum = prices.values.reduce((a, b) => a + b);
    return sum / prices.length;
  }

  // Calculate distance from another location (in km)
  double calculateDistance(double lat2, double lon2) {
    const earthRadius = 6371.0; // Earth's radius in km

    final dLat = _toRadians(lat2 - latitude);
    final dLon = _toRadians(lon2 - longitude);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(latitude)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  // Get crowd prediction for a specific time
  CrowdPrediction getCrowdPrediction(DateTime time) {
    // Simple prediction algorithm based on:
    // 1. Day of week (weekends are busier)
    // 2. Time of day (peak hours)
    // 3. Popularity score
    // 4. Seasonality

    double baseScore = popularityScore / 100;

    // Weekend adjustment
    if (time.weekday >= 6) { // Saturday or Sunday
      baseScore *= 1.3;
    }

    // Peak hours adjustment (10 AM - 4 PM)
    if (time.hour >= 10 && time.hour <= 16) {
      baseScore *= 1.4;
    }

    // Determine crowd level
    String level;
    int crowdColor;

    if (baseScore <= 0.4) {
      level = 'Low';
      crowdColor = 0xFF4CAF50; // Green
    } else if (baseScore <= 0.7) {
      level = 'Medium';
      crowdColor = 0xFFFF9800; // Orange
    } else {
      level = 'High';
      crowdColor = 0xFFF44336; // Red
    }

    return CrowdPrediction(
      level: level,
      color: crowdColor,
      confidence: 0.8, // Confidence score
      bestTimeToVisit: _calculateBestTimeToVisit(),
    );
  }

  String _calculateBestTimeToVisit() {
    // Simple logic: recommend early morning or late afternoon for popular places
    if (popularityScore > 70) {
      return 'Early Morning (8-10 AM)';
    } else if (popularityScore > 40) {
      return 'Late Afternoon (3-5 PM)';
    } else {
      return 'Anytime';
    }
  }

  // Check if place is open at given time
  bool isOpenAt(DateTime time) {
    if (openingHours == null) return true;

    final dayOfWeek = time.weekday;
    final hour = time.hour;
    final minute = time.minute;

    final timeInMinutes = hour * 60 + minute;

    // Find opening hours for this day
    final dayHours = openingHours!.hours[dayOfWeek];
    if (dayHours == null) return false;

    return timeInMinutes >= dayHours.openTime &&
        timeInMinutes <= dayHours.closeTime;
  }

  // Get estimated wait time based on crowd
  int getEstimatedWaitTime(String crowdLevel) {
    switch (crowdLevel.toLowerCase()) {
      case 'low':
        return 0; // No wait
      case 'medium':
        return averageVisitDuration ~/ 4; // 25% of visit time
      case 'high':
        return averageVisitDuration ~/ 2; // 50% of visit time
      default:
        return 0;
    }
  }
}

class OpeningHours {
  Map<int, DayHours> hours; // weekday (1=Monday, 7=Sunday) -> DayHours

  OpeningHours(this.hours);

  Map<String, dynamic> toJson() {
    return {
      'hours': hours.map((key, value) => MapEntry(key.toString(), value.toJson())),
    };
  }

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    final hoursMap = <int, DayHours>{};
    json['hours'].forEach((key, value) {
      hoursMap[int.parse(key)] = DayHours.fromJson(value);
    });
    return OpeningHours(hoursMap);
  }
}

class DayHours {
  int openTime; // in minutes from midnight
  int closeTime; // in minutes from midnight

  DayHours({required this.openTime, required this.closeTime});

  Map<String, dynamic> toJson() {
    return {
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }

  factory DayHours.fromJson(Map<String, dynamic> json) {
    return DayHours(
      openTime: json['openTime'],
      closeTime: json['closeTime'],
    );
  }

  // Format time for display
  String get formattedHours {
    final openHour = openTime ~/ 60;
    final openMinute = openTime % 60;
    final closeHour = closeTime ~/ 60;
    final closeMinute = closeTime % 60;

    return '${openHour.toString().padLeft(2, '0')}:${openMinute.toString().padLeft(2, '0')} - '
        '${closeHour.toString().padLeft(2, '0')}:${closeMinute.toString().padLeft(2, '0')}';
  }
}

class CrowdPrediction {
  String level;
  int color; // Store as integer (0xAARRGGBB)
  double confidence; // 0.0 to 1.0
  String bestTimeToVisit;

  CrowdPrediction({
    required this.level,
    required this.color,
    required this.confidence,
    required this.bestTimeToVisit,
  });
}

// Activity model for places
class Activity {
  String id;
  String name;
  String description;
  double duration; // in hours
  double cost;
  String difficulty; // Easy, Medium, Hard
  List<String> requiredEquipment;
  int minimumAge;
  bool requiresBooking;
  String seasonAvailability; // All, Summer, Winter, etc.
  List<String> safetyInstructions;

  Activity({
    required this.id,
    required this.name,
    required this.description,
    this.duration = 1.0,
    this.cost = 0.0,
    this.difficulty = 'Easy',
    this.requiredEquipment = const [],
    this.minimumAge = 0,
    this.requiresBooking = false,
    this.seasonAvailability = 'All',
    this.safetyInstructions = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'duration': duration,
      'cost': cost,
      'difficulty': difficulty,
      'requiredEquipment': requiredEquipment,
      'minimumAge': minimumAge,
      'requiresBooking': requiresBooking,
      'seasonAvailability': seasonAvailability,
      'safetyInstructions': safetyInstructions,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      duration: json['duration']?.toDouble() ?? 1.0,
      cost: json['cost']?.toDouble() ?? 0.0,
      difficulty: json['difficulty'] ?? 'Easy',
      requiredEquipment: List<String>.from(json['requiredEquipment'] ?? []),
      minimumAge: json['minimumAge'] ?? 0,
      requiresBooking: json['requiresBooking'] ?? false,
      seasonAvailability: json['seasonAvailability'] ?? 'All',
      safetyInstructions: List<String>.from(json['safetyInstructions'] ?? []),
    );
  }
}