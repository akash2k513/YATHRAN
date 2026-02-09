import 'package:flutter/material.dart';

class CrowdInsightsScreen extends StatefulWidget {
  @override
  _CrowdInsightsScreenState createState() => _CrowdInsightsScreenState();
}

class _CrowdInsightsScreenState extends State<CrowdInsightsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<Map<String, dynamic>> crowdInsights = [
    {
      'location': 'Eiffel Tower, Paris',
      'currentCrowd': 'High',
      'predictedCrowd': 'High',
      'bestTime': '8:00 AM - 10:00 AM',
      'alternative': 'Arc de Triomphe',
      'weather': 'Sunny',
      'trend': 'Increasing',
    },
    {
      'location': 'Louvre Museum, Paris',
      'currentCrowd': 'Medium',
      'predictedCrowd': 'High',
      'bestTime': '3:00 PM - 5:00 PM',
      'alternative': 'Musée d\'Orsay',
      'weather': 'Sunny',
      'trend': 'Stable',
    },
    {
      'location': 'Times Square, NYC',
      'currentCrowd': 'High',
      'predictedCrowd': 'Very High',
      'bestTime': 'Early Morning',
      'alternative': 'Bryant Park',
      'weather': 'Cloudy',
      'trend': 'Increasing',
    },
    {
      'location': 'Grand Canyon',
      'currentCrowd': 'Low',
      'predictedCrowd': 'Low',
      'bestTime': 'Anytime',
      'alternative': 'None',
      'weather': 'Clear',
      'trend': 'Stable',
    },
    {
      'location': 'Tokyo Disneyland',
      'currentCrowd': 'High',
      'predictedCrowd': 'Very High',
      'bestTime': 'Weekdays',
      'alternative': 'Tokyo DisneySea',
      'weather': 'Rainy',
      'trend': 'Increasing',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getCrowdColor(String crowdLevel) {
    switch (crowdLevel.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      case 'very high':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEDBCC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: Color(0xFF2F62A7),
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Crowd Insights'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2F62A7),
                      Color(0xFF3B8AC3),
                      Color(0xFF4AB4DE),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.insights, size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        'Real-time crowd predictions',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final insight = crowdInsights[index];
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildInsightCard(insight),
                  );
                },
                childCount: crowdInsights.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(Map<String, dynamic> insight) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
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
                    insight['location'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F62A7),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getCrowdColor(insight['currentCrowd']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getCrowdColor(insight['currentCrowd']),
                    ),
                  ),
                  child: Text(
                    insight['currentCrowd'],
                    style: TextStyle(
                      color: _getCrowdColor(insight['currentCrowd']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),

            // Crowd Prediction Row
            Row(
              children: [
                Icon(Icons.timeline, color: Color(0xFF4AB4DE)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Predicted: ${insight['predictedCrowd']}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Icon(Icons.trending_up, color: insight['trend'] == 'Increasing' ? Colors.red : Colors.green),
                SizedBox(width: 5),
                Text(insight['trend']),
              ],
            ),
            SizedBox(height: 10),

            // Best Time Row
            Row(
              children: [
                Icon(Icons.access_time, color: Color(0xFF4AB4DE)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Best Time: ${insight['bestTime']}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Alternative Suggestion
            Row(
              children: [
                Icon(Icons.alt_route, color: Color(0xFF4AB4DE)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Alternative: ${insight['alternative']}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Weather Info
            Row(
              children: [
                Icon(Icons.cloud, color: Color(0xFF4AB4DE)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Weather: ${insight['weather']}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFF4AB4DE)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'View Details',
                      style: TextStyle(color: Color(0xFF4AB4DE)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2F62A7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Plan Visit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}