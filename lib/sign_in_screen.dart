import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Jika login berhasil, arahkan ke halaman berikutnya
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    } catch (e) {
      print('Error during Google sign-in: $e');
      // Handle errors
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      // Setelah sign-out, arahkan kembali ke halaman login
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    } catch (e) {
      print('Error during sign-out: $e');
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut,
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: signInWithGoogle,
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}

// class SignInScreen extends StatelessWidget {
//   SignInScreen({super.key});
//
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
//   Future<void> signInWithGoogle(BuildContext context) async {
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser != null) {
//         final GoogleSignInAuthentication googleAuth = await googleUser
//             .authentication;
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );
//         await FirebaseAuth.instance.signInWithCredential(credential);
//
//         // Jika login berhasil, arahkan ke halaman berikutnya
//         // navigatorKey.currentState?.pushReplacementNamed('/home');
//         Navigator.of(context).pushReplacementNamed('/home');
//       }
//     } catch (e) {
//       print('Error during Google sign-in: $e');
//       // Handle errors
//     }
//   }
//
//   Future<void> signOut(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       await GoogleSignIn().signOut();
//       // Setelah sign-out, arahkan kembali ke halaman login
//       navigatorKey.currentState?.pushReplacementNamed('/');
//     } catch (e) {
//       print('Error during sign-out: $e');
//       // Handle errors
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin Login'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               signOut(context);
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             signInWithGoogle(context);
//           },
//           child: const Text('Sign in with Google'),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class SignInScreen extends StatelessWidget {
//   SignInScreen({super.key});
//
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
//   Future<void> signInWithGoogle(BuildContext context) async {
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser != null) {
//         final GoogleSignInAuthentication googleAuth = await googleUser
//             .authentication;
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );
//         await FirebaseAuth.instance.signInWithCredential(credential);
//
//         // Jika login berhasil, arahkan ke halaman berikutnya
//         navigatorKey.currentState?.pushReplacementNamed('/home');
//       }
//     } catch (e) {
//       print('Error during Google sign-in: $e');
//       // Handle errors
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin Login'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             signInWithGoogle(context);
//           },
//           child: const Text('Sign in with Google'),
//         ),
//       ),
//     );
//   }
// }
