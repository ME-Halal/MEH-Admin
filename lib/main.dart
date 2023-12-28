import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meh_admin/firebase_options.dart';
import 'package:meh_admin/home_screen.dart';
import 'package:meh_admin/post_add_screen.dart';
import 'package:meh_admin/sign_in_screen.dart';
import 'package:firebase_database/firebase_database.dart'; // Don't forget to import the necessary package

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('posts'); // Define the database reference
  runApp(MyApp(databaseReference: databaseReference)); // Pass the database reference to MyApp
}

class MyApp extends StatelessWidget {
  final DatabaseReference databaseReference;

  const MyApp({super.key, required this.databaseReference});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Menampilkan loading jika masih menunggu hasil
        } else {
          if (snapshot.hasError) {
            print('Error getting initial route: ${snapshot.error}');
            return const Center(child: Text('Error. Please try again.')); // Tampilkan pesan error jika terjadi kesalahan
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Admin App',
              theme: ThemeData(
                // Theme configuration...
              ),
              home: _buildScreen(snapshot.data),
              routes: {
                '/home': (context) => HomeScreen(databaseReference: databaseReference),
                '/add_post': (context) => PostAddScreen(databaseReference: databaseReference),
              },
            );
          }
        }
      },
    );
  }

  Future<String> _getInitialRoute() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        return '/home';
      } else {
        return '/';
      }
    } catch (e) {
      print('Error getting initial route: $e');
      return '/'; // Default route in case of error
    }
  }

  Widget _buildScreen(String? route) {
    switch (route) {
      case '/':
        return const SignInScreen();
      case '/home':
        return HomeScreen(databaseReference: databaseReference);
      default:
        return Container(); // Return a default screen if route is null or not recognized
    }
  }
}
