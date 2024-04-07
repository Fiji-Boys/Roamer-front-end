import 'package:figenie/pages/map.dart';
import 'package:flutter/material.dart';

import 'utils/navigationMenu.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            // MapPage(), // Display the MapPage
            NavigationMenu(), // Display the NavigationMenu
          ],
        ),
      ),
    );
  }
}
