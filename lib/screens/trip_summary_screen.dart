import 'package:flutter/material.dart';
import 'package:yathran/models/trip_model.dart';
import 'package:yathran/services/notification_service.dart';

class TripSummaryScreen extends StatefulWidget {
  final Trip trip;

  TripSummaryScreen({required this.trip});

  @override
  _TripSummaryScreenState createState() => _TripSummaryScreenState();
}

class _TripSummaryScreenState extends State<TripSummaryScreen> {
  double _destinationRating = 3.0;
  double _crowdAccuracyRating = 3.0;
  double _experienceRating = 3.0;
  final TextEditingController _feedbackController = TextEditingController();

  void _submitFeedback() {
    if (_feedbackController.text.isEmpty) {
      NotificationService().sendNotification(
        context: context,
        title: 'Feedback Required',
        message: 'Please provide your feedback',
        type: 'warning',
      );
      return;
    }

    // Save feedback (in real app, send to backend)
    NotificationService().sendNotification(
      context: context,
      title: 'Thank You!',
      message: 'Your feedback has been submitted',
      type: 'success',
    );

    Navigator.popUntil(context, ModalRoute.withName('/home'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Summary'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Overview
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trip Completed!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F62A7),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.trip.destination,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                        SizedBox(width: 5),
                        Text('${widget.trip.startDate.day}/${widget.trip.startDate.month} - '
                            '${widget.trip.endDate.day}/${widget.trip.endDate.month}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // Ratings
            Text(
              'Rate Your Experience',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F62A7),
              ),
            ),
            SizedBox(height: 20),

            // Destination Rating
            _buildRatingSection(
              title: 'Destination Experience',
              value: _destinationRating,
              onChanged: (value) => setState(() => _destinationRating = value),
            ),
            SizedBox(height: 20),

            // Crowd Accuracy
            _buildRatingSection(
              title: 'Crowd Prediction Accuracy',
              value: _crowdAccuracyRating,
              onChanged: (value) => setState(() => _crowdAccuracyRating = value),
            ),
            SizedBox(height: 20),

            // Overall Experience
            _buildRatingSection(
              title: 'Overall Experience',
              value: _experienceRating,
              onChanged: (value) => setState(() => _experienceRating = value),
            ),
            SizedBox(height: 30),

            // Feedback
            Text(
              'Your Feedback',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tell us about your experience...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),

            // What went well?
            Text(
              'What did you enjoy most?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                'Crowd predictions',
                'Route optimization',
                'Activity suggestions',
                'Budget management',
                'Weather updates',
              ].map((item) {
                return FilterChip(
                  label: Text(item),
                  onSelected: (selected) {},
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Suggestions for improvement
            Text(
              'What can we improve?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                'More activity options',
                'Better crowd data',
                'Real-time updates',
                'More budget options',
                'Transportation info',
              ].map((item) {
                return FilterChip(
                  label: Text(item),
                  onSelected: (selected) {},
                );
              }).toList(),
            ),
            SizedBox(height: 40),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitFeedback,
                child: Text(
                  'Submit Feedback & Improve AI',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2F62A7), // Changed from primary
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection({
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('1', style: TextStyle(color: Colors.grey)),
            Expanded(
              child: Slider(
                value: value,
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: onChanged,
                activeColor: Color(0xFF4AB4DE),
              ),
            ),
            Text('5', style: TextStyle(color: Colors.grey)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Poor', style: TextStyle(color: Colors.grey)),
            Text('Average', style: TextStyle(color: Colors.grey)),
            Text('Excellent', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}