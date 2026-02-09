import 'package:flutter/material.dart';
import 'package:yathran/screens/trip_creation_screen.dart';
import 'package:yathran/models/trip_model.dart';
import 'package:provider/provider.dart';
import 'package:yathran/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Trip> savedTrips = [];
  List<String> suggestions = [
    'Bali, Indonesia - Perfect for Adventure',
    'Kyoto, Japan - Best for Cultural Experience',
    'Swiss Alps - Ideal for Nature Lovers',
  ];

  void _logout() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.logout();
    Navigator.pushReplacementNamed(context, '/auth');
  }

  void _showProfile() {
    final authService = Provider.of<AuthService>(context, listen: false);

    // Check if currentUser exists before accessing its properties
    final isGuest = authService.currentUser?.id.startsWith('guest') ?? true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${authService.currentUser?.name ?? 'Guest'}'),
            SizedBox(height: 10),
            Text('Email: ${authService.currentUser?.email ?? 'guest@example.com'}'),
            SizedBox(height: 10),
            Text('Account Type: ${isGuest ? 'Guest' : 'Registered'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          if (!isGuest)
            TextButton(
              onPressed: _logout,
              child: Text('Logout', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('YĀTHRAN'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No new notifications')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: _showProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF3B8AC3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${authService.currentUser?.name ?? 'Traveler'}!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ready for your next adventure?',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Start New Trip Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TripCreationScreen()),
                  );
                },
                icon: Icon(Icons.add_circle_outline),
                label: Text(
                  'Start New Trip',
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
            SizedBox(height: 30),

            // Saved Trips
            Text(
              'Saved Trips',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F62A7),
              ),
            ),
            SizedBox(height: 10),
            savedTrips.isEmpty
                ? Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.travel_explore, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'No trips saved yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Start planning your first trip!',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: savedTrips.length,
              itemBuilder: (context, index) {
                final trip = savedTrips[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    leading: Icon(Icons.location_on, color: Color(0xFF4AB4DE)),
                    title: Text(trip.destination),
                    subtitle: Text('${trip.startDate.day}/${trip.startDate.month}/${trip.startDate.year}'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                );
              },
            ),
            SizedBox(height: 30),

            // AI Suggestions
            Text(
              'AI Travel Suggestions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F62A7),
              ),
            ),
            SizedBox(height: 10),
            ...suggestions.map((suggestion) => Card(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                leading: Icon(Icons.lightbulb_outline, color: Colors.amber),
                title: Text(suggestion),
                subtitle: Text('Based on your interests'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Show suggestion details
                },
              ),
            )),
            SizedBox(height: 30),

            // Crowd Insights
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFFEEDBCC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFF4AB4DE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.people, color: Color(0xFF2F62A7)),
                      SizedBox(width: 10),
                      Text(
                        'Crowd Insights',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F62A7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Current low-crowd destinations:',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '• Bali beaches (morning)',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Text(
                    '• Kyoto temples (weekdays)',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Text(
                    '• Swiss Alps trails (early)',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Color(0xFF2F62A7)),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person_outline, color: Colors.grey),
              onPressed: _showProfile,
            ),
          ],
        ),
      ),
    );
  }
}