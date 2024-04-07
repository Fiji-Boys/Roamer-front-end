import 'package:figenie/consts.dart';
import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
  final int selectedIndex;
  final List<NavigationDestination> destinations;
  final Function(int) onDestinationSelected;
  const NavigationMenu(
      {super.key,
      required this.selectedIndex,
      required this.destinations,
      required this.onDestinationSelected});
  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (Set<MaterialState> states) => TextStyle(
              color: states.contains(MaterialState.selected)
                  ? secondaryColor
                  : textLighterColor,
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
        iconTheme: MaterialStateProperty.resolveWith<IconThemeData>(
          (Set<MaterialState> states) => states.contains(MaterialState.selected)
              ? const IconThemeData(color: secondaryContentColor)
              : const IconThemeData(color: textLighterColor),
        ),
      ),
      child: NavigationBar(
        height: 80,
        elevation: 0,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        backgroundColor: backgroundColor,
        shadowColor: borderColor,
        indicatorColor: secondaryColor,
        surfaceTintColor: textColor,
        destinations: destinations,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}

class CustomNavigationDestination {
  final Icon icon;
  final String label;

  const CustomNavigationDestination({required this.icon, required this.label});
}
