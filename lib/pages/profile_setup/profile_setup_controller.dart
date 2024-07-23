import 'dart:developer';
import 'dart:io';

import 'package:figenie/pages/profile_setup/profile_setup_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => ProfileSetupController();
}

class ProfileSetupController extends State<ProfileSetupPage> {
  final TextEditingController usernameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  bool isUsernameSet = false;
  late String username;
  XFile? imageFile;
  User? user;

  @override
  Widget build(BuildContext context) {
    return ProfileSetupView(this);
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        user = event;
      });
    });
  }

  void handleNext() async {
    username = usernameController.text;
    setState(() {
      isUsernameSet = true;
    });
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = pickedFile;
    });
  }

  void handleNextImage() async {
    if (imageFile != null) {
      final storageRef = FirebaseStorage.instance.ref();

      final fileRef = storageRef.child('images/${user?.uid}');

      await fileRef.putFile(File(imageFile!.path));
      try {
        final downloadUrl = await fileRef.getDownloadURL();

        _auth.currentUser?.updatePhotoURL(downloadUrl);

        _auth.currentUser?.updateDisplayName(username);
      } catch (e) {
        log('Error updating user: $e');
      }
    } else {
      log('No image selected');
    }
  }

  void handleSkip() {
    _auth.currentUser?.updateDisplayName(username);
    log('Skipped profile image upload');
  }
}
