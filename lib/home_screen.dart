import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meh_admin/detail_screen.dart';
import 'package:meh_admin/post_add_screen.dart';

class HomeScreen extends StatefulWidget {
  final DatabaseReference databaseReference;

  const HomeScreen({super.key, required this.databaseReference});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: widget.databaseReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic> posts =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            List<Widget> postWidgets = [];

            posts.forEach((key, value) {
              // Check if imageUrl exists, if not, use a placeholder
              String? imageUrl = value['imageUrl'];
              Widget leadingWidget = imageUrl != null
                  ? Container(
                      width: 80, // Set the width and height as needed
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey, // Placeholder color or default color
                      child: const Icon(Icons.image, color: Colors.white),
                    );

              postWidgets.addAll(
                [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            title: value['title'],
                            description: value['description'],
                            imageUrl: value['imageUrl'],
                          ),
                        ),
                      );
                    },
                    leading: leadingWidget,
                    title: Text(
                      value['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          value['description'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              );
            });

            return ListView(
              children: postWidgets,
            );
          } else {
            return const Center(
              child: Text('No posts yet'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostAddScreen(
                      databaseReference: widget.databaseReference,
                    )),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// class HomeScreen extends StatefulWidget {
//   final DatabaseReference databaseReference;
//
//   const HomeScreen({super.key, required this.databaseReference});
//
//   @override
//   HomeScreenState createState() => HomeScreenState();
// }
//
// class HomeScreenState extends State<HomeScreen> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Screen'),
//       ),
//       body: StreamBuilder<DatabaseEvent>(
//         stream: widget.databaseReference.onValue,
//         builder: (context, snapshot) {
//           if (snapshot.hasData &&
//               !snapshot.hasError &&
//               snapshot.data!.snapshot.value != null) {
//             Map<dynamic, dynamic> posts =
//             snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//             List<Widget> postWidgets = [];
//
//             posts.forEach((key, value) {
//               postWidgets.add(
//                 ListTile(
//                   title: Text(value['title']),
//                   subtitle: Text(value['description']),
//                   // You can display image here if available
//                 ),
//               );
//             });
//
//             return ListView(
//               children: postWidgets,
//             );
//           } else {
//             return const Center(
//               child: Text('No posts yet'),
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => PostAddScreen(databaseReference: widget.databaseReference)),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:meh_admin/post_add_screen.dart';
//
// class HomeScreen extends StatelessWidget {
//   final DatabaseReference _databaseReference =
//   FirebaseDatabase.instance.reference().child('posts');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen'),
//       ),
//       body: StreamBuilder<DataSnapshot>(
//         stream: _databaseReference.onValue,
//         builder: (context, snapshot) {
//           if (snapshot.hasData &&
//               !snapshot.hasError &&
//               snapshot.data!.snapshot.value != null) {
//             Map<dynamic, dynamic> posts =
//                 snapshot.data!.snapshot.value;
//             List<Widget> postWidgets = [];
//
//             posts.forEach((key, value) {
//               postWidgets.add(
//                 ListTile(
//                   title: Text(value['title']),
//                   subtitle: Text(value['description']),
//                   // You can display image here if available
//                 ),
//               );
//             });
//
//             return ListView(
//               children: postWidgets,
//             );
//           } else {
//             return Center(
//               child: Text('No posts yet'),
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   PostAddScreen(databaseReference: _databaseReference),
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:meh_admin/post_add_screen.dart';
//
// class HomeScreen extends StatelessWidget {
//   final DatabaseReference _databaseReference =
//       FirebaseDatabase.instance.reference().child('posts');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen'),
//       ),
//       body: StreamBuilder(
//         stream: _databaseReference.onValue,
//         builder: (context, AsyncSnapshot<Event> snapshot) {
//           if (snapshot.hasData &&
//               !snapshot.hasError &&
//               snapshot.data!.snapshot.value != null) {
//             Map<dynamic, dynamic> posts = snapshot.data!.snapshot.value;
//             List<Widget> postWidgets = [];
//
//             posts.forEach((key, value) {
//               postWidgets.add(
//                 ListTile(
//                   title: Text(value['title']),
//                   subtitle: Text(value['description']),
//                   // You can display image here if available
//                 ),
//               );
//             });
//
//             return ListView(
//               children: postWidgets,
//             );
//           } else {
//             return Center(
//               child: Text('No posts yet'),
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   PostAddScreen(databaseReference: _databaseReference),
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
