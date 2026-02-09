class User {
  String id;
  String name;
  String email;
  String? profileImageUrl;
  DateTime createdAt;
  List<String> preferredTripTypes;
  List<String> favoriteDestinations;
  List<String> travelInterests;
  double averageBudget;
  Map<String, int> moodPreferences; // mood -> frequency count

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.createdAt,
    this.preferredTripTypes = const [],
    this.favoriteDestinations = const [],
    this.travelInterests = const [],
    this.averageBudget = 1000.0,
    this.moodPreferences = const {},
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'preferredTripTypes': preferredTripTypes,
      'favoriteDestinations': favoriteDestinations,
      'travelInterests': travelInterests,
      'averageBudget': averageBudget,
      'moodPreferences': moodPreferences,
    };
  }

  // Create from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      preferredTripTypes: List<String>.from(json['preferredTripTypes'] ?? []),
      favoriteDestinations: List<String>.from(json['favoriteDestinations'] ?? []),
      travelInterests: List<String>.from(json['travelInterests'] ?? []),
      averageBudget: json['averageBudget']?.toDouble() ?? 1000.0,
      moodPreferences: Map<String, int>.from(json['moodPreferences'] ?? {}),
    );
  }

  // Update user preferences
  void updatePreferences({
    List<String>? newTripTypes,
    List<String>? newDestinations,
    List<String>? newInterests,
    double? newBudget,
    String? mood,
  }) {
    if (newTripTypes != null) {
      preferredTripTypes = newTripTypes;
    }
    if (newDestinations != null) {
      favoriteDestinations = newDestinations;
    }
    if (newInterests != null) {
      travelInterests = newInterests;
    }
    if (newBudget != null) {
      averageBudget = newBudget;
    }
    if (mood != null) {
      moodPreferences[mood] = (moodPreferences[mood] ?? 0) + 1;
    }
  }

  // Get top 3 moods based on frequency
  List<String> getTopMoods({int limit = 3}) {
    var sortedEntries = moodPreferences.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries
        .take(limit)
        .map((entry) => entry.key)
        .toList();
  }

  // Calculate match score for a destination based on user preferences
  double calculateDestinationMatchScore(Destination destination) {
    double score = 0.0;

    // Match interests
    for (var interest in travelInterests) {
      if (destination.suitableActivities.any((activity) =>
          activity.toLowerCase().contains(interest.toLowerCase()))) {
        score += 10;
      }
    }

    // Match budget
    if (destination.averageCostPerDay <= averageBudget) {
      score += 20;
    } else if (destination.averageCostPerDay <= averageBudget * 1.5) {
      score += 10;
    }

    // Match trip types
    for (var tripType in preferredTripTypes) {
      if (destination.suitableFor.contains(tripType)) {
        score += 15;
      }
    }

    // Match moods
    for (var mood in getTopMoods()) {
      if (destination.moods.contains(mood)) {
        score += 12;
      }
    }

    return score;
  }

  // Create guest user
  factory User.guest() {
    return User(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Guest',
      email: 'guest@example.com',
      createdAt: DateTime.now(),
    );
  }
}

// Destination model for user preference matching
class Destination {
  String id;
  String name;
  String country;
  String description;
  List<String> moods;
  List<String> suitableFor; // trip types
  List<String> suitableActivities;
  double averageCostPerDay;
  String bestSeason;
  int crowdLevel; // 1-10 scale
  List<String> nearbyAttractions;

  Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.description,
    this.moods = const [],
    this.suitableFor = const [],
    this.suitableActivities = const [],
    this.averageCostPerDay = 100.0,
    this.bestSeason = 'All',
    this.crowdLevel = 5,
    this.nearbyAttractions = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'description': description,
      'moods': moods,
      'suitableFor': suitableFor,
      'suitableActivities': suitableActivities,
      'averageCostPerDay': averageCostPerDay,
      'bestSeason': bestSeason,
      'crowdLevel': crowdLevel,
      'nearbyAttractions': nearbyAttractions,
    };
  }

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      description: json['description'],
      moods: List<String>.from(json['moods'] ?? []),
      suitableFor: List<String>.from(json['suitableFor'] ?? []),
      suitableActivities: List<String>.from(json['suitableActivities'] ?? []),
      averageCostPerDay: json['averageCostPerDay']?.toDouble() ?? 100.0,
      bestSeason: json['bestSeason'] ?? 'All',
      crowdLevel: json['crowdLevel'] ?? 5,
      nearbyAttractions: List<String>.from(json['nearbyAttractions'] ?? []),
    );
  }

  // Get crowd level description
  String get crowdDescription {
    if (crowdLevel <= 3) return 'Low Crowd';
    if (crowdLevel <= 6) return 'Medium Crowd';
    return 'High Crowd';
  }

  // Get color for crowd level
  int get crowdColor {
    if (crowdLevel <= 3) return 0xFF4CAF50; // Green
    if (crowdLevel <= 6) return 0xFFFF9800; // Orange
    return 0xFFF44336; // Red
  }
}