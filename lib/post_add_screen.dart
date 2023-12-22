import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class PostAddScreen extends StatefulWidget {
  final DatabaseReference databaseReference;

  const PostAddScreen({super.key, required this.databaseReference});

  @override
  PostAddScreenState createState() => PostAddScreenState();
}

class PostAddScreenState extends State<PostAddScreen> {
  final ImagePicker picker = ImagePicker();
  File? _imageFile;
  String title = '';
  String description = '';
  bool _isUploading = false;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> uploadImage() async {
    setState(() {
      _isUploading = true;
    });

    if (_imageFile != null) {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');
      UploadTask uploadTask = storageReference.putFile(_imageFile!);
      await uploadTask.whenComplete(() async {
        String imageUrl = await storageReference.getDownloadURL();

        // Save the post with image URL to Firebase Realtime Database
        DatabaseReference newPostRef = widget.databaseReference.push();
        newPostRef.set({
          'title': title,
          'description': description,
          'imageUrl': imageUrl, // Save image URL to the database
        }).then((_) {
          setState(() {
            _isUploading = false;
          });
          Navigator.pop(context);
        }).catchError((onError) {
          setState(() {
            _isUploading = false;
          });
          // Handle errors during saving post to Firebase Database
          print('Error saving post: $onError');
        });
      }).catchError((onError) {
        setState(() {
          _isUploading = false;
        });
        // Handle errors during image upload
        print('Error uploading image: $onError');
        return Future<TaskSnapshot>.error(onError
            .toString()); // Add this line to return null in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _imageFile == null
                  ? const Text('No image selected.')
                  : Image.file(
                      _imageFile!,
                      height: 250,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  getImage();
                },
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(hintText: 'Enter Title'),
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  title = value;
                },
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(hintText: 'Enter Description'),
                maxLines: null, // Set maxLines to null for multiline input
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  description = value;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isUploading ? null : uploadImage,
                child: _isUploading
                    ? const CircularProgressIndicator()
                    : const Text('Add Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
