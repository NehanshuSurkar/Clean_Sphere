import 'package:cleansphere/screens/complaint_review.dart';
import 'package:cleansphere/screens/tracking.dart';
import 'package:flutter/material.dart';
import 'package:cleansphere/screens/adminhomepage.dart';
import 'package:cleansphere/screens/registration_screen.dart';
import 'package:cleansphere/screens/userhome.dart';
import 'package:cleansphere/services/user_status.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CleanSphere',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Roboto'),
      initialRoute: '/',
      routes: {
        '/': (context) => const Start(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const UserHomeScreen(),
        '/admin_home': (context) => const AdminHomeScreen(),
        '/tracking': (context) => const TruckMonitoringScreen(),
        '/complaints': (context) => const ReviewComplaintsScreen(),
        '/feedback':
            (context) => const Placeholder(), // Add Feedback Page later
        '/stats': (context) => const Placeholder(), // Add Stats Page later
        '/reports':
            (context) => const Placeholder(), // Add Admin Report Page later
        '/routes':
            (context) => const Placeholder(), // Add Navigation Page later
      },
    );
  }
}
