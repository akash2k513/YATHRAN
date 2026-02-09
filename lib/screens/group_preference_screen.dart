import 'package:flutter/material.dart';
import 'package:yathran/screens/itinerary_screen.dart';
import 'package:yathran/models/trip_model.dart';

class GroupPreferenceScreen extends StatefulWidget {
  final Trip trip;

  GroupPreferenceScreen({required this.trip});

  @override
  _GroupPreferenceScreenState createState() => _GroupPreferenceScreenState();
}

class _GroupPreferenceScreenState extends State<GroupPreferenceScreen> {
  List<Traveler> travelers = [Traveler(name: 'You', isCurrentUser: true)];
  int travelerCount = 1;
  final List<String> interests = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Preferences'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Group Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F62A7),
              ),
            ),
            SizedBox(height: 20),

            // Traveler Count
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Number of Travelers',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        color: Color(0xFF4AB4DE),
                        onPressed: () {
                          if (travelerCount > 1) {
                            setState(() {
                              travelerCount--;
                              travelers = travelers.take(travelerCount).toList();
                            });
                          }
                        },
                      ),
                      Text(
                        '$travelerCount',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle),
                        color: Color(0xFF4AB4DE),
                        onPressed: () {
                          setState(() {
                            travelerCount++;
                            if (travelers.length < travelerCount) {
                              travelers.add(Traveler(name: 'Traveler ${travelers.length + 1}'));
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Traveler Preferences
            Text(
              'Traveler Preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...travelers.asMap().entries.map((entry) {
              final index = entry.key;
              final traveler = entry.value;
              return _buildTravelerCard(traveler, index);
            }).toList(),
            SizedBox(height: 40),

            // Generate Itinerary Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  widget.trip.travelers = travelers.cast<Traveler>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItineraryScreen(trip: widget.trip),
                    ),
                  );
                },
                child: Text(
                  'Generate AI Itinerary',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2F62A7),
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

  Widget _buildTravelerCard(Traveler traveler, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Color(0xFF3B8AC3)),
                SizedBox(width: 10),
                Text(
                  traveler.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text('Select Interests:'),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: interests.map((interest) {
                final isSelected = traveler.selectedInterests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        traveler.selectedInterests.add(interest);
                      } else {
                        traveler.selectedInterests.remove(interest);
                      }
                    });
                  },
                  selectedColor: Color(0xFF4AB4DE),
                  backgroundColor: Colors.grey[200],
                );
              }).toList(),
            ),
            SizedBox(height: 15),
            Text('Physical Activity Level:'),
            SizedBox(height: 10),
            Row(
              children: ['Low', 'Medium', 'High'].map((level) {
                return Expanded(
                  child: RadioListTile(
                    title: Text(level),
                    value: level,
                    groupValue: traveler.activityLevel,
                    onChanged: (value) {
                      setState(() => traveler.activityLevel = value.toString());
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}