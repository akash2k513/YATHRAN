import '../models/place_model.dart';
import '../models/trip_model.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  // Mood-based place filtering
  List<Place> filterPlacesByMood(List<Place> places, List<String> moods) {
    return places.where((place) {
      return place.moods.any((placeMood) => moods.contains(placeMood));
    }).toList();
  }

  // Group preference balancing for places
  List<Place> balanceGroupPreferences(
      List<Place> places,
      List<Traveler> travelers,
      List<String> selectedMoods,
      ) {
    List<PlaceScore> placeScores = [];

    for (var place in places) {
      double score = 0;
      int travelerCount = travelers.length;

      // Mood match score
      double moodScore = _calculateMoodMatchScore(place, selectedMoods);
      score += moodScore * 0.3;

      // Interest match score
      double interestScore = _calculateInterestMatchScore(place, travelers);
      score += interestScore * 0.4;

      // Activity level match score
      double activityScore = _calculateActivityMatchScore(place, travelers);
      score += activityScore * 0.2;

      // Rating bonus
      score += place.rating * 0.1;

      placeScores.add(PlaceScore(place: place, score: score));
    }

    // Sort by score descending
    placeScores.sort((a, b) => b.score.compareTo(a.score));

    return placeScores.map((ps) => ps.place).toList();
  }

  double _calculateMoodMatchScore(Place place, List<String> selectedMoods) {
    if (selectedMoods.isEmpty || place.moods.isEmpty) return 0;

    int matches = 0;
    for (var mood in selectedMoods) {
      if (place.moods.contains(mood)) {
        matches++;
      }
    }

    return matches / selectedMoods.length * 100;
  }

  double _calculateInterestMatchScore(Place place, List<Traveler> travelers) {
    if (travelers.isEmpty) return 0;

    double totalScore = 0;
    for (var traveler in travelers) {
      double travelerScore = 0;

      for (var interest in traveler.selectedInterests) {
        if (place.categories.any((category) =>
            category.toLowerCase().contains(interest.toLowerCase()))) {
          travelerScore += 10;
        }
      }

      if (traveler.isCurrentUser) {
        travelerScore *= 1.2;
      }

      totalScore += travelerScore;
    }

    return totalScore / travelers.length;
  }

  double _calculateActivityMatchScore(Place place, List<Traveler> travelers) {
    int placeActivityLevel = _estimatePlaceActivityLevel(place);

    double totalScore = 0;
    for (var traveler in travelers) {
      int travelerActivityLevel = _convertActivityLevel(traveler.activityLevel);

      int levelDifference = (placeActivityLevel - travelerActivityLevel).abs();
      double matchScore = 10 - levelDifference * 2;

      if (matchScore < 0) matchScore = 0;

      totalScore += matchScore;
    }

    return totalScore / travelers.length;
  }

  int _estimatePlaceActivityLevel(Place place) {
    Map<String, int> categoryLevels = {
      'hiking': 5,
      'adventure': 5,
      'sports': 4,
      'walking': 3,
      'museum': 2,
      'art': 2,
      'shopping': 2,
      'dining': 1,
      'relaxation': 1,
    };

    int maxLevel = 1;
    for (var category in place.categories) {
      final level = categoryLevels[category.toLowerCase()] ?? 2;
      if (level > maxLevel) maxLevel = level;
    }

    return maxLevel;
  }

  int _convertActivityLevel(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return 1;
      case 'medium':
        return 3;
      case 'high':
        return 5;
      default:
        return 3;
    }
  }

  // Crowd-aware scheduling
  List<Place> schedulePlacesByCrowd(List<Place> places, DateTime tripDate) {
    return places..sort((a, b) {
      final aCrowd = a.getCrowdPrediction(tripDate);
      final bCrowd = b.getCrowdPrediction(tripDate);

      if (aCrowd.level != bCrowd.level) {
        return _crowdLevelToValue(aCrowd.level) - _crowdLevelToValue(bCrowd.level);
      }

      return b.rating.compareTo(a.rating);
    });
  }

  int _crowdLevelToValue(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return 1;
      case 'medium':
        return 2;
      case 'high':
        return 3;
      default:
        return 2;
    }
  }

  // Budget optimization
  List<Place> optimizeForBudget(List<Place> places, double dailyBudget, int days) {
    final double budgetPerDay = dailyBudget / days;

    return places.where((place) {
      if (place.averagePrice > budgetPerDay * 0.4) {
        return false;
      }

      double valueScore = place.popularityScore / (place.averagePrice + 1);
      return valueScore > 10;
    }).toList();
  }

  // Route optimization
  List<Place> optimizeRouteOrder(List<Place> places, double startLat, double startLon) {
    if (places.length <= 1) return places;

    List<Place> result = [];
    List<Place> remaining = List.from(places);

    double currentLat = startLat;
    double currentLon = startLon;

    while (remaining.isNotEmpty) {
      Place nearest = remaining[0];
      double nearestDistance = nearest.calculateDistance(currentLat, currentLon);

      for (int i = 1; i < remaining.length; i++) {
        final distance = remaining[i].calculateDistance(currentLat, currentLon);
        if (distance < nearestDistance) {
          nearest = remaining[i];
          nearestDistance = distance;
        }
      }

      result.add(nearest);
      remaining.remove(nearest);

      currentLat = nearest.latitude;
      currentLon = nearest.longitude;
    }

    return result;
  }

  // Generate daily itinerary
  Map<String, dynamic> generateDailyItinerary(
      List<Place> places,
      DateTime date,
      double dailyBudget,
      int maxActivities,
      ) {
    List<Place> dailyPlaces = places.take(maxActivities).toList();
    double totalCost = dailyPlaces.fold(0.0, (sum, place) => sum + place.averagePrice);
    int totalDuration = dailyPlaces.fold(0, (sum, place) => sum + place.averageVisitDuration);

    int travelTime = (dailyPlaces.length - 1) * 30;

    return {
      'date': date,
      'places': dailyPlaces,
      'totalCost': totalCost,
      'totalDuration': totalDuration + travelTime,
      'budgetStatus': totalCost <= dailyBudget ? 'Within Budget' : 'Over Budget',
      'crowdSummary': _generateCrowdSummary(dailyPlaces, date),
    };
  }

  String _generateCrowdSummary(List<Place> places, DateTime date) {
    int lowCount = 0, mediumCount = 0, highCount = 0;

    for (var place in places) {
      final crowd = place.getCrowdPrediction(date);
      switch (crowd.level.toLowerCase()) {
        case 'low':
          lowCount++;
          break;
        case 'medium':
          mediumCount++;
          break;
        case 'high':
          highCount++;
          break;
      }
    }

    if (highCount > lowCount + mediumCount) {
      return 'Busy day - consider adjusting timing';
    } else if (lowCount > mediumCount + highCount) {
      return 'Good crowd levels throughout';
    } else {
      return 'Mixed crowd levels';
    }
  }
}

class PlaceScore {
  final Place place;
  final double score;

  PlaceScore({required this.place, required this.score});
}