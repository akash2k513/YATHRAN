import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yathran/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          if (!user!.id.startsWith('guest'))
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await authService.logout();
                Navigator.pushReplacementNamed(context, '/auth');
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF2F62A7),
              ),
              child: Center(
                child: Text(
                  user.name.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              user.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              user.email,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),

            // Account Info Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F62A7),
                      ),
                    ),
                    SizedBox(height: 15),
                    _buildInfoRow('Account Type', user.id.startsWith('guest') ? 'Guest' : 'Registered'),
                    _buildInfoRow('Member Since', user.createdAt.year.toString()),
                    _buildInfoRow('Total Trips', '0'),
                    _buildInfoRow('Favorite Destination', 'Not set'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Preferences Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Travel Preferences',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F62A7),
                      ),
                    ),
                    SizedBox(height: 15),
                    if (user.travelInterests.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Interests:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            spacing: 8,
                            children: user.travelInterests
                                .map((interest) => Chip(label: Text(interest)))
                                .toList(),
                          ),
                        ],
                      ),
                    SizedBox(height: 15),
                    _buildInfoRow('Average Budget', '\$${user.averageBudget}'),
                    _buildInfoRow('Preferred Trip Types', user.preferredTripTypes.join(', ')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}