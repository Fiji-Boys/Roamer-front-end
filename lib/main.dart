import 'package:figenie/consts.dart';
import 'package:figenie/pages/map.dart';
import 'package:figenie/widgets/placeholder.dart' as roamer_placeholder;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/navigation_menu.dart';

void main() {
  runApp(MainApp());
}

final NavigationBarController controller = Get.put(NavigationBarController());

class MainApp extends StatelessWidget {
  final PageController pageController =
      PageController(initialPage: controller.selectedIndex.value);

  MainApp({super.key});

  void _onNavigate(int index) {
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: backgroundColor,
        bottomNavigationBar: Obx(() => NavigationMenu(
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.tour), // Icon for Tours
                    label: 'Tours', // Label for Tours
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.people), // Icon for Encounters
                    label: 'Encounters', // Label for Encounters
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.map), // Icon for Map
                    label: 'Map', // Label for Map
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.qr_code), // Icon for QR
                    label: 'QR', // Label for QR
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person), // Icon for Profile
                    label: 'Profile', // Label for Profile
                  ),
                ],
                selectedIndex: controller.selectedIndex.value,
                onDestinationSelected: (index) => {
                      _onNavigate(index),
                      controller.selectedIndex.value = index
                    })),
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

  final screens = [
    const roamer_placeholder.Placeholder(),
    const roamer_placeholder.Placeholder(),
    const MapPage(),
    const roamer_placeholder.Placeholder(),
    const roamer_placeholder.Placeholder()
  ];
}
