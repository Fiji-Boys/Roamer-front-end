import 'package:figenie/model/tour.dart';
import 'package:figenie/pages/tours/tours_view.dart';
import 'package:figenie/services/tour_service.dart';
import 'package:flutter/material.dart';

class ToursPage extends StatefulWidget {
  const ToursPage({super.key});

  @override
  State<ToursPage> createState() => ToursController();
}

final TourService service = TourService();

class ToursController extends State<ToursPage> {
  late final TextEditingController searchController;
  List<Tour> tours = []; // Initialize with your tour data
  List<Tour> filteredTours = [];

  @override
  Widget build(BuildContext context) {
    return ToursView(this);
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    getTours();
  }

  void getTours() {
    tours = service.getAll();
    filteredTours = tours;
  }

  void setTours(tourList) {
    setState(() {
      filteredTours = tourList;
    });
  }

  // void filterTours(String query) {
  //   if (query.isEmpty) {
  //     setState(() {
  //       filteredTours = [];
  //     });
  //   } else {
  //     setState(() {
  //       filteredTours = tours
  //           .where(
  //               (tour) => tour.name.toLowerCase().contains(query.toLowerCase()))
  //           .toList();
  //     });
  //   }
  // }

  // void clearSearch() {
  //   searchController.clear();
  //   filteredTours = [];
  // }
}
