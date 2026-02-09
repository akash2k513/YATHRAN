import 'package:intl/intl.dart';

class Helpers {
  // Format date
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  // Format time
  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  // Calculate days between dates
  static int calculateDays(DateTime start, DateTime end) {
    return end.difference(start).inDays + 1;
  }

  // Format currency
  static String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  // Get crowd color
  static int getCrowdColor(String crowdLevel) {
    switch (crowdLevel.toLowerCase()) {
      case 'low':
        return 0xFF4CAF50; // Green
      case 'medium':
        return 0xFFFF9800; // Orange
      case 'high':
        return 0xFFF44336; // Red
      default:
        return 0xFF9E9E9E; // Grey
    }
  }

  // Get activity icon
  static String getActivityIcon(String activityType) {
    Map<String, String> icons = {
      'Historical Sites': '🏛️',
      'Beaches': '🏖️',
      'Mountains': '⛰️',
      'Shopping': '🛍️',
      'Food': '🍽️',
      'Museums': '🏛️',
      'Nightlife': '🌃',
      'Adventure Sports': '🏄',
      'Nature Walks': '🚶',
      'Photography Spots': '📸',
    };

    return icons[activityType] ?? '📍';
  }

  // Calculate budget per day
  static double calculateDailyBudget(double totalBudget, int days) {
    return totalBudget / days;
  }

  // Generate random ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Validate email
  static bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }
}