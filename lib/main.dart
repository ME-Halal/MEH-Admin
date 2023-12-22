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



// class MyApp extends StatelessWidget {
//   final DatabaseReference databaseReference; // Database reference field
//
//   const MyApp({super.key, required this.databaseReference}); // Constructor to accept database reference
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Admin App',
//       // theme: ThemeData(
//       //   primarySwatch: Colors.blue,
//       //   visualDensity: VisualDensity.adaptivePlatformDensity,
//       // ),
//       theme: ThemeData(
//         // This is the theme of your application.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (context) =>  const SignInScreen(),
//         '/home': (context) => HomeScreen(databaseReference: databaseReference), // Pass the database reference to HomeScreen
//         '/add_post': (context) => PostAddScreen(databaseReference: databaseReference), // Pass the database reference to PostAddScreen
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:meh_admin/home_screen.dart';
// import 'package:meh_admin/post_add_screen.dart';
// import 'package:meh_admin/sign_in_screen.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Admin App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       initialRoute: '/', // Set initial route
//       routes: {
//         '/': (context) => const SignInScreen(), // Set SignInScreen as initial screen
//         '/home': (context) => HomeScreen(), // Route to HomeScreen
//         '/add_post': (context) => const PostAddScreen(databaseReference: databaseReference,), // Route to PostAddScreen if needed
//       },
//       home: HomeScreen(),
//     );
//   }
// }


// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
