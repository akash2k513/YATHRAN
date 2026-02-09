import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yathran/screens/auth_screen.dart';
import 'package:yathran/screens/home_screen.dart';
import 'package:yathran/screens/trip_creation_screen.dart';
import 'package:yathran/screens/profile_screen.dart';
import 'package:yathran/screens/trending_destinations_screen.dart';
import 'package:yathran/screens/crowd_insights_screen.dart';
import 'package:yathran/screens/map_screen.dart';
import 'package:yathran/screens/ai_companion_screen.dart';
import 'package:yathran/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Remove Firebase initialization for now
  // await Firebase.initializeApp(...);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'YĀTHRAN',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF2F62A7),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: MaterialColor(0xFF2F62A7, {
              50: Color(0xFFE8F0F9),
              100: Color(0xFFC5D8F1),
              200: Color(0xFF9FBEE8),
              300: Color(0xFF78A4DF),
              400: Color(0xFF5B91D8),
              500: Color(0xFF3E7DD1),
              600: Color(0xFF3875CC),
              700: Color(0xFF306AC6),
              800: Color(0xFF2860C0),
              900: Color(0xFF1B4DB5),
            }),
          ).copyWith(
            secondary: Color(0xFF4AB4DE),
            background: Color(0xFFEEDBCC),
          ),
          scaffoldBackgroundColor: Color(0xFFEEDBCC),
          appBarTheme: AppBarTheme(
            color: Color(0xFF2F62A7),
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFF4AB4DE)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFF2F62A7), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Color(0xFF2F62A7),
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2F62A7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF2F62A7),
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: Colors.white,
            elevation: 5,
          ),
          chipTheme: ChipThemeData(
            backgroundColor: Color(0xFF4AB4DE).withOpacity(0.1),
            selectedColor: Color(0xFF4AB4DE),
            labelStyle: TextStyle(color: Color(0xFF2F62A7)),
            secondaryLabelStyle: TextStyle(color: Colors.white),
            brightness: Brightness.light,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFF2F62A7),
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 10,
          ),
          bottomAppBarTheme: BottomAppBarThemeData(
            color: Colors.white,
            elevation: 10,
            shape: CircularNotchedRectangle(),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF2F62A7),
            foregroundColor: Colors.white,
            elevation: 8,
          ),
          textTheme: TextTheme(
            displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F62A7),
            ),
            displayMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F62A7),
            ),
            displaySmall: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F62A7),
            ),
            headlineMedium: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F62A7),
            ),
            headlineSmall: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F62A7),
            ),
            titleLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F62A7),
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
        home: Consumer<AuthService>(
          builder: (context, authService, child) {
            // Remove isLoading check or implement it in AuthService
            // For now, just show AuthScreen
            return AuthScreen(); // Or HomeScreen() for testing
          },
        ),
        routes: {
          '/home': (context) => HomeScreen(),
          '/auth': (context) => AuthScreen(),
          '/trip-creation': (context) => TripCreationScreen(),
          '/profile': (context) => ProfileScreen(),
          '/trending': (context) => TrendingDestinationsScreen(),
          '/crowd-insights': (context) => CrowdInsightsScreen(),
          '/map': (context) => MapScreen(),
          '/ai-companion': (context) => AICompanionScreen(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/trip-creation':
            // Remove the destination parameter if TripCreationScreen doesn't support it
              return MaterialPageRoute(
                builder: (context) => TripCreationScreen(),
              );
            case '/map':
              final args = settings.arguments as Map<String, dynamic>?;
              return MaterialPageRoute(
                builder: (context) => MapScreen(
                  showCrowdHeatmap: args?['showCrowdHeatmap'] ?? true,
                  initialCenter: args?['initialCenter'],
                  markers: args?['markers'],
                ),
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}