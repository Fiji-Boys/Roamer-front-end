// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figenie/model/user.dart' as model_user;
import 'package:figenie/pages/leaderboard/leaderboard.dart';
import 'package:figenie/pages/profile/profile_controller.dart';
import 'package:figenie/pages/profile_setup/profile_setup_controller.dart';
import 'package:figenie/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:figenie/consts.dart';
import 'package:figenie/firebase_options.dart';
import 'package:figenie/pages/osmap/osmap_controller.dart';
import 'package:figenie/pages/tours/tours_controller.dart';
import 'package:figenie/widgets/placeholder.dart' as roamer_placeholder;

import 'utils/navigation_menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MainApp());
}

final NavigationBarController controller = Get.put(NavigationBarController());

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final PageController pageController =
      PageController(initialPage: controller.selectedIndex.value);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  firebase_auth.User? _firebaseUser;
  late model_user.User _user;
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _firebaseUser = event;
      });
    });
    _auth.userChanges().listen((event) {
      setState(() {
        _firebaseUser = event;
        if (event != null) {
          _user = model_user.User(
              id: event.uid,
              email: event.email!,
              username: event.displayName!,
              points: 0,
              profilePicture: event.photoURL!,
              completedTours: []);
          _saveUser(_user);
        }
      });
    });
  }

  Future<void> _saveUser(model_user.User user) async {
    try {
      await userService.saveUser(user);
    } catch (e) {
      log('Failed to save user: $e');
    }
  }

  void _onNavigate(int index) {
    pageController.jumpToPage(index);
    controller.setNavBarVisibility(true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: secondaryColor,
          selectionColor: secondaryColor.withOpacity(0.4),
          selectionHandleColor: secondaryColor,
        ),
        primaryColor: primaryColor,
      ),
      home: _firebaseUser == null
          ? Container(
              color: backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/roamer_logo.png',
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 40),
                  SignInButton(
                    Buttons.google,
                    text: "Sign in with Google",
                    onPressed: () async {
                      try {
                        final googleProvider = GoogleAuthProvider();
                        await _auth.signInWithProvider(googleProvider);
                      } catch (e) {
                        log('Google sign-in failed: $e');
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  SignInButton(
                    Buttons.gitHub,
                    text: "Sign in with GitHub",
                    onPressed: () async {
                      try {
                        final githubProvider = GithubAuthProvider();
                        await _auth.signInWithProvider(githubProvider);
                      } catch (e) {
                        log('GitHub sign-in failed: $e');
                      }
                    },
                  ),
                ],
              ),
            )
          : _firebaseUser!.displayName == null ||
                  _firebaseUser!.displayName == ""
              ? const ProfileSetupPage()
              : Scaffold(
                  backgroundColor: Colors.black,
                  bottomNavigationBar: Obx(() {
                    return controller.isNavBarVisible.value
                        ? NavigationMenu(
                            destinations: const [
                                NavigationDestination(
                                  icon: Icon(Icons.tour),
                                  label: 'Tours',
                                ),
                                NavigationDestination(
                                  icon: Icon(Icons.people),
                                  label: 'Events',
                                ),
                                NavigationDestination(
                                  icon: Icon(Icons.map),
                                  label: 'Map',
                                ),
                                NavigationDestination(
                                  icon: Icon(Icons.leaderboard),
                                  label: 'Leaderboard',
                                ),
                                NavigationDestination(
                                  icon: Icon(Icons.person),
                                  label: 'Profile',
                                ),
                              ],
                            selectedIndex: controller.selectedIndex.value,
                            onDestinationSelected: (index) => {
                                  _onNavigate(index),
                                  controller.selectedIndex.value = index
                                })
                        : const SizedBox.shrink();
                  }),
                  body: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: PageView(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: controller.screens,
                      ),
                    ),
                  ),
                ),
    );
  }
}

class NavigationBarController extends GetxController {
  final RxInt selectedIndex = 2.obs;
  final RxBool isNavBarVisible = true.obs;

  late final List<Widget> screens;

  NavigationBarController() {
    screens = [
      ToursPage(
        showOnMap: (value) => {},
      ),
      const roamer_placeholder.Placeholder(),
      const OSMapPage(),
      const LeaderboardPage(),
      const ProfilePage()
    ];
  }

  void setNavBarVisibility(bool isVisible) {
    isNavBarVisible.value = isVisible;
  }
}
