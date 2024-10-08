// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:figenie/model/key_point.dart';
import 'package:flutter/material.dart';
import 'package:figenie/consts.dart';
import 'package:figenie/model/tour.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class TourInfo extends StatefulWidget {
  final int nextKeyPointIndex;
  final Tour tour;
  final VoidCallback onStartTour;
  final ValueNotifier<double> valueNotifier;
  final bool isTourActive;
  final VoidCallback close;

  const TourInfo({
    super.key,
    required this.nextKeyPointIndex,
    required this.tour,
    required this.onStartTour,
    required this.valueNotifier,
    required this.isTourActive,
    required this.close,
  });

  @override
  State<TourInfo> createState() => _TourInfoState();
}

class _TourInfoState extends State<TourInfo> {
  final GlobalKey<_DraggableSheetState> sheetKey =
      GlobalKey<_DraggableSheetState>();
  late Map<int, bool> visitedKeyPoints = {
    for (var keyPoint in widget.tour.keyPoints)
      widget.tour.keyPoints.indexOf(keyPoint): false
  };

  int _currentCarouselIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TourInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.nextKeyPointIndex != oldWidget.nextKeyPointIndex) {
      _markAsVisited(oldWidget.nextKeyPointIndex);
    }
  }

  void _markAsVisited(int visitedIndex) {
    setState(() {
      visitedKeyPoints[visitedIndex] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableSheet(
      key: sheetKey,
      child: Stack(children: [
        Stack(
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: closeButtonUI(),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: headerUI(),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: widget.isTourActive
                              ? progressBar()
                              : startTourButtonUI(),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 10.0, right: 16.0, bottom: 16.0),
                    child: Column(children: [
                      descriptionUI(),
                      const SizedBox(height: 26),
                      Stack(
                        children: [
                          imagesUI(),
                          imageSliderUI(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      cardUI()
                    ]),
                  )
                ]),
          ],
        ),
      ]),
    );
  }

  Widget closeButtonUI() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: IconButton(
        icon: const Icon(Icons.close),
        color: secondaryColor,
        onPressed: () {
          widget.close();
        },
      ),
    );
  }

  Widget headerUI() {
    return SizedBox(
      width: 180,
      child: Center(
        child: Text(
          widget.tour.name,
          style: const TextStyle(
            color: textColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center, // Center the text
          softWrap: true,
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }

  Widget startTourButtonUI() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: IconButton(
        icon: const Icon(Icons.play_arrow),
        color: primaryColor,
        onPressed: () {
          widget.onStartTour();
          sheetKey.currentState?.hide();
        },
      ),
    );
  }

  Widget progressBar() {
    return SizedBox(
      width: 50, // Adjust width
      height: 50, // Adjust height
      child: SimpleCircularProgressBar(
        backColor: backgroundColor,
        progressColors: const [
          primaryLightColor,
          primaryColor,
          primaryDarkColor,
        ],
        progressStrokeWidth: 8, // Adjust stroke width to be proportionate
        backStrokeWidth: 8, // Adjust stroke width to be proportionate
        valueNotifier: widget.valueNotifier,
        mergeMode: true,
        onGetText: (double value) {
          TextStyle centerTextStyle = const TextStyle(
            fontSize:
                14, // Adjust text size to fit within the smaller progress bar
            fontWeight: FontWeight.bold,
            color: primaryColor,
          );

          return Text(
            '${value.toInt()}%',
            style: centerTextStyle,
          );
        },
      ),
    );
  }

  Widget descriptionUI() {
    return SizedBox(
      child: Text(
        widget.tour.description,
        style: const TextStyle(
          color: textLightColor,
          fontSize: 16,
        ),
        softWrap: true,
        overflow: TextOverflow.clip,
      ),
    );
  }

  Widget imagesUI() {
    return CarouselSlider(
      items: widget.tour.keyPoints.asMap().entries.map((entry) {
        final index = entry.key;
        final keyPoint = entry.value;
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: const BoxDecoration(color: backgroundColor),
                child: Image.network(
                  widget.tour.type == TourType.secret &&
                          (index >= widget.tour.nextKeyPoint && index != 0)
                      ? "https://i.imgur.com/jibccQd.png"
                      : keyPoint.images[0],
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
        onPageChanged: (index, reason) {
          setState(() {
            _currentCarouselIndex = index;
          });
        },
      ),
    );
  }

  Widget imageSliderUI() {
    return Positioned(
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
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentCarouselIndex == index
                    ? primaryColor
                    : foregroundColor),
          );
        }).toList(),
      ),
    );
  }

  Widget cardUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.tour.keyPoints.asMap().entries.map((entry) {
        final index = entry.key;
        final keyPoint = entry.value;
        bool visited = visitedKeyPoints[index] ?? false;
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
              keypointImage(keyPoint, index),
              const SizedBox(width: 16),
              Expanded(child: keypointInfo(keyPoint, index, visited)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget keypointImage(KeyPoint keyPoint, int index) {
    return CircleAvatar(
      radius: 32.0,
      backgroundColor: secondaryColor,
      child: CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage(
          widget.tour.type == TourType.secret &&
                  (index >= widget.tour.nextKeyPoint && index != 0)
              ? "https://i.imgur.com/jibccQd.png"
              : keyPoint.images[0],
        ),
        backgroundColor: foregroundColor,
        child: Container(
          alignment: Alignment.topLeft,
          child: CircleAvatar(
            radius: 10,
            backgroundColor: primaryColor,
            child: Text(
              "${index + 1}",
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget keypointInfo(KeyPoint keyPoint, int index, bool visited) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.tour.type == TourType.secret &&
                      (index >= widget.tour.nextKeyPoint && index != 0)
                  ? "Secret"
                  : keyPoint.name,
              style: const TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (visited)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.done,
                  color: secondaryColor,
                  size: 20,
                ),
              ),
          ],
        ),
        Text(
          widget.tour.type == TourType.secret &&
                  (index >= widget.tour.nextKeyPoint && index != 0)
              ? "Find out the location to learn more about this keypoint."
              : keyPoint.description,
          style: const TextStyle(
            color: textLighterColor,
            fontSize: 16,
          ),
        ),
      ],
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
