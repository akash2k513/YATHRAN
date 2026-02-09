import 'package:flutter/material.dart';
import 'package:yathran/models/trip_model.dart';
import 'package:yathran/models/itinerary_model.dart';

class ItineraryScreen extends StatefulWidget {
  final Trip trip;

  ItineraryScreen({required this.trip});

  @override
  _ItineraryScreenState createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  Itinerary? itinerary;
  bool isLoading = true;
  bool showAlternatives = false;

  @override
  void initState() {
    super.initState();
    _generateItinerary();
  }

  Future<void> _generateItinerary() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      itinerary = Itinerary(
        days: [
          DayPlan(
            day: 1,
            date: widget.trip.startDate,
            activities: [
              Activity(
                time: '09:00 AM',
                name: 'Eiffel Tower Visit',
                description: 'Skip-the-line tickets included',
                location: 'Champ de Mars, Paris',
                crowdLevel: 'High',
                budget: 25.0,
                travelTime: 30,
              ),
              Activity(
                time: '01:00 PM',
                name: 'Lunch at Local Bistro',
                description: 'Traditional French cuisine',
                location: 'Le Marais, Paris',
                crowdLevel: 'Medium',
                budget: 40.0,
                travelTime: 20,
              ),
              Activity(
                time: '03:00 PM',
                name: 'Louvre Museum',
                description: 'Art and history exploration',
                location: 'Rue de Rivoli, Paris',
                crowdLevel: 'Low',
                budget: 15.0,
                travelTime: 15,
              ),
            ],
          ),
          DayPlan(
            day: 2,
            date: widget.trip.startDate.add(Duration(days: 1)),
            activities: [
              Activity(
                time: '10:00 AM',
                name: 'Seine River Cruise',
                description: 'Scenic boat tour',
                location: 'Seine River, Paris',
                crowdLevel: 'Medium',
                budget: 35.0,
                travelTime: 25,
              ),
              Activity(
                time: '02:00 PM',
                name: 'Montmartre Exploration',
                description: 'Artists square and Sacré-Cœur',
                location: 'Montmartre, Paris',
                crowdLevel: 'Low',
                budget: 20.0,
                travelTime: 30,
              ),
            ],
          ),
        ],
        totalCost: 135.0,
        totalTravelTime: 120,
      );
      isLoading = false;
    });
  }

  Color _getCrowdColor(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your AI Itinerary'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: isLoading
                ? null
                : () {
              setState(() {
                isLoading = true;
                showAlternatives = !showAlternatives;
              });
              _generateItinerary();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Card(
              color: Color(0xFFEEDBCC),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.trip.destination,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F62A7),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFF4AB4DE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.trip.tripType,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Cost',
                                style: TextStyle(color: Colors.grey)),
                            Text('\$${itinerary!.totalCost}',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Travel Time',
                                style: TextStyle(color: Colors.grey)),
                            Text('${itinerary!.totalTravelTime} minutes',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Days', style: TextStyle(color: Colors.grey)),
                            Text('${itinerary!.days.length}',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Mood Tags
            Wrap(
              spacing: 10,
              children: widget.trip.selectedMoods.map((mood) {
                return Chip(
                  label: Text(mood),
                  backgroundColor: Color(0xFF4AB4DE).withOpacity(0.2),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Itinerary Days
            ...itinerary!.days.map((day) {
              return Card(
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xFF2F62A7),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                'Day ${day.day}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${day.date.day}/${day.date.month}/${day.date.year}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      ...day.activities.map((activity) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    activity.time,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3B8AC3),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color:
                                      _getCrowdColor(activity.crowdLevel),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      activity.crowdLevel,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                activity.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(activity.description,
                                  style: TextStyle(color: Colors.grey)),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(activity.location,
                                        style: TextStyle(fontSize: 14)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.attach_money,
                                          size: 16, color: Colors.green),
                                      SizedBox(width: 4),
                                      Text('\$${activity.budget}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.directions_walk,
                                          size: 16, color: Colors.blue),
                                      SizedBox(width: 4),
                                      Text('${activity.travelTime} min'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            }).toList(),

            // Alternative Suggestions
            if (showAlternatives)
              Card(
                color: Color(0xFFEEDBCC),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: Colors.amber),
                          SizedBox(width: 10),
                          Text(
                            'Alternative Suggestions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        '• Consider visiting Versailles Palace instead of Louvre (Less crowded on weekdays)',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '• Try local food markets instead of restaurants for authentic experience',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '• Evening Seine cruise has better views and fewer crowds',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Itinerary saved!')),
                      );
                    },
                    icon: Icon(Icons.save),
                    label: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2F62A7),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Share itinerary
                    },
                    icon: Icon(Icons.share),
                    label: Text('Share'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4AB4DE),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.map),
                onPressed: () {},
                tooltip: 'Navigation',
              ),
              IconButton(
                icon: Icon(Icons.cloud),
                onPressed: () {},
                tooltip: 'Weather',
              ),
              IconButton(
                icon: Icon(Icons.chat),
                onPressed: () {},
                tooltip: 'AI Companion',
              ),
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {},
                tooltip: 'Alerts',
              ),
            ],
          ),
        ),
      ),
    );
  }
}