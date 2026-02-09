import 'package:flutter/material.dart';
import 'package:yathran/screens/group_preference_screen.dart';
import 'package:yathran/models/trip_model.dart';

class MoodSelectionScreen extends StatefulWidget {
  final Trip trip;

  MoodSelectionScreen({required this.trip});

  @override
  _MoodSelectionScreenState createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> {
  List<MoodOption> _moods = [
    MoodOption('Romantic', '❤️', false),
    MoodOption('Playful', '🎢', false),
    MoodOption('Devotional', '🛕', false),
    MoodOption('Nature', '🌿', false),
    MoodOption('Adventure', '🏔', false),
    MoodOption('Food Exploration', '🍜', false),
    MoodOption('Family Bonding', '👨‍👩‍👧', false),
    MoodOption('Photography', '📸', false),
    MoodOption('Shopping', '🛍', false),
  ];

  void _proceedToGroupPreferences() {
    final selectedMoods = _moods.where((mood) => mood.selected).toList();
    if (selectedMoods.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one mood')),
      );
      return;
    }

    widget.trip.selectedMoods =
        selectedMoods.map((mood) => mood.name).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupPreferenceScreen(trip: widget.trip),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Travel Mood'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How do you want to feel on this trip?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F62A7),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Select one or more travel emotions to personalize your experience',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 30),

            // Mood Grid
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemCount: _moods.length,
              itemBuilder: (context, index) {
                final mood = _moods[index];
                return GestureDetector(
                  onTap: () {
                    setState(() => mood.selected = !mood.selected);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: mood.selected
                          ? Color(0xFF4AB4DE)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: mood.selected
                            ? Color(0xFF2F62A7)
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          mood.emoji,
                          style: TextStyle(fontSize: 32),
                        ),
                        SizedBox(height: 10),
                        Text(
                          mood.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: mood.selected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 40),

            // Next Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _proceedToGroupPreferences,
                child: Text(
                  'Continue to Group Preferences',
                  style: TextStyle(fontSize: 18),
                ),
                // Line 138 - Update this:
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
}

class MoodOption {
  String name;
  String emoji;
  bool selected;

  MoodOption(this.name, this.emoji, this.selected);
}