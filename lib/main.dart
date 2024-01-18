import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homicare/pages/admin/home_editor_admin.dart';
import 'package:homicare/api/notifications.dart';
import 'package:homicare/pages/home_page_editor.dart';
import 'package:homicare/firebase_options.dart';
import 'package:homicare/pages/start.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //tying together the Flutter framework and the Flutter engine

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseApi().initNotifications();

//stores data and takes value inkey value pair
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("loggedIn") ?? false;
    bool isAdmin = prefs.getBool("isAdmin") ?? false;

    runApp(MyApp(isLoggedIn: isLoggedIn, isAdmin: isAdmin));
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isAdmin;

  const MyApp({required this.isLoggedIn, required this.isAdmin, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: FutureBuilder(
        future: checkLoginStatus(),
        builder: (context, loginSnapshot) {
          if (loginSnapshot.connectionState == ConnectionState.waiting) {

            // Show a splash screen with a white background and a centered icon
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Image.asset(
                  'assets/images/icon.png', // Replace with your icon asset path
                  width: 100.0, // Adjust the size according to your needs
                  height: 100.0,
                ),
              ),
            );
          } else {
            return FutureBuilder(
              future: checkLoginStatus(),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  // Show a splash screen with a white background and a centered icon
                  return Scaffold(
                    backgroundColor: Colors.white,
                    body: Center(
                      child: Image.asset(
                        'assets/images/icon.png', // Replace with your icon asset path
                        width: 100.0, // Adjust the size according to your needs
                        height: 100.0,
                      ),
                    ),
                  );
                } else {
                  if (isLoggedIn) {
                    if (isAdmin) {
                      return const MyHomePageAdmin();
                    } else {
                      return const MyHomePage();
                    }
                  } else {
                    return const StartPage();
                  }
                }
              },
            );
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<bool> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate asynchronous operation
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("loggedIn") ?? false;
  }
  
}