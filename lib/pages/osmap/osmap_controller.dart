import 'package:figenie/model/tour.dart';
import 'package:figenie/pages/osmap/osmap_view.dart';
import 'package:figenie/services/tour_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
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

  final Location locationController = Location();
  final MapController mapController = MapController();

  LatLng currentLoc = const LatLng(45.262501, 19.839263);

  List<Tour> tours = <Tour>[];
  Tour? selectedTour;
  late bool isTourActive = false;
  late bool hasStarted = false;
  late bool hasReachedKeyPoint = false;

  bool isLoading = false;
  Image userIcon = const Image(image: AssetImage("assets/user_marker.png"));
  Map<String, Polyline> currentPolylines = {};
  Map<String, AnimatedMarker> markers = {};

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return OSMapView(this);
  }

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    // getTours();
    // valueNotifier = ValueNotifier(0.0);
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen(
      (LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          final newLoc =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          if (currentLoc != newLoc) {
            setState(
              () {
                currentLoc = newLoc;
                if (isTourActive && selectedTour != null) {
                  // keypointCheck();

                  if (selectedTour!.type == TourType.secret &&
                      selectedTour!.nextKeyPoint != 0) {
                    return;
                  }

                  // createPolyline(
                  //     currentLoc!,
                  //     selectedTour!.getNextKeyPointLocation(),
                  //     "user",
                  //     primaryColor,
                  //     zIndex: 2);
                }
              },
            );
          }
        }
      },
    );
  }

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
      // route = routePoints;
      isLoading = false;
    });
  }

  void resetMap() {}
}
