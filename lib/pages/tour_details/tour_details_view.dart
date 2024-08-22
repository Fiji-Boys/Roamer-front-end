import 'package:figenie/consts.dart';
import 'package:figenie/model/key_point.dart';
import 'package:figenie/pages/tour_details/tour_details_controller.dart';
import 'package:figenie/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TourDetailsView extends StatelessWidget {
  final TourDetailController state;
  const TourDetailsView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: foregroundColor,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.35,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double appBarHeight = constraints.biggest.height;
                  final double expandedHeight =
                      MediaQuery.of(context).size.height * 0.5;
                  const double collapsedHeight = kToolbarHeight;

                  final t = (appBarHeight - collapsedHeight) /
                      (expandedHeight - collapsedHeight);
                  final appBarColor =
                      Color.lerp(backgroundColor, backgroundColor, 1 - t);

                  return Container(
                    color: appBarColor,
                    child: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Align(
                        alignment: Alignment(0.0, 1 - (t * 0.7)),
                        child: Text(
                          state.tour.name,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      background: headerUI(context),
                    ),
                  );
                },
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: textColor),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SliverToBoxAdapter(
              child: descriptionUI(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final keyPoint = state.tour.keyPoints[index];
                  return cardUI(context, keyPoint);
                },
                childCount: state.tour.keyPoints.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget headerUI(BuildContext context) {
    final String imageUrl = state.tour.keyPoints.isNotEmpty &&
            state.tour.keyPoints[0].images.isNotEmpty
        ? state.tour.keyPoints[0].images[0]
        : '';

    return Stack(
      fit: StackFit.expand,
      children: [
        if (imageUrl.isNotEmpty)
          Opacity(
            opacity: 0.7,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 50.0), // Spacing for the back button
              // Text(
              //   state.tour.name,
              //   style: const TextStyle(
              //     fontSize: 24.0,
              //     fontWeight: FontWeight.bold,
              //     color: textColor,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              SizedBox(height: 8.0),
              // showOnMapButton(context)
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: textColor,
                  size: 12.0,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Number of keypoints: ${state.tour.keyPoints.length}',
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Points: ${state.tour.points}',
              style: const TextStyle(
                color: secondaryDarkColor,
                fontSize: 13.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget descriptionUI() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Description:",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: secondaryColor,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            state.tour.description,
            style: const TextStyle(
              fontSize: 16.0,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget cardUI(BuildContext context, KeyPoint keyPoint) {
    return CustomCard(
      name: keyPoint.name,
      description: keyPoint.description,
      image: keyPoint.images[0],
      onTap: () {},
      showArrow: false,
    );
  }
}
