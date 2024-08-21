import 'package:figenie/consts.dart';
import 'package:figenie/main.dart';
import 'package:figenie/model/tour.dart';
import 'package:figenie/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:figenie/pages/tour_details/tour_details_controller.dart';
import 'package:figenie/pages/tours/tours_controller.dart';
import 'package:figenie/widgets/search_bar.dart' as search;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ToursView extends StatelessWidget {
  final ToursController state;
  const ToursView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: foregroundColor,
        child: Column(
          children: [
            searchBarUI(context),
            Expanded(
              child: state.filteredTours.isEmpty
                  ? const Center(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(secondaryColor),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: state.filteredTours.length,
                      itemBuilder: (context, index) {
                        final tour = state.filteredTours[index];
                        return cardUI(context, tour);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBarUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: search.SearchBar(
        controller: state.searchController,
        tours: state.tours,
        updateTours: state.setTours,
        onTourTap: (p0) {},
        isMap: false,
      ),
    );
  }

  Widget cardUI(BuildContext context, Tour tour) {
    return CustomCard(
      name: tour.name,
      description: tour.description,
      image: tour.keyPoints[0].images[0],
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TourDetailsPage(
                tour: tour,
                // showOnMap: (value) {
                //   final controller = Get.find<NavigationBarController>();
                //   controller.setNavBarVisibility(false);
                //   controller.selectedIndex.value = 2;

                //   Get.toNamed('/map', arguments: value);
                // },
              ),
            ));
      },
      showArrow: true,
    );
  }
}
