import 'package:flutter/material.dart';
import 'package:yathran/services/notification_service.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Temporary dummy data - replace with actual favorites from your data source
    final List<Map<String, dynamic>> favoritePlaces = [
      {
        'name': 'Santorini, Greece',
        'image': 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=400&h=300&fit=crop',
        'crowdLevel': 'Medium',
        'priceRange': '2200 USD',
      },
      {
        'name': 'Kyoto, Japan',
        'image': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=400&h=300&fit=crop',
        'crowdLevel': 'High',
        'priceRange': '2400 USD',
      },
      {
        'name': 'Swiss Alps',
        'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop',
        'crowdLevel': 'Low',
        'priceRange': '3500 USD',
      },
    ];

    return Scaffold(
      backgroundColor: Color(0xFFEEDBCC),
      appBar: AppBar(
        title: Text('My Favorites'),
        backgroundColor: Color(0xFF2F62A7),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: favoritePlaces.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Color(0xFF4AB4DE).withOpacity(0.5),
            ),
            SizedBox(height: 20),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F62A7),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Tap the heart icon on any place\nto add it to your favorites',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )
          : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Saved Places',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F62A7),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${favoritePlaces.length} places saved',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: favoritePlaces.length,
                itemBuilder: (context, index) {
                  final place = favoritePlaces[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 15),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Navigate to place details
                        NotificationService().sendNotification(
                          context: context,
                          title: 'Place Details',
                          message: 'Details for ${place['name']}',
                          type: 'info',
                        );
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Row(
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                            child: Image.network(
                              place['image'],
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Details
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          place['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color(0xFF2F62A7),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.favorite, color: Colors.red),
                                        onPressed: () {
                                          // Remove from favorites
                                          NotificationService().sendNotification(
                                            context: context,
                                            title: 'Removed',
                                            message: '${place['name']} removed from favorites',
                                            type: 'warning',
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getCrowdColor(place['crowdLevel']).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.people, size: 12, color: _getCrowdColor(place['crowdLevel'])),
                                            SizedBox(width: 4),
                                            Text(
                                              place['crowdLevel'],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: _getCrowdColor(place['crowdLevel']),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.attach_money, size: 12, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text(
                                        place['priceRange'],
                                        style: TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Plan trip to this place
                                      NotificationService().sendNotification(
                                        context: context,
                                        title: 'Trip Planning',
                                        message: 'Start planning trip to ${place['name']}',
                                        type: 'success',
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF4AB4DE),
                                      minimumSize: Size(double.infinity, 40),
                                    ),
                                    child: Text('Plan Trip Here'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCrowdColor(String crowdLevel) {
    switch (crowdLevel.toLowerCase()) {
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
}