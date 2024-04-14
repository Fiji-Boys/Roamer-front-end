// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:figenie/consts.dart';
import 'package:figenie/model/tour.dart';

class TourInfo extends StatefulWidget {
  final Tour tour;
  final VoidCallback onStartTour;
  const TourInfo({
    super.key,
    required this.tour,
    required this.onStartTour,
  });

  @override
  State<TourInfo> createState() => _TourInfoState();
}

class _TourInfoState extends State<TourInfo> {
  final GlobalKey<_DraggableSheetState> sheetKey =
      GlobalKey<_DraggableSheetState>();

  @override
  Widget build(BuildContext context) {
    return DraggableSheet(
      key: sheetKey,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.tour.name,
              style: const TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.tour.description,
              style: const TextStyle(fontSize: 16, color: textLighterColor),
            ),
            const SizedBox(height: 16),
            CarouselSlider(
              items: widget.tour.keyPoints.map((keyPoint) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(
                          20.0), // Adjust the borderRadius as needed
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: const BoxDecoration(color: backgroundColor),
                        child: Image.network(
                          keyPoint.images[0],
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
                height: 250,
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  widget.onStartTour();
                  sheetKey.currentState?.hide();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(secondaryColor),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(backgroundColor),
                ),
                child: const Text('Start Tour'),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.tour.keyPoints.map((keyPoint) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
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
    if (currentSize <= 0.05) collapse();
  }

  void collapse() => animateSheet(getSheet.snapSizes!.first);

  void anchor() => animateSheet(getSheet.snapSizes!.last);

  void expand() => animateSheet(getSheet.maxChildSize);

  void hide() => animateSheet(getSheet.minChildSize);

  void animateSheet(double size) {
    controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
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
        initialChildSize: 0.15,
        maxChildSize: 0.9,
        minChildSize: 0.03,
        expand: true,
        snap: true,
        snapSizes: [
          120 / constraints.maxHeight,
          0.49,
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
