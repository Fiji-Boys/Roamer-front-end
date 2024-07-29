import 'package:flutter/material.dart';
import 'package:figenie/consts.dart';
import 'package:figenie/model/tour.dart';

class TourTypes extends StatefulWidget {
  final void Function(TourType, bool) onTourTypeSelected;

  const TourTypes({super.key, required this.onTourTypeSelected});

  @override
  _TourTypesState createState() => _TourTypesState();
}

class _TourTypesState extends State<TourTypes> {
  TourType? selectedTourType;

  bool shouldReset = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: TourType.values.map((type) {
        bool isSelected = type == selectedTourType;

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedTourType = null;
                shouldReset = true;
                widget.onTourTypeSelected(type, shouldReset);
              } else {
                selectedTourType = type;
                shouldReset = false;
                widget.onTourTypeSelected(type, shouldReset);
              }
            });
          },
          child: Card(
            color: isSelected ? secondaryColor : foregroundColor,
            margin: const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                type.toString().split('.').last,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? foregroundColor : textLightColor,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
