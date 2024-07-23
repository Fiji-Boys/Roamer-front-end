import 'package:figenie/consts.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String image;
  final String name;
  final String description;
  final bool showArrow;
  final void Function() onTap;

  const CustomCard({
    super.key,
    required this.image,
    required this.name,
    required this.description,
    required this.onTap,
    required this.showArrow,
  });

  @override
  State<CustomCard> createState() => _CardState();
}

class _CardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Card(
        color: backgroundColor,
        margin: const EdgeInsets.all(8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 110,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        widget.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(
                          color: textLightColor,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.showArrow,
              child: const Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: textColor,
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
