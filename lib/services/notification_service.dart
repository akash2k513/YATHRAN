import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Send notification
  void sendNotification({
    required BuildContext context,
    required String title,
    required String message,
    String type = 'info',
  }) {
    Color backgroundColor;
    switch (type) {
      case 'warning':
        backgroundColor = Colors.orange;
        break;
      case 'error':
        backgroundColor = Colors.red;
        break;
      case 'success':
        backgroundColor = Colors.green;
        break;
      default:
        backgroundColor = Color(0xFF2F62A7);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Crowd alert
  void sendCrowdAlert(BuildContext context, String place, String crowdLevel) {
    sendNotification(
      context: context,
      title: 'Crowd Alert 🚨',
      message: '$place is $crowdLevel crowded right now',
      type: 'warning',
    );
  }

  // Weather alert
  void sendWeatherAlert(BuildContext context, String condition) {
    sendNotification(
      context: context,
      title: 'Weather Update 🌦️',
      message: 'Current weather: $condition. Plan accordingly!',
      type: 'info',
    );
  }

  // Route update
  void sendRouteUpdate(BuildContext context, String update) {
    sendNotification(
      context: context,
      title: 'Route Update 🗺️',
      message: update,
      type: 'info',
    );
  }

  // Reminder
  void sendReminder(BuildContext context, String activity, String time) {
    sendNotification(
      context: context,
      title: 'Reminder ⏰',
      message: '$activity at $time',
      type: 'info',
    );
  }
}