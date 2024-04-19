import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:figenie/consts.dart';
import 'package:figenie/model/key_point.dart';
import 'package:flutter/material.dart';

class KeyPointInfo extends StatefulWidget {
  final KeyPoint keyPoint;

  const KeyPointInfo({
    super.key,
    required this.keyPoint,
  });

  @override
  State<KeyPointInfo> createState() => _KeyPointInfoState();
}

class _KeyPointInfoState extends State<KeyPointInfo> {
  int _currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        insetPadding: const EdgeInsets.all(15),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: foregroundColor),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Stack(children: [
              Positioned(
                top: 1.0,
                right: 2.0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: textColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Column(children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                  width: double.infinity,
                  child: Text(
                    textAlign: TextAlign.center,
                    widget.keyPoint.name,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.clip,
                  ),
                  // Add other widgets as needed
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: backgroundColor,
                  ),
                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  child: Text(
                    textAlign: TextAlign.left,
                    widget.keyPoint.description,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 12,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.clip,
                  ), // Add other widgets as needed
                ),
                Container(
                    margin: const EdgeInsets.all(15),
                    child: Stack(children: [
                      CarouselSlider(
                        items: widget.keyPoint.images.map((image) {
                          return Builder(
                            builder: (BuildContext context) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration: const BoxDecoration(
                                      color: backgroundColor),
                                  child: Image.network(
                                    image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Container(
                                        color: backgroundColor,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                          height: 250,
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
                          children: widget.keyPoint.images.map((iamge) {
                            int index = widget.keyPoint.images.indexOf(iamge);
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
                    ]))
              ])
            ])));
  }
}
