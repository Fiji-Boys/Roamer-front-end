import 'dart:ui';

import 'package:figenie/consts.dart';
import 'package:figenie/model/key_point.dart';
import 'package:figenie/pages/key_point_info.dart';
import 'package:flutter/material.dart';

class KeyPointModal extends StatefulWidget {
  final KeyPoint keyPoint;
  final Function onComplete;

  const KeyPointModal({
    super.key,
    required this.keyPoint,
    required this.onComplete,
  });

  @override
  State<KeyPointModal> createState() => _KeyPointModalState();
}

class _KeyPointModalState extends State<KeyPointModal> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        insetPadding: const EdgeInsets.all(5),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: foregroundColor),
            height: MediaQuery.of(context).size.height * 0.9,
            child: KeyPointInfo(
              keyPoint: widget.keyPoint,
              onComplete: () {
                widget.onComplete();
              },
              onBack: () {
                Navigator.of(context).pop();
              },
            )));
  }
}
