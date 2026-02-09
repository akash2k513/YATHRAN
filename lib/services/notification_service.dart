import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Helper function for min calculation
  int _min(int a, int b) => a < b ? a : b;

  // Smart Notification System
  void sendNotification({
    required BuildContext context,
    required String title,
    required String message,
    String type = 'info',
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case 'warning':
        backgroundColor = Colors.orange;
        icon = Icons.warning;
        break;
      case 'error':
        backgroundColor = Colors.red;
        icon = Icons.error;
        break;
      case 'success':
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'crowd':
        backgroundColor = Color(0xFF2F62A7);
        icon = Icons.people;
        break;
      case 'weather':
        backgroundColor = Color(0xFF4AB4DE);
        icon = Icons.cloud;
        break;
      case 'route':
        backgroundColor = Color(0xFF3B8AC3);
        icon = Icons.directions;
        break;
      default:
        backgroundColor = Color(0xFF2F62A7);
        icon = Icons.info;
    }

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: Column(
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
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      action: onTap != null
          ? SnackBarAction(
        label: 'View',
        textColor: Colors.white,
        onPressed: onTap,
      )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Crowd Alert System
  void sendCrowdAlert(BuildContext context, String place, String crowdLevel, String alternative) {
    sendNotification(
      context: context,
      title: '🚨 Crowd Alert',
      message: '$place is $crowdLevel crowded. Consider: $alternative',
      type: 'crowd',
      duration: Duration(seconds: 5),
      onTap: () {
        // Show crowd details
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Crowd Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.people, color: Colors.orange),
                  title: Text('Current Crowd'),
                  subtitle: Text(crowdLevel),
                ),
                ListTile(
                  leading: Icon(Icons.alt_route, color: Colors.green),
                  title: Text('Alternative'),
                  subtitle: Text(alternative),
                ),
                ListTile(
                  leading: Icon(Icons.access_time, color: Colors.blue),
                  title: Text('Best Time'),
                  subtitle: Text('Try visiting in the early morning'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Weather Alert System
  void sendWeatherAlert(BuildContext context, String condition, List<String> suggestions) {
    sendNotification(
      context: context,
      title: '🌦️ Weather Update',
      message: 'Current: $condition. ${suggestions.first}',
      type: 'weather',
      duration: Duration(seconds: 5),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Weather Advisory'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.cloud, color: Color(0xFF4AB4DE)),
                  title: Text('Condition'),
                  subtitle: Text(condition),
                ),
                ListTile(
                  leading: Icon(Icons.lightbulb, color: Colors.amber),
                  title: Text('Suggestions'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: suggestions
                        .map((suggestion) => Text('• $suggestion'))
                        .toList(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Update Itinerary'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Route Update System
  void sendRouteUpdate(BuildContext context, String update, int etaChange) {
    String etaText = etaChange > 0
        ? 'ETA increased by ${etaChange} min'
        : 'ETA decreased by ${-etaChange} min';

    sendNotification(
      context: context,
      title: '🛣️ Route Update',
      message: '$update. $etaText',
      type: 'route',
      onTap: () {
        // Show route details
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Route Information'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.update, color: Color(0xFF3B8AC3)),
                  title: Text('Update'),
                  subtitle: Text(update),
                ),
                ListTile(
                  leading: Icon(Icons.timer, color: etaChange > 0 ? Colors.red : Colors.green),
                  title: Text('Time Change'),
                  subtitle: Text(etaText),
                ),
                ListTile(
                  leading: Icon(Icons.alt_route, color: Colors.blue),
                  title: Text('Alternative Routes'),
                  subtitle: Text('Available through navigation'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('View Navigation'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Smart Reminder System
  void sendSmartReminder(BuildContext context, String activity, DateTime time) {
    String formattedTime = DateFormat('hh:mm a').format(time);
    Duration timeUntil = time.difference(DateTime.now());

    String timeMessage;
    if (timeUntil.inMinutes < 30) {
      timeMessage = 'Starting soon at $formattedTime';
    } else if (timeUntil.inHours < 2) {
      timeMessage = 'Coming up at $formattedTime';
    } else {
      timeMessage = 'Scheduled for $formattedTime';
    }

    sendNotification(
      context: context,
      title: '⏰ Reminder',
      message: '$activity - $timeMessage',
      type: 'info',
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Activity Reminder'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.event, color: Color(0xFF2F62A7)),
                  title: Text(activity),
                  subtitle: Text(formattedTime),
                ),
                ListTile(
                  leading: Icon(Icons.timer, color: Colors.orange),
                  title: Text('Time Until'),
                  subtitle: Text('${timeUntil.inMinutes} minutes'),
                ),
                ListTile(
                  leading: Icon(Icons.directions, color: Colors.green),
                  title: Text('Travel Time'),
                  subtitle: Text('Allow 15-30 minutes for travel'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Add to calendar or set alarm
                },
                child: Text('Add to Calendar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Snooze'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Daily Summary Notification
  void sendDailySummary(BuildContext context, Map<String, dynamic> summary) {
    sendNotification(
      context: context,
      title: '📅 Daily Summary',
      message: '${summary['activities']} activities planned. Budget: \$${summary['budget']}',
      type: 'success',
      duration: Duration(seconds: 5),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Daily Itinerary Summary'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.event_note, color: Color(0xFF2F62A7)),
                  title: Text('Activities'),
                  subtitle: Text('${summary['activities']} activities planned'),
                ),
                ListTile(
                  leading: Icon(Icons.attach_money, color: Colors.green),
                  title: Text('Budget'),
                  subtitle: Text('\$${summary['budget']} allocated'),
                ),
                ListTile(
                  leading: Icon(Icons.timer, color: Color(0xFF4AB4DE)),
                  title: Text('Total Time'),
                  subtitle: Text('${summary['totalTime']} hours'),
                ),
                if (summary['crowdAlerts'] > 0)
                  ListTile(
                    leading: Icon(Icons.warning, color: Colors.orange),
                    title: Text('Crowd Alerts'),
                    subtitle: Text('${summary['crowdAlerts']} crowded locations'),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Review Details'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Alternative Suggestion Notification
  void sendAlternativeSuggestion(BuildContext context, {
    required String originalPlace,
    required String alternativePlace,
    required String reason,
    required double savings,
    required String crowdComparison,
  }) {
    String savingsText = savings > 0 ? 'Save \$${savings.toStringAsFixed(2)}' : 'Similar cost';

    sendNotification(
      context: context,
      title: '💡 Smart Suggestion',
      message: 'Consider $alternativePlace instead of $originalPlace',
      type: 'info',
      duration: Duration(seconds: 6),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Alternative Suggestion'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.swap_horiz, color: Color(0xFF4AB4DE)),
                  title: Text('Original'),
                  subtitle: Text(originalPlace),
                ),
                ListTile(
                  leading: Icon(Icons.arrow_forward, color: Colors.green),
                  title: Text('Alternative'),
                  subtitle: Text(alternativePlace),
                ),
                ListTile(
                  leading: Icon(Icons.info, color: Color(0xFF2F62A7)),
                  title: Text('Reason'),
                  subtitle: Text(reason),
                ),
                ListTile(
                  leading: Icon(Icons.savings, color: Colors.green),
                  title: Text('Savings'),
                  subtitle: Text(savingsText),
                ),
                ListTile(
                  leading: Icon(Icons.people, color: Colors.orange),
                  title: Text('Crowd Comparison'),
                  subtitle: Text(crowdComparison),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Accept alternative
                  sendNotification(
                    context: context,
                    title: '✅ Alternative Accepted',
                    message: 'Itinerary updated with $alternativePlace',
                    type: 'success',
                  );
                },
                child: Text('Use Alternative'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Keep Original'),
              ),
            ],
          ),
        );
      },
    );
  }

  // AI Companion Chat Notification
  void sendAIChatNotification(BuildContext context, String question, String answer) {
    // Use the helper function instead of the standalone min function
    int maxLength = _min(30, question.length);

    sendNotification(
      context: context,
      title: '🤖 AI Travel Assistant',
      message: 'Answer to: "${question.substring(0, maxLength)}${question.length > 30 ? '...' : ''}"',
      type: 'info',
      duration: Duration(seconds: 5),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('AI Travel Assistant'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Question:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(question),
                SizedBox(height: 15),
                Text(
                  'AI Response:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFF4AB4DE).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(answer),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ask Another'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Sustainability Impact Notification
  void sendSustainabilityAlert(BuildContext context, {
    required String impact,
    required double carbonSaved,
    required String recommendation,
  }) {
    sendNotification(
      context: context,
      title: '🌱 Sustainable Travel',
      message: 'Your choice reduces environmental impact!',
      type: 'success',
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Sustainability Impact'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.eco, color: Colors.green),
                  title: Text('Impact'),
                  subtitle: Text(impact),
                ),
                ListTile(
                  leading: Icon(Icons.cloud, color: Color(0xFF4AB4DE)),
                  title: Text('Carbon Saved'),
                  subtitle: Text('${carbonSaved} kg CO2'),
                ),
                ListTile(
                  leading: Icon(Icons.thumb_up, color: Color(0xFF2F62A7)),
                  title: Text('Recommendation'),
                  subtitle: Text(recommendation),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Learn More'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Emergency Alert System
  void sendEmergencyAlert(BuildContext context, {
    required String type,
    required String location,
    required String instructions,
    required String severity,
  }) {
    Color alertColor;
    IconData alertIcon;

    switch (severity.toLowerCase()) {
      case 'high':
        alertColor = Colors.red;
        alertIcon = Icons.warning;
        break;
      case 'medium':
        alertColor = Colors.orange;
        alertIcon = Icons.error;
        break;
      case 'low':
        alertColor = Colors.yellow;
        alertIcon = Icons.info;
        break;
      default:
        alertColor = Colors.red;
        alertIcon = Icons.warning;
    }

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(alertIcon, color: Colors.white, size: 24),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🚨 $type Alert',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Near $location. Tap for details.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: alertColor,
      duration: Duration(seconds: 10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      action: SnackBarAction(
        label: 'VIEW',
        textColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(alertIcon, color: alertColor),
                  SizedBox(width: 10),
                  Text('Emergency Alert'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type: $type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Location: $location'),
                  SizedBox(height: 10),
                  Text('Severity: $severity'),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: alertColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: alertColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Instructions:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(instructions),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Call emergency services
                    Navigator.pop(context);
                    sendNotification(
                      context: context,
                      title: '📞 Emergency Services',
                      message: 'Emergency services have been notified',
                      type: 'success',
                    );
                  },
                  child: Text('Call Emergency'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Show safe routes
                    sendRouteUpdate(
                      context,
                      'Safe routes calculated avoiding $location',
                      0,
                    );
                  },
                  child: Text('Show Safe Route'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Acknowledge'),
                ),
              ],
            ),
          );
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Batch Notification System for Multiple Updates
  void sendBatchUpdate(BuildContext context, List<Map<String, dynamic>> updates) {
    if (updates.isEmpty) return;

    String summary = '';
    int crowdUpdates = 0;
    int weatherUpdates = 0;
    int routeUpdates = 0;

    for (var update in updates) {
      switch (update['type']) {
        case 'crowd':
          crowdUpdates++;
          break;
        case 'weather':
          weatherUpdates++;
          break;
        case 'route':
          routeUpdates++;
          break;
      }
    }

    if (crowdUpdates > 0) summary += '$crowdUpdates crowd updates. ';
    if (weatherUpdates > 0) summary += '$weatherUpdates weather updates. ';
    if (routeUpdates > 0) summary += '$routeUpdates route updates. ';

    sendNotification(
      context: context,
      title: '📊 Multiple Updates',
      message: summary,
      type: 'info',
      duration: Duration(seconds: 6),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Recent Updates Summary'),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: updates.length,
                itemBuilder: (context, index) {
                  final update = updates[index];
                  return ListTile(
                    leading: Icon(_getUpdateIcon(update['type'])),
                    title: Text(update['title']),
                    subtitle: Text(update['message']),
                    trailing: Text(
                      DateFormat('HH:mm').format(update['timestamp']),
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Clear All'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getUpdateIcon(String type) {
    switch (type) {
      case 'crowd':
        return Icons.people;
      case 'weather':
        return Icons.cloud;
      case 'route':
        return Icons.directions;
      default:
        return Icons.info;
    }
  }

  // Notification Preferences Check
  void checkNotificationPreferences(BuildContext context) {
    // Simulated preference check
    sendNotification(
      context: context,
      title: '🔔 Notification Settings',
      message: 'Customize your notification preferences',
      type: 'info',
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Notification Preferences'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: Text('Crowd Alerts'),
                  subtitle: Text('Get notified about crowd changes'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  title: Text('Weather Updates'),
                  subtitle: Text('Receive weather alerts'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  title: Text('Route Updates'),
                  subtitle: Text('Get real-time route changes'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  title: Text('Reminders'),
                  subtitle: Text('Activity reminders'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  title: Text('AI Suggestions'),
                  subtitle: Text('Smart alternative suggestions'),
                  value: true,
                  onChanged: (value) {},
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Save'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }
}