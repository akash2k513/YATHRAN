import 'package:flutter/material.dart';
import 'package:yathran/services/notification_service.dart';
import 'package:intl/intl.dart'; // Add this import for DateFormat

class AICompanionScreen extends StatefulWidget {
  @override
  _AICompanionScreenState createState() => _AICompanionScreenState();
}

class _AICompanionScreenState extends State<AICompanionScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  late AnimationController _animationController;
  bool _isTyping = false;

  // Predefined questions for quick access
  final List<String> quickQuestions = [
    'Suggest places nearby',
    'Modify my itinerary',
    'Weather forecast',
    'Best time to visit',
    'Budget-friendly options',
    'Crowd predictions',
    'Local transportation',
    'Food recommendations',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.forward();

    // Add welcome message
    _addMessage(
      'Hello! I\'m your AI Travel Assistant. How can I help you plan your perfect trip today?',
      false,
    );
  }

  void _addMessage(String text, bool isUser) {
    setState(() {
      _messages.add({
        'text': text,
        'isUser': isUser,
        'time': DateTime.now(),
      });
    });

    // Auto-reply for user messages
    if (isUser) {
      _generateAIResponse(text);
    }
  }

  Future<void> _generateAIResponse(String userMessage) async {
    setState(() => _isTyping = true);

    await Future.delayed(Duration(seconds: 1));

    String response = _getAIResponse(userMessage);

    setState(() => _isTyping = false);
    _addMessage(response, false);

    // Send notification for important responses
    if (response.contains('crowded') || response.contains('alert')) {
      NotificationService().sendCrowdAlert(
        context,
        'Current Location',
        'High',
        'Nearby alternatives',
      );
    }
  }

  String _getAIResponse(String userMessage) {
    userMessage = userMessage.toLowerCase();

    if (userMessage.contains('nearby') || userMessage.contains('place')) {
      return 'Based on your location, I recommend:\n1. **Local Museum** (5 mins away, Low crowd)\n2. **Historic Square** (10 mins, Medium crowd)\n3. **Art Gallery** (15 mins, Low crowd)\n\nWould you like me to add any to your itinerary?';
    } else if (userMessage.contains('modify') || userMessage.contains('itinerary')) {
      return 'I can help you modify your itinerary. Please specify:\n1. Which day to modify\n2. Preferences (remove, add, reschedule)\n3. Any specific requirements\n\nOr I can suggest optimizations based on current conditions.';
    } else if (userMessage.contains('weather') || userMessage.contains('forecast')) {
      return '🌤️ Weather forecast for your location:\n• Today: Sunny, 25°C\n• Tomorrow: Partly Cloudy, 23°C\n• Day after: Light Rain, 20°C\n\nPerfect weather for outdoor activities! Pack light layers.';
    } else if (userMessage.contains('crowd') || userMessage.contains('busy')) {
      return 'Current crowd predictions:\n• **Eiffel Tower**: High (Avoid 11 AM - 3 PM)\n• **Louvre**: Medium (Best: 3 PM - 5 PM)\n• **Local Park**: Low (Anytime)\n\nI can suggest less crowded alternatives if needed!';
    } else if (userMessage.contains('budget') || userMessage.contains('cheap')) {
      return '💰 Budget-friendly suggestions:\n1. **Free walking tour** (Daily at 10 AM)\n2. **Local markets** (Great for affordable food)\n3. **Public parks** (Free entry)\n4. **Museum free days** (Check local schedule)\n\nTotal estimated savings: \$50-100 per day';
    } else if (userMessage.contains('food') || userMessage.contains('restaurant')) {
      return '🍽️ Food recommendations:\n• **Local Bistro** (Traditional cuisine, \$\$)\n• **Street Food Market** (Authentic, \$)\n• **Fine Dining** (Michelin-starred, \$\$\$)\n• **Vegetarian Options** (Multiple choices)\n\nWould you like specific dietary recommendations?';
    } else if (userMessage.contains('transport') || userMessage.contains('travel')) {
      return '🚆 Transportation options:\n1. **Metro** (Fastest, \$2 per ride)\n2. **Buses** (Scenic, \$1.5 per ride)\n3. **Taxis** (Convenient, \$15-30)\n4. **Walking** (Free, best for short distances)\n\nI can calculate optimal routes for you!';
    } else {
      return 'I understand you\'re asking about "$userMessage". As your AI travel assistant, I can help with:\n• Personalized recommendations\n• Real-time crowd predictions\n• Weather updates\n• Budget optimization\n• Route planning\n\nWhat specific aspect would you like me to assist with?';
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    String message = _messageController.text;
    _messageController.clear();
    _addMessage(message, true);
  }

  void _selectQuickQuestion(String question) {
    _messageController.text = question;
    _sendMessage();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEDBCC),
      body: Column(
        children: [
          // App Bar
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2F62A7),
                  Color(0xFF3B8AC3),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: Color(0xFF4AB4DE),
                      child: Icon(Icons.smart_toy, color: Colors.white),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Travel Assistant',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Online • Always here to help',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {
                        NotificationService().checkNotificationPreferences(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              reverse: false,
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _messages.length) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                } else {
                  return _buildTypingIndicator();
                }
              },
            ),
          ),

          // Quick Questions
          Container(
            height: 80,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: Colors.white.withOpacity(0.8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: quickQuestions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(
                      quickQuestions[index],
                      style: TextStyle(fontSize: 12),
                    ),
                    selected: false,
                    onSelected: (_) => _selectQuickQuestion(quickQuestions[index]),
                    backgroundColor: Colors.white,
                    selectedColor: Color(0xFF4AB4DE),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                );
              },
            ),
          ),

          // Input Area
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything about your trip...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Color(0xFF4AB4DE)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Color(0xFF4AB4DE), width: 2),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.attach_file, color: Color(0xFF4AB4DE)),
                        onPressed: () {
                          // Attach files/images
                        },
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF2F62A7),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isUser = message['isUser'];

    return FadeTransition(
      opacity: _animationController,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser)
              CircleAvatar(
                backgroundColor: Color(0xFF4AB4DE),
                child: Icon(Icons.smart_toy, color: Colors.white, size: 18),
              ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Color(0xFF2F62A7) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: isUser ? Radius.circular(15) : Radius.circular(0),
                        bottomRight: isUser ? Radius.circular(0) : Radius.circular(15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    DateFormat('HH:mm').format(message['time']),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isUser)
              SizedBox(width: 10),
            if (isUser)
              CircleAvatar(
                backgroundColor: Color(0xFF3B8AC3),
                child: Icon(Icons.person, color: Colors.white, size: 18),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFF4AB4DE),
            child: Icon(Icons.smart_toy, color: Colors.white, size: 18),
          ),
          SizedBox(width: 10),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                SizedBox(width: 4),
                _buildTypingDot(200),
                SizedBox(width: 4),
                _buildTypingDot(400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int delay) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Color(0xFF4AB4DE),
        shape: BoxShape.circle,
      ),
      curve: Curves.easeInOut,
    );
  }
}