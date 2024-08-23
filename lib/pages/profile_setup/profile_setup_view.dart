import 'dart:io';

import 'package:figenie/consts.dart';
import 'package:figenie/pages/profile_setup/profile_setup_controller.dart';
import 'package:flutter/material.dart';

class ProfileSetupView extends StatelessWidget {
  final ProfileSetupController state;

  const ProfileSetupView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: state.isUsernameSet ? image() : username(),
    );
  }

  Widget image() {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: state.pickImage,
              child: CircleAvatar(
                radius: 75,
                backgroundColor: foregroundColor,
                backgroundImage: state.imageFile != null
                    ? FileImage(File(state.imageFile!.path))
                    : null,
                child: state.imageFile == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: primaryLightColor,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            // Text
            const Text(
              'Tap the image to select a profile picture. This step is optional, feel free to skip.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(primaryColor),
                    foregroundColor: WidgetStateProperty.all<Color>(textColor),
                  ),
                  onPressed: state.handleNextImage,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                    child: Text("Next"),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                // Skip button
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(secondaryColor),
                    foregroundColor: WidgetStateProperty.all<Color>(textColor),
                  ),
                  onPressed: state.handleSkip,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                    child: Text("Skip"),
                  ),
                ),
              ],
            ),
            // Next button
          ],
        ),
      ),
    );
  }

  Widget username() {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Image at the top
            Image.asset(
              'assets/mascot_1.png', // Replace with your image path
              height: 128,
              width: 128,
            ),
            const SizedBox(height: 20),
            // Text
            const Text(
              'Welcome! Please enter your username to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            const SizedBox(height: 20),
            // Username input
            TextField(
              controller: state.usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor, width: 2.0),
                ),
                floatingLabelStyle: TextStyle(color: secondaryColor),
              ),
              style: const TextStyle(color: textColor),
            ),
            const SizedBox(height: 20),
            // Next button
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(primaryColor),
                foregroundColor: WidgetStateProperty.all<Color>(textColor),
              ),
              onPressed: state.handleNext,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                child: Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
