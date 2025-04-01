import 'package:cleansphere/screens/adminhomepage.dart';
import 'package:cleansphere/screens/login_screen.dart';
import 'package:cleansphere/screens/userhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cleansphere/widgets/error_widget.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorWidgetCustom(
              message: "Authentication error. Please try again.",
              onRetry: () {
                setState(() {});
              },
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            // User is logged in → check Firestore for role
            return FutureBuilder<DocumentSnapshot>(
              future:
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(snapshot.data!.uid)
                      .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.hasError) {
                  return ErrorWidgetCustom(
                    message: "Failed to load user data.",
                    onRetry: () {
                      setState(() {});
                    },
                  );
                }

                // if (userSnapshot.hasData && userSnapshot.data != null) {
                //   String userType = userSnapshot.data!['userType'] ?? 'User';

                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                  // ✅ Null-safe access with fallback value
                  final data = userSnapshot.data!;
                  final userType = data.get('userType') ?? 'User';

                  // Navigate based on role
                  if (userType == 'Administrator') {
                    return const AdminHomeScreen();
                  } else {
                    return const UserHomeScreen();
                  }
                }

                // If no role is found, navigate to login screen
                return const LoginScreen();
              },
            );
          } else {
            // User not logged in → navigate to login screen
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
