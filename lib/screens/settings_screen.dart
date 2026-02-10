import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yathran/services/auth_service.dart';
import 'package:yathran/services/notification_service.dart';


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _enableNotifications = true;
  bool _enableCrowdAlerts = true;
  bool _enableWeatherAlerts = true;
  bool _enableRouteUpdates = true;
  bool _enableAISuggestions = true;
  bool _darkMode = false;
  String _temperatureUnit = 'Celsius';
  String _distanceUnit = 'Kilometers';
  String _currency = 'USD';
  String _language = 'English';

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout Confirmation'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.logout();
    Navigator.pushReplacementNamed(context, '/auth');
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About YĀTHRAN'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Version 1.0.0',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'YĀTHRAN is an AI-powered personalized tourism planner that creates smart travel itineraries by balancing user interests, travel mood, budget, crowd prediction, and route optimization.',
              ),
              SizedBox(height: 15),
              Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text('• Mood-based trip planning'),
              Text('• Real-time crowd predictions'),
              Text('• AI-powered recommendations'),
              Text('• Route optimization'),
              Text('• Budget management'),
              Text('• Sustainable travel insights'),
              SizedBox(height: 15),
              Text(
                '© 2024 YĀTHRAN. All rights reserved.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      backgroundColor: Color(0xFFEEDBCC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            backgroundColor: Color(0xFF2F62A7),
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Settings'),
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
                      Icon(Icons.settings, size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        'Customize your experience',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // User Profile Section
              Card(
                margin: EdgeInsets.all(16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFF2F62A7),
                        child: Text(
                          user?.name.substring(0, 1).toUpperCase() ?? 'G',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        user?.name ?? 'Guest User',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F62A7),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        user?.email ?? 'guest@example.com',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 15),
                      if (user?.id.startsWith('guest') == false)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // Edit profile
                              },
                              icon: Icon(Icons.edit, size: 16),
                              label: Text('Edit Profile'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4AB4DE),
                              ),
                            ),
                            SizedBox(width: 10),
                            OutlinedButton.icon(
                              onPressed: _showLogoutDialog,
                              icon: Icon(Icons.logout, size: 16),
                              label: Text('Logout'),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              // Notification Settings
              _buildSettingsSection(
                title: 'Notifications',
                icon: Icons.notifications,
                children: [
                  SwitchListTile(
                    title: Text('Enable Notifications'),
                    subtitle: Text('Receive all travel updates'),
                    value: _enableNotifications,
                    onChanged: (value) {
                      setState(() => _enableNotifications = value);
                      if (!value) {
                        NotificationService().sendNotification(
                          context: context,
                          title: 'Notifications Disabled',
                          message: 'You will not receive travel updates',
                          type: 'warning',
                        );
                      }
                    },
                  ),
                  SwitchListTile(
                    title: Text('Crowd Alerts'),
                    subtitle: Text('Get notified about crowd changes'),
                    value: _enableCrowdAlerts,
                    onChanged: _enableNotifications
                        ? (value) => setState(() => _enableCrowdAlerts = value)
                        : null,
                  ),
                  SwitchListTile(
                    title: Text('Weather Alerts'),
                    subtitle: Text('Receive weather updates'),
                    value: _enableWeatherAlerts,
                    onChanged: _enableNotifications
                        ? (value) => setState(() => _enableWeatherAlerts = value)
                        : null,
                  ),
                  SwitchListTile(
                    title: Text('Route Updates'),
                    subtitle: Text('Get real-time route changes'),
                    value: _enableRouteUpdates,
                    onChanged: _enableNotifications
                        ? (value) => setState(() => _enableRouteUpdates = value)
                        : null,
                  ),
                  SwitchListTile(
                    title: Text('AI Suggestions'),
                    subtitle: Text('Smart alternative recommendations'),
                    value: _enableAISuggestions,
                    onChanged: _enableNotifications
                        ? (value) => setState(() => _enableAISuggestions = value)
                        : null,
                  ),
                ],
              ),

              // Appearance Settings
              _buildSettingsSection(
                title: 'Appearance',
                icon: Icons.palette,
                children: [
                  SwitchListTile(
                    title: Text('Dark Mode'),
                    subtitle: Text('Switch to dark theme'),
                    value: _darkMode,
                    onChanged: (value) {
                      setState(() => _darkMode = value);
                      NotificationService().sendNotification(
                        context: context,
                        title: 'Theme Changed',
                        message: value ? 'Dark mode enabled' : 'Light mode enabled',
                        type: 'info',
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.thermostat, color: Color(0xFF4AB4DE)),
                    title: Text('Temperature Unit'),
                    subtitle: Text(_temperatureUnit),
                    trailing: DropdownButton<String>(
                      value: _temperatureUnit,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _temperatureUnit = value);
                        }
                      },
                      items: ['Celsius', 'Fahrenheit']
                          .map((unit) => DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      ))
                          .toList(),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.straighten, color: Color(0xFF4AB4DE)),
                    title: Text('Distance Unit'),
                    subtitle: Text(_distanceUnit),
                    trailing: DropdownButton<String>(
                      value: _distanceUnit,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _distanceUnit = value);
                        }
                      },
                      items: ['Kilometers', 'Miles']
                          .map((unit) => DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      ))
                          .toList(),
                    ),
                  ),
                ],
              ),

              // Regional Settings
              _buildSettingsSection(
                title: 'Regional',
                icon: Icons.language,
                children: [
                  ListTile(
                    leading: Icon(Icons.currency_exchange, color: Color(0xFF4AB4DE)),
                    title: Text('Currency'),
                    subtitle: Text(_currency),
                    trailing: DropdownButton<String>(
                      value: _currency,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _currency = value);
                        }
                      },
                      items: ['USD', 'EUR', 'GBP', 'JPY', 'INR']
                          .map((currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      ))
                          .toList(),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.translate, color: Color(0xFF4AB4DE)),
                    title: Text('Language'),
                    subtitle: Text(_language),
                    trailing: DropdownButton<String>(
                      value: _language,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _language = value);
                        }
                      },
                      items: ['English', 'Spanish', 'French', 'German', 'Japanese']
                          .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      ))
                          .toList(),
                    ),
                  ),
                ],
              ),

              // Privacy & Security
              _buildSettingsSection(
                title: 'Privacy & Security',
                icon: Icons.security,
                children: [
                  ListTile(
                    leading: Icon(Icons.privacy_tip, color: Color(0xFF4AB4DE)),
                    title: Text('Privacy Policy'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      // Show privacy policy
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.description, color: Color(0xFF4AB4DE)),
                    title: Text('Terms of Service'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      // Show terms
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text(
                      'Delete Account',
                      style: TextStyle(color: Colors.red),
                    ),
                    trailing: Icon(Icons.chevron_right, color: Colors.red),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete Account'),
                          content: Text(
                            'This action cannot be undone. All your data will be permanently deleted.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                NotificationService().sendNotification(
                                  context: context,
                                  title: 'Account Deleted',
                                  message: 'Your account has been deleted',
                                  type: 'error',
                                );
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),

              // About & Support
              _buildSettingsSection(
                title: 'About & Support',
                icon: Icons.help,
                children: [
                  ListTile(
                    leading: Icon(Icons.info, color: Color(0xFF4AB4DE)),
                    title: Text('About YĀTHRAN'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: _showAboutDialog,
                  ),
                  ListTile(
                    leading: Icon(Icons.contact_support, color: Color(0xFF4AB4DE)),
                    title: Text('Contact Support'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      // Contact support
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.bug_report, color: Color(0xFF4AB4DE)),
                    title: Text('Report a Bug'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      // Report bug
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.star, color: Color(0xFF4AB4DE)),
                    title: Text('Rate the App'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      // Rate app
                    },
                  ),
                ],
              ),

              // Data Management
              _buildSettingsSection(
                title: 'Data',
                icon: Icons.storage,
                children: [
                  ListTile(
                    leading: Icon(Icons.download, color: Color(0xFF4AB4DE)),
                    title: Text('Export My Data'),
                    subtitle: Text('Download all your trip data'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      NotificationService().sendNotification(
                        context: context,
                        title: 'Data Export',
                        message: 'Your data export has started',
                        type: 'success',
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete_sweep, color: Color(0xFF4AB4DE)),
                    title: Text('Clear Cache'),
                    subtitle: Text('Free up storage space'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Clear Cache'),
                          content: Text('This will remove temporary files and free up storage.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                NotificationService().sendNotification(
                                  context: context,
                                  title: 'Cache Cleared',
                                  message: 'Storage space has been freed',
                                  type: 'success',
                                );
                              },
                              child: Text('Clear'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),

              // Version Info
              Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'YĀTHRAN v1.0.0\n© 2024 All rights reserved',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Color(0xFF2F62A7)),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F62A7),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            ...children,
          ],
        ),
      ),
    );
  }
}