import 'package:figenie/pages/map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationBarController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
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
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationBarController extends GetxController {
  final Rx<int> selectedIndex = 3.obs;

  final screens = [
    Container(color: Colors.red),
    Container(color: Colors.green),
    const MapPage(),
    Container(color: Colors.green),
    Container(color: Colors.blue)
  ];
}
