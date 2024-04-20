import 'dart:ui';

import 'package:figenie/consts.dart';
import 'package:figenie/model/key_point.dart';
import 'package:flutter/material.dart';

class KeyPointInfo extends StatefulWidget {
  final KeyPoint keyPoint;
  final Function onComplete;

  const KeyPointInfo({
    super.key,
    required this.keyPoint,
    required this.onComplete,
  });

  @override
  State<KeyPointInfo> createState() => _KeyPointInfoState();
}

class _KeyPointInfoState extends State<KeyPointInfo> {
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
            child: _buildUI()));
  }

  Widget _buildUI() {
    return SingleChildScrollView(
        child: Stack(children: [
      Column(
        children: [
          _headerUI(),
          _imagesUI(),
          _audioPlayer(),
          _descriptionUI(),
        ],
      ),
      _backButton(),
    ]));
  }

  Widget _backButton() {
    return Positioned(
      top: 1.0,
      left: 2.0,
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: textColor,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _headerUI() {
    return Stack(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            image: DecorationImage(
              image: NetworkImage(
                widget.keyPoint.images[0],
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.keyPoint.name,
                style: const TextStyle(
                  color: textColor,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ),
        _completeButton(),
      ],
    );
  }

  Widget _imagesUI() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.18,
      child: ListView.builder(
        padding: const EdgeInsets.all(5),
        scrollDirection: Axis.horizontal,
        itemCount: widget.keyPoint.images.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 160, // Specify the width here
                child: Image.network(
                  widget.keyPoint.images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Container(
                      color: backgroundColor,
                      child: Center(
                        child: Column(
                          // mainAxisAlignment:
                          //     MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/mascot_2.png",
                              width: 90,
                              height: 90,
                            ),
                            const Text(
                              "Image not found...",
                              style: TextStyle(
                                color: textLighterColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _audioPlayer() {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: backgroundColor, // Border color
          width: 1, // Border thickness
        ),
        boxShadow: [
          BoxShadow(
            color: textColor.withOpacity(0.2), // Shadow color
            blurRadius: 5, // Spread radius
            // offset: const Offset(0, 2), // Shadow position
          ),
        ],
      ),
      height: MediaQuery.of(context).size.height * 0.15,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Column(
        // mainAxisAlignment:
        //     MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/mascot_2.png",
            width: 80,
            height: 80,
          ),
          const Text(
            "Not implemented yet...",
            style: TextStyle(
              color: textLighterColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionUI() {
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description:',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.keyPoint.description,
              style: const TextStyle(
                color: textColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _completeButton() {
    return Positioned(
      bottom: 8.0,
      left: 8.0,
      child: Container(
        width: 60,
        height: 25,
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextButton(
          onPressed: () {
            widget.onComplete();
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            padding:
                MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
          ),
          child: const Text(
            'Complete',
            style: TextStyle(
              fontSize: 12,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
