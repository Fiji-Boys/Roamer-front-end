import 'package:figenie/model/tour.dart';
import 'package:figenie/services/tour_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:open_route_service/open_route_service.dart';

class OSMapPage extends StatefulWidget {
  const OSMapPage({super.key});

  @override
  State<OSMapPage> createState() => OSMapController();
}

final TourService service = TourService();

class OSMapController extends State<OSMapPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final MapController mapController = MapController();

  LatLng startLoc = const LatLng(45.262501, 19.839263);

  bool isLoading = false;
  List<LatLng> route = <LatLng>[];
  List<Marker> markers = [];

  Future<void> getRoute(LatLng start, LatLng end) async {
    setState(() {
      isLoading = true;
    });

    final OpenRouteService client = OpenRouteService(
      apiKey: '5b3ce3597851110001cf62485df9c89a2209415ba94109717230b279',
    );

    final List<ORSCoordinate> routeCoordinates =
        await client.directionsRouteCoordsGet(
      startCoordinate:
          ORSCoordinate(latitude: start.latitude, longitude: start.longitude),
      endCoordinate:
          ORSCoordinate(latitude: end.latitude, longitude: end.longitude),
    );

    final List<LatLng> routePoints = routeCoordinates
        .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
        .toList();

    setState(() {
      route = routePoints;
      isLoading = false;
    });
  }

  void resetMap() {}
}
