
import 'package:cursova/pages/home_page.dart';
import 'package:cursova/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// the main function of the application
void main() async {
  /// initialize widgets
  WidgetsFlutterBinding.ensureInitialized();
  /// initialize Firebase with the provided options
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      storageBucket: "saamchuk-7173f.appspot.com",
      apiKey: "AIzaSyD3ZKD85fEASsy0UNzZTukriV--I5M0Z0w",
      appId: "1:344417111025:web:fc7bab93052ed080bed250",
      messagingSenderId: "344417111025", 
      projectId: "saamchuk-7173f"
    )
  );
  /// run the application
  runApp(const MyApp());
}

/// the main widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// represents the ID of the current user in the database
  /// the [userId] is used to uniquely identify users in the system
  static String userId = '';

  /// determines the access rights of the current user
  /// if [access] is true, the user has elevated priviliges; otherwise, they have limited access
  static bool access = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // set the home page of the application
      home: const HomePage(),

      routes: {
        '': (context) => const HomePage(),
        '/newpage': (context) => const LoginPage(),
      },
    );
  }
}