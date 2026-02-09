import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'YĀTHRAN',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF2F62A7), // Deep Ocean Blue
            primary: Color(0xFF2F62A7),
            secondary: Color(0xFF3B8AC3), // Ocean Blue
            tertiary: Color(0xFF4AB4DE), // Light Aqua Blue
            background: Color(0xFFEEDBCC), // Sand/Cream
          ),
          fontFamily: 'Roboto',
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF2F62A7),
            elevation: 0,
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => SplashScreen(),
          '/auth': (context) => AuthScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}