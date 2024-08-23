import 'package:carousel_slider/carousel_slider.dart';
import 'package:figenie/consts.dart';
import 'package:figenie/model/key_point.dart';
import 'package:flutter/material.dart';

class KeyPointInfo extends StatefulWidget {
  final KeyPoint keyPoint;
  final Function onComplete;
  final VoidCallback onBack;

  const KeyPointInfo({
    super.key,
    required this.keyPoint,
    required this.onComplete,
    required this.onBack,
  });

  @override
  State<KeyPointInfo> createState() => _KeyPointInfoState();
}

class _KeyPointInfoState extends State<KeyPointInfo> {
  int _currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: foregroundColor,
      child: Column(
        children: [
          _headerUI(),
          Expanded(
            child: ListView(children: [
              _imagesUI(),
              _audioPlayer(),
              _descriptionUI(),
              _completeButton(),
            ]),
          )
        ],
      ),
    );
  }

  Widget _backButton() {
    return Positioned(
      left: 2.0,
      child: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: textColor,
          onPressed: widget.onBack),
    );
  }

  Widget _headerUI() {
    return Stack(children: [
      Container(
        padding: const EdgeInsets.all(5.0),
        width: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: backgroundColor,
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: textColor,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
          softWrap: true,
          overflow: TextOverflow.clip,
          child: Text(widget.keyPoint.name),
        ),
      ),
      _backButton(),
    ]);
  }

  Widget _imagesUI() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          CarouselSlider(
            items: widget.keyPoint.images.map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: const BoxDecoration(color: backgroundColor),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return Container(
                            color: backgroundColor,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/mascot_2.png",
                                    width: 196,
                                    height: 196,
                                  ),
                                  const Text(
                                    "Image not found...",
                                    style: TextStyle(
                                        color: textLighterColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentCarouselIndex = index;
                });
              },
            ),
          ),
          Positioned(
            bottom: 10.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.keyPoint.images.map((image) {
                int index = widget.keyPoint.images.indexOf(image);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentCarouselIndex == index
                          ? primaryColor
                          : foregroundColor),
                );
              }).toList(),
            ),
          ),
        ],
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/mascot_2.png",
            width: 80,
            height: 80,
          ),
          const DefaultTextStyle(
            style: TextStyle(
              color: textLighterColor,
              fontWeight: FontWeight.bold,
            ),
            child: Text("Not implemented yet..."),
          ),
        ],
      ),
    );
  }

  Widget _descriptionUI() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DefaultTextStyle(
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              child: Text("Description"),
            ),
            const SizedBox(height: 10),
            DefaultTextStyle(
              style: const TextStyle(
                color: textColor,
                fontSize: 16,
              ),
              child: Text(widget.keyPoint.description),
            ),
          ],
        ),
      ),
    );
  }

  Widget _completeButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Align(
        child: Container(
          margin: const EdgeInsets.only(bottom: 8.0, right: 8.0),
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextButton(
            onPressed: () {
              widget.onComplete();
              widget.onBack();
            },
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(0),
              ),
            ),
            child: const Text(
              'Complete',
              style: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
