// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:figenie/consts.dart';
import 'package:figenie/model/tour.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class TourInfo extends StatefulWidget {
  final Tour tour;
  final VoidCallback onStartTour;
  final ValueNotifier<double> valueNotifier;
  final bool isTourActive;

  const TourInfo({
    super.key,
    required this.tour,
    required this.onStartTour,
    required this.valueNotifier,
    required this.isTourActive,
  });

  @override
  State<TourInfo> createState() => _TourInfoState();
}

class _TourInfoState extends State<TourInfo> {
  final GlobalKey<_DraggableSheetState> sheetKey =
      GlobalKey<_DraggableSheetState>();

  int _currentCarouselIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableSheet(
      key: sheetKey,
      child: Container(
        padding: const EdgeInsets.only(
            left: 16.0, top: 10.0, right: 16.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        widget.tour.name,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 210,
                      child: Text(
                        widget.tour.description,
                        style: const TextStyle(
                            fontSize: 16, color: textLighterColor),
                        softWrap: true,
                        overflow: TextOverflow.clip,
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: widget.isTourActive
                      ? SimpleCircularProgressBar(
                          backColor: backgroundColor,
                          progressColors: const [
                            secondaryLightColor,
                            secondaryColor,
                            secondaryDarkColor,
                            // primaryLightColor,
                            // primaryColor,
                            // primaryDarkColor,
                          ],
                          size: 70,
                          progressStrokeWidth: 10,
                          backStrokeWidth: 10,
                          valueNotifier: widget.valueNotifier,
                          mergeMode: true,
                          onGetText: (double value) {
                            TextStyle centerTextStyle = const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: secondaryColor,
                            );

                            return Text(
                              '${value.toInt()}%',
                              style: centerTextStyle,
                            );
                          },
                        )
                      : ElevatedButton(
                          onPressed: () {
                            widget.onStartTour();
                            sheetKey.currentState?.hide();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                secondaryColor),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                backgroundColor),
                          ),
                          child: const Text('Start Tour'),
                        ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Stack(
              children: [
                CarouselSlider(
                  items: widget.tour.keyPoints.map((keyPoint) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration:
                                const BoxDecoration(color: backgroundColor),
                            child: Image.network(
                              keyPoint.images[0],
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
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
                    children: widget.tour.keyPoints.map((keyPoint) {
                      int index = widget.tour.keyPoints.indexOf(keyPoint);
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
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.tour.keyPoints.asMap().entries.map((entry) {
                final index = entry.key;
                final keyPoint = entry.value;
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 32.0,
                        backgroundColor: secondaryColor,
                        child: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(keyPoint.images[0]),
                            backgroundColor: primaryColor,
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: primaryColor,
                                child: Text("${index + 1}",
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )),
                      ),

                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              keyPoint.name,
                              style: const TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              keyPoint.description,
                              style: const TextStyle(
                                color: textLighterColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Spacer(),
                      // const Icon(
                      //   Icons.location_pin,
                      //   size: 40,
                      //   color: primaryColor,
                      // ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class DraggableSheet extends StatefulWidget {
  final Widget child;
  const DraggableSheet({super.key, required this.child});

  @override
  State<DraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet> {
  final GlobalKey<_DraggableSheetState> sheet =
      GlobalKey<_DraggableSheetState>();
  final controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    controller.addListener(onChanged);
  }

  void onChanged() {
    final currentSize = controller.size;
    if (currentSize < 0.03) collapse();
  }

  void collapse() => animateSheet(getSheet.snapSizes!.first);

  void anchor() => animateSheet(getSheet.snapSizes!.last);

  void expand() => animateSheet(getSheet.maxChildSize);

  void hide() => animateSheet(getSheet.minChildSize);

  void animateSheet(double size) {
    controller.animateTo(
      size,
      duration: const Duration(milliseconds: 70),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  DraggableScrollableSheet get getSheet =>
      (sheet.currentWidget as DraggableScrollableSheet);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return DraggableScrollableSheet(
        key: sheet,
        initialChildSize: 0.17,
        maxChildSize: 0.85,
        minChildSize: 0.04,
        expand: true,
        snap: true,
        snapSizes: [
          140 / constraints.maxHeight,
          0.53,
        ],
        controller: controller,
        builder: (BuildContext context, ScrollController scrollController) {
          return DecoratedBox(
            decoration: const BoxDecoration(
              color: foregroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 5,
                  spreadRadius: 0.1,
                  offset: Offset(0, 1),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                topButtonIndicator(),
                SliverToBoxAdapter(
                  child: widget.child,
                ),
              ],
            ),
          );
        },
      );
    });
  }

  SliverToBoxAdapter topButtonIndicator() {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Wrap(
              children: [
                Container(
                  width: 100,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  height: 5,
                  decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
