// ignore_for_file: deprecated_member_use

import 'package:figenie/pages/osmap/osmap_controller.dart';
import 'package:figenie/pages/tours/tours_controller.dart';
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
    controller.setNavBarVisibility(true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                        label: 'Encounters',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.map),
                        label: 'Map',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.qr_code),
                        label: 'QR',
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
      const ToursPage(),
      const roamer_placeholder.Placeholder(),
      const OSMapPage(),
      const roamer_placeholder.Placeholder(),
      const roamer_placeholder.Placeholder()
    ];
  }

  void setNavBarVisibility(bool isVisible) {
    isNavBarVisible.value = isVisible;
  }
}
