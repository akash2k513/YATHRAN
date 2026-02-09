import 'dart:math';
import 'package:flutter/material.dart';

import '../models/place_model.dart';
import '../models/trip_model.dart';
import '../models/user_model.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  // 1. Mood-Based Recommendation Model
  List<String> getMoodBasedRecommendations(List<String> moods, String tripType) {
    Map<String, List<String>> moodMap = {
      'Romantic': ['Sunset cruises', 'Fine dining', 'Couples spa', 'Romantic walks'],
      'Adventure': ['Hiking trails', 'Water sports', 'Mountain biking', 'Zip lining'],
      'Nature': ['National parks', 'Botanical gardens', 'Wildlife safaris', 'Beach visits'],
      'Food Exploration': ['Food tours', 'Cooking classes', 'Local markets', 'Wine tasting'],
      'Shopping': ['Local markets', 'Shopping malls', 'Boutique stores', 'Artisan workshops'],
      'Cultural': ['Museums', 'Historical sites', 'Cultural shows', 'Local festivals'],
      'Family': ['Theme parks', 'Zoos', 'Interactive museums', 'Family-friendly beaches'],
      'Photography': ['Scenic viewpoints', 'Architectural sites', 'Natural wonders', 'Urban exploration'],
      'Spiritual': ['Temples', 'Churches', 'Meditation centers', 'Pilgrimage sites'],
    };

    // Combine recommendations based on selected moods
    List<String> recommendations = [];
    for (var mood in moods) {
      if (moodMap.containsKey(mood)) {
        recommendations.addAll(moodMap[mood]!);
      }
    }

    // Filter based on trip type
    return _filterByTripType(recommendations, tripType);
  }

  List<String> _filterByTripType(List<String> recommendations, String tripType) {
    // Remove duplicates
    return recommendations.toSet().toList();
  }

  // 2. Multi-User Preference Balancer
  Map<String, double> balanceGroupPreferences(List<Traveler> travelers) {
    Map<String, double> preferenceScores = {};
    double totalWeight = 0;

    // Calculate weighted preferences
    for (var traveler in travelers) {
      double weight = traveler.isCurrentUser ? 1.5 : 1.0;
      totalWeight += weight;

      if (traveler.selectedInterests != null) {
        for (var interest in traveler.selectedInterests!) {
          preferenceScores[interest] = (preferenceScores[interest] ?? 0) + weight;
        }
      }
    }

    // Normalize scores
    for (var key in preferenceScores.keys) {
      preferenceScores[key] = preferenceScores[key]! / totalWeight * 100;
    }

    return preferenceScores;
  }

  // 3. Crowd Prediction Algorithm
  Map<String, dynamic> predictCrowd({
    required String placeName,
    required DateTime dateTime,
    required double basePopularity,
    List<String> nearbyEvents = const [],
    String weather = 'Sunny',
  }) {
    double crowdScore = basePopularity / 100;

    // Day of week adjustment
    if (dateTime.weekday >= 6) { // Weekend
      crowdScore *= 1.5;
    }

    // Time of day adjustment
    int hour = dateTime.hour;
    if (hour >= 10 && hour <= 16) { // Peak hours
      crowdScore *= 1.3;
    }

    // Weather adjustment
    if (weather.toLowerCase().contains('sunny') || weather.toLowerCase().contains('clear')) {
      crowdScore *= 1.2;
    } else if (weather.toLowerCase().contains('rain')) {
      crowdScore *= 0.7;
    }

    // Event adjustment
    if (nearbyEvents.isNotEmpty) {
      crowdScore *= 1.4;
    }

    // Determine crowd level
    String crowdLevel;
    Color crowdColor;
    String bestTime;

    if (crowdScore <= 0.4) {
      crowdLevel = 'Low';
      crowdColor = Colors.green;
      bestTime = 'Anytime';
    } else if (crowdScore <= 0.7) {
      crowdLevel = 'Medium';
      crowdColor = Colors.orange;
      bestTime = 'Early Morning or Late Afternoon';
    } else if (crowdScore <= 0.9) {
      crowdLevel = 'High';
      crowdColor = Colors.red;
      bestTime = 'Weekday Mornings';
    } else {
      crowdLevel = 'Very High';
      crowdColor = Colors.purple;
      bestTime = 'Avoid Weekends';
    }

    return {
      'level': crowdLevel,
      'color': crowdColor,
      'score': crowdScore,
      'bestTime': bestTime,
      'confidence': 0.85,
      'factors': {
        'weekend': dateTime.weekday >= 6,
        'peakHours': hour >= 10 && hour <= 16,
        'weather': weather,
        'events': nearbyEvents.isNotEmpty,
      },
    };
  }

  // 4. Route Optimization Algorithm
  List<Place> optimizeRoute(List<Place> places, double startLat, double startLon) {
    if (places.length <= 1) return places;

    List<Place> optimizedRoute = [];
    List<Place> remaining = List.from(places);
    double currentLat = startLat;
    double currentLon = startLon;

    while (remaining.isNotEmpty) {
      // Find nearest place
      Place nearest = remaining[0];
      double nearestDistance = _calculateDistance(
        currentLat, currentLon,
        nearest.latitude, nearest.longitude,
      );

      for (int i = 1; i < remaining.length; i++) {
        double distance = _calculateDistance(
          currentLat, currentLon,
          remaining[i].latitude, remaining[i].longitude,
        );
        if (distance < nearestDistance) {
          nearest = remaining[i];
          nearestDistance = distance;
        }
      }

      optimizedRoute.add(nearest);
      remaining.remove(nearest);
      currentLat = nearest.latitude;
      currentLon = nearest.longitude;
    }

    return optimizedRoute;
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Earth's radius in km
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  // 5. Budget Optimization Algorithm
  Map<String, dynamic> optimizeBudget(
      List<Place> places,
      double totalBudget,
      int days,
      List<String> priorityActivities,
      ) {
    double dailyBudget = totalBudget / days;
    List<Place> affordablePlaces = [];
    List<Place> premiumPlaces = [];
    double totalCost = 0;

    // Categorize places by cost
    for (var place in places) {
      double placeCost = place.averagePrice;

      if (priorityActivities.any((activity) =>
          place.categories.any((category) =>
              category.toLowerCase().contains(activity.toLowerCase())))) {
        // Priority activity - include even if expensive
        premiumPlaces.add(place);
        totalCost += placeCost;
      } else if (placeCost <= dailyBudget * 0.3) {
        // Affordable place
        affordablePlaces.add(place);
        totalCost += placeCost;
      }
    }

    // If over budget, replace expensive places with affordable alternatives
    while (totalCost > totalBudget && premiumPlaces.isNotEmpty) {
      Place mostExpensive = premiumPlaces.reduce((a, b) =>
      a.averagePrice > b.averagePrice ? a : b);
      premiumPlaces.remove(mostExpensive);
      totalCost -= mostExpensive.averagePrice;

      // Find affordable alternative
      if (affordablePlaces.isNotEmpty) {
        Place alternative = affordablePlaces.first;
        affordablePlaces.removeAt(0);
        affordablePlaces.add(alternative);
        totalCost += alternative.averagePrice;
      }
    }

    return {
      'places': [...premiumPlaces, ...affordablePlaces],
      'totalCost': totalCost,
      'budgetStatus': totalCost <= totalBudget ? 'Within Budget' : 'Slightly Over',
      'savings': totalBudget - totalCost,
      'recommendations': totalCost > totalBudget ?
      ['Consider visiting on weekdays', 'Look for combo tickets', 'Skip non-essential activities'] :
      ['Budget looks good!', 'You can add more activities', 'Consider premium experiences'],
    };
  }

  // 6. Dynamic Replanning Algorithm
  Map<String, dynamic> replanItinerary(
      List<Place> currentItinerary,
      Map<String, dynamic> conditions,
      List<Place> alternativePlaces,
      ) {
    List<Place> updatedItinerary = List.from(currentItinerary);
    List<String> changes = [];
    String status = 'No changes needed';

    // Helper function to simulate crowd prediction
    Map<String, dynamic> _simulateCrowdPrediction(Place place) {
      // This is a simplified simulation
      // In real implementation, this would use actual prediction logic
      return predictCrowd(
        placeName: place.name,
        dateTime: DateTime.now(),
        basePopularity: place.popularityScore,
      );
    }

    // Check crowd conditions
    if (conditions['crowd'] != null && conditions['crowd'] == 'High') {
      for (int i = 0; i < updatedItinerary.length; i++) {
        var place = updatedItinerary[i];
        var crowdPrediction = _simulateCrowdPrediction(place);

        if (crowdPrediction['level'] == 'High' || crowdPrediction['level'] == 'Very High') {
          // Find alternative with similar interests
          Place? alternative;
          for (var alt in alternativePlaces) {
            bool hasMoodMatch = alt.moods.any((mood) => place.moods.contains(mood));
            bool hasCategoryMatch = alt.categories.any((cat) => place.categories.contains(cat));
            var altCrowdPrediction = _simulateCrowdPrediction(alt);

            if (hasMoodMatch && hasCategoryMatch && altCrowdPrediction['level'] == 'Low') {
              alternative = alt;
              break;
            }
          }

          if (alternative != null && alternative != place) {
            updatedItinerary[i] = alternative;
            changes.add('Replaced ${place.name} with ${alternative.name} due to crowd');
          }
        }
      }
      status = 'Crowd-based adjustments made';
    }

    // Check weather conditions
    if (conditions['weather'] != null &&
        (conditions['weather'].contains('Rain') || conditions['weather'].contains('Storm'))) {
      for (int i = 0; i < updatedItinerary.length; i++) {
        var place = updatedItinerary[i];

        // Replace outdoor activities with indoor alternatives
        bool isOutdoor = place.categories.any((cat) =>
            ['hiking', 'beach', 'outdoor', 'garden'].contains(cat.toLowerCase()));

        if (isOutdoor) {
          Place? indoorAlternative;
          for (var alt in alternativePlaces) {
            bool isIndoor = alt.categories.any((cat) =>
                ['museum', 'shopping', 'indoor', 'restaurant'].contains(cat.toLowerCase()));

            if (isIndoor) {
              indoorAlternative = alt;
              break;
            }
          }

          if (indoorAlternative != null && indoorAlternative != place) {
            updatedItinerary[i] = indoorAlternative;
            changes.add('Replaced ${place.name} with indoor alternative due to weather');
          }
        }
      }
      status = 'Weather-based adjustments made';
    }

    return {
      'itinerary': updatedItinerary,
      'changes': changes,
      'status': status,
      'timestamp': DateTime.now(),
    };
  }

  // 7. Smart Itinerary Generator
  Map<String, dynamic> generateSmartItinerary({
    required List<Place> places,
    required DateTime startDate,
    required int days,
    required double dailyBudget,
    required List<String> selectedMoods,
    required List<Traveler> travelers,
  }) {
    List<DayPlan> itinerary = [];
    List<Place> remainingPlaces = List.from(places);
    double totalCost = 0;
    int totalTravelTime = 0;

    for (int day = 0; day < days; day++) {
      DateTime currentDate = startDate.add(Duration(days: day));
      List<Place> dailyPlaces = [];
      double dailyCost = 0;
      int dailyTravelTime = 0;

      // Select 3-4 places per day based on mood and preferences
      int maxPlacesPerDay = min(4, remainingPlaces.length);
      for (int i = 0; i < maxPlacesPerDay; i++) {
        if (i >= remainingPlaces.length) break;

        Place place = remainingPlaces[i];

        // Check crowd prediction for this time
        var crowdPrediction = predictCrowd(
          placeName: place.name,
          dateTime: currentDate,
          basePopularity: place.popularityScore,
        );

        // Skip if crowd is too high
        if (crowdPrediction['level'] == 'Very High') {
          continue;
        }

        dailyPlaces.add(place);
        dailyCost += place.averagePrice;

        // Estimate travel time (30 minutes between places)
        if (dailyPlaces.length > 1) {
          dailyTravelTime += 30;
        }
        dailyTravelTime += place.averageVisitDuration;

        totalCost += place.averagePrice;
        totalTravelTime += dailyTravelTime;
      }

      // Remove selected places from remaining
      remainingPlaces.removeWhere((place) => dailyPlaces.contains(place));

      itinerary.add(DayPlan(
        day: day + 1,
        date: currentDate,
        activities: dailyPlaces.map((place) {
          var crowdPrediction = predictCrowd(
            placeName: place.name,
            dateTime: currentDate,
            basePopularity: place.popularityScore,
          );

          return Activity(
            time: _generateTimeSlot(dailyPlaces.indexOf(place)),
            name: place.name,
            description: place.description ?? 'Visit this amazing place',
            location: place.address,
            crowdLevel: crowdPrediction['level'],
            budget: place.averagePrice,
            travelTime: 30, // Estimated travel time
          );
        }).toList(),
      ));
    }

    return {
      'days': itinerary,
      'totalCost': totalCost,
      'totalTravelTime': totalTravelTime,
      'budgetStatus': totalCost <= (dailyBudget * days) ? 'Within Budget' : 'Over Budget',
      'crowdSummary': _generateCrowdSummary(itinerary),
      'aiNotes': _generateAINotes(itinerary, selectedMoods, travelers),
    };
  }

  String _generateTimeSlot(int index) {
    List<String> timeSlots = [
      '09:00 AM',
      '11:30 AM',
      '02:00 PM',
      '04:30 PM',
      '07:00 PM',
    ];
    return index < timeSlots.length ? timeSlots[index] : 'Evening';
  }

  String _generateCrowdSummary(List<DayPlan> itinerary) {
    int lowCount = 0, mediumCount = 0, highCount = 0;

    for (var day in itinerary) {
      for (var activity in day.activities) {
        switch (activity.crowdLevel.toLowerCase()) {
          case 'low':
            lowCount++;
            break;
          case 'medium':
            mediumCount++;
            break;
          case 'high':
          case 'very high':
            highCount++;
            break;
        }
      }
    }

    if (highCount > lowCount + mediumCount) {
      return 'Heavy crowds expected. Consider alternative timing.';
    } else if (lowCount > mediumCount + highCount) {
      return 'Great crowd levels! Perfect timing.';
    } else {
      return 'Mixed crowd levels. Some adjustments may be needed.';
    }
  }

  String _generateAINotes(List<DayPlan> itinerary, List<String> moods, List<Traveler> travelers) {
    List<String> notes = [];

    // Mood-based notes
    if (moods.contains('Romantic')) {
      notes.add('Perfect for romantic moments. Consider adding dinner reservations.');
    }
    if (moods.contains('Adventure')) {
      notes.add('Adventure activities included. Make sure to pack appropriate gear.');
    }

    // Group-based notes
    bool hasLowActivityTravelers = travelers.any((t) => t.activityLevel == 'Low');
    if (hasLowActivityTravelers) {
      notes.add('Paced for comfortable activity levels.');
    }
    if (travelers.length > 2) {
      notes.add('Group-friendly itinerary with options for splitting up.');
    }

    return notes.isNotEmpty ? '• ${notes.join('\n• ')}' : 'No special notes.';
  }
}

// Helper classes for itinerary generation
class DayPlan {
  final int day;
  final DateTime date;
  final List<Activity> activities;

  DayPlan({
    required this.day,
    required this.date,
    required this.activities,
  });
}

class Activity {
  final String time;
  final String name;
  final String description;
  final String location;
  final String crowdLevel;
  final double budget;
  final int travelTime;

  Activity({
    required this.time,
    required this.name,
    required this.description,
    required this.location,
    required this.crowdLevel,
    required this.budget,
    required this.travelTime,
  });
}