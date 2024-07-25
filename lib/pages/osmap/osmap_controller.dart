import 'dart:math';

import 'package:figenie/model/user.dart' as model_user;
import 'package:figenie/services/user_service.dart';
import 'package:figenie/widgets/keypoint_completion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:vibration/vibration.dart';

import 'package:figenie/consts.dart';
import 'package:figenie/main.dart';
import 'package:figenie/model/key_point.dart';
import 'package:figenie/model/tour.dart';
import 'package:figenie/pages/osmap/osmap_view.dart';
import 'package:figenie/services/tour_service.dart';
import 'package:figenie/widgets/tour_completion.dart';

class OSMapPage extends StatefulWidget {
  const OSMapPage({super.key});

  @override
  State<OSMapPage> createState() => OSMapController();
}

final TourService service = TourService();
final NavigationBarController navBarController = Get.find();

class OSMapController extends State<OSMapPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final Location locationController = Location();
  late final AnimatedMapController mapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late model_user.User _user;
  final UserService userService = UserService();

  late ValueNotifier<double> valueNotifier;

  LatLng currentLoc = const LatLng(45.262501, 19.839263);

  List<Tour> tours = <Tour>[];
  Tour? selectedTour;
  KeyPoint? selectedKeypoint;
  late bool isTourActive = false;
  late bool hasReachedKeyPoint = false;

  bool isLoading = false;
  Image userIcon = const Image(image: AssetImage("assets/user_marker.png"));
  AssetImage blueMarker = const AssetImage("assets/blue_marker.png");
  AssetImage grayMarker = const AssetImage("assets/gray_marker.png");
  AssetImage greenMarker = const AssetImage("assets/green_marker.png");
  AssetImage orangeMarker = const AssetImage("assets/orange_marker.png");
  AssetImage blueMarkerActive =
      const AssetImage("assets/blue_active_marker.png");
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
    getTours();
    setUser();
    valueNotifier = ValueNotifier(0.0);
  }

  Future<void> setUser() async {
    if (_auth.currentUser != null) {
      _user = (await userService.getById(_auth.currentUser!.uid));
    }
  }

  void getTours() async {
    final tourList = await service.getAll();
    setState(() {
      tours = tourList;
      getTourMarkers();
    });
  }

  Future<void> getTourMarkers() async {
    for (var tour in tours) {
      markers[tour.name] =
          createMarker(tour.getLocation(), () => showTour(tour), orangeMarker);
    }
  }

  void showTour(Tour tour) {
    showKeypoints(tour);
    centerMapToBounds(tour);
  }

  Future<void> showKeypoints(Tour tour) async {
    clearPolylines();
    clearMarkers();
    selectedTour = tour;

    for (int i = 0; i < tour.keyPoints.length; i++) {
      final KeyPoint keyPoint = tour.keyPoints[i];
      markers[keyPoint.name] = await createKeyPointMarker(keyPoint, i);

      if (selectedTour!.type == TourType.secret) {
        break;
      }

      if (i != tour.keyPoints.length - 1) {
        createPolyline(
          keyPoint.getLocation(),
          tour.keyPoints[i + 1].getLocation(),
          "${keyPoint.name}/${tour.keyPoints[i + 1].name}",
          secondaryColor,
        );
      }
    }

    setState(() {});
  }

  void clearMarkers() {
    setState(() {
      markers.clear();
    });
  }

  void clearPolylines() {
    setState(() {
      currentPolylines.clear();
    });
  }

  Future<AnimatedMarker> createKeyPointMarker(
    KeyPoint keyPoint,
    int order,
  ) async {
    return createMarker(keyPoint.getLocation(), () => {},
        order == 0 ? blueMarker : orangeMarker);
  }

  void centerMapToBounds(Tour tour) {
    List<KeyPoint> keyPoints = tour.keyPoints;
    if (keyPoints.isEmpty) return;

    double minLat = keyPoints.first.latitude;
    double maxLat = keyPoints.first.latitude;
    double minLng = keyPoints.first.longitude;
    double maxLng = keyPoints.first.longitude;

    if (tour.type == TourType.secret) {
      LatLng firstKeyPointLocation = keyPoints.first.getLocation();
      mapController.centerOnPoint(firstKeyPointLocation, zoom: 16.0);
      return;
    }

    for (final keyPoint in keyPoints) {
      minLat = min(minLat, keyPoint.latitude);
      maxLat = max(maxLat, keyPoint.latitude);
      minLng = min(minLng, keyPoint.longitude);
      maxLng = max(maxLng, keyPoint.longitude);
    }

    final southWest = LatLng(minLat, minLng);
    final northEast = LatLng(maxLat, maxLng);

    final bounds = LatLngBounds(southWest, northEast);

    mapController.animatedFitCamera(
      cameraFit:
          CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(24)),
    );
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
                  keypointCheck();

                  if (selectedTour!.type == TourType.secret &&
                      selectedTour!.nextKeyPoint != 0) {
                    return;
                  }

                  createPolyline(
                      currentLoc,
                      selectedTour!.getNextKeyPointLocation(),
                      "user",
                      primaryColor);
                }
              },
            );
          }
        }
      },
    );
  }

  void keypointCheck() {
    if (!hasReachedKeyPoint) {
      if (calculateDistance()) {
        vibrate();
        hasReachedKeyPoint = true;
        activateKeyPoint(selectedTour!.keyPoints[selectedTour!.nextKeyPoint]);
      }
    }
  }

  activateKeyPoint(KeyPoint keyPoint) async {
    setState(() {
      markers[keyPoint.name] = createMarker(keyPoint.getLocation(),
          () => showKeyPoint(keyPoint), blueMarkerActive);
    });
  }

  setNextKeyPoint(KeyPoint keyPoint) async {
    setState(() {
      markers[keyPoint.name] =
          createMarker(keyPoint.getLocation(), () => {}, blueMarker);
    });
  }

  void showKeyPoint(KeyPoint keyPoint) {
    setState(() {
      selectedKeypoint = keyPoint;
    });
  }

  void vibrate() async {
    if (await Vibration.hasVibrator() != null) {
      Vibration.vibrate(pattern: [
        0,
        200,
        100,
        500,
        100,
        800,
        100,
        100,
        100,
        100,
        100,
        100,
        100,
        300
      ], amplitude: 255);
    }
  }

  bool calculateDistance() {
    var p = 0.017453292519943295;
    var c = cos;
    if (selectedTour == null) throw Exception("Tour not selected");
    LatLng nextKeyPointLocation = selectedTour!.getNextKeyPointLocation();
    var a = 0.5 -
        c((nextKeyPointLocation.latitude - currentLoc.latitude) * p) / 2 +
        c(currentLoc.latitude * p) *
            c(nextKeyPointLocation.latitude * p) *
            (1 -
                c((nextKeyPointLocation.longitude - currentLoc.longitude) *
                    p)) /
            2;
    double distance = 1000 * 12742 * asin(sqrt(a));
    debugPrint(distance.toString());
    return distance < 50000;
  }

  Future<void> createPolyline(
      LatLng start, LatLng end, String polylineId, Color polyLineColor) async {
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
      currentPolylines[polylineId] =
          Polyline(points: routePoints, strokeWidth: 5, color: polyLineColor);
      isLoading = false;
    });
  }

  void completeKeyPoint() {
    if (selectedTour!.nextKeyPoint + 1 < selectedTour!.keyPoints.length) {
      if (selectedTour!.nextKeyPoint == 0) {
        deleteRoute("user");
      }
      deleteRoute(
          "${selectedTour!.keyPoints[selectedTour!.nextKeyPoint].name}/${selectedTour!.keyPoints[selectedTour!.nextKeyPoint + 1].name}");

      showKeypointCompletedModal();
    }
    deleteKeyPoint(selectedTour!.keyPoints[selectedTour!.nextKeyPoint].name);
    selectedTour!.completeKeyPoint();
    hasReachedKeyPoint = false;

    valueNotifier.value =
        selectedTour!.nextKeyPoint * 100 / selectedTour!.keyPoints.length;

    if (selectedTour!.type != TourType.secret && !selectedTour!.isCompleted) {
      createPolyline(currentLoc, selectedTour!.getNextKeyPointLocation(),
          "user", primaryColor);
      setNextKeyPoint(selectedTour!.keyPoints[selectedTour!.nextKeyPoint]);
    }

    selectedKeypoint = null;
    if (selectedTour!.isCompleted) {
      if (!_user.completedTours.any((tour) => tour.id == selectedTour!.id)) {
        userService.completeTour(_user, selectedTour!);
      }
      completeTour();
    }
  }

  void showKeypointCompletedModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CompletedKeypointModal(
        onAnimationCompleted: () {
          Navigator.of(context).pop(); // Close the dialog
        },
      ),
    );
  }

  void goBack() {
    setState(() {
      selectedKeypoint = null;
    });
  }

  void deleteRoute(String route) {
    currentPolylines.remove(route);
  }

  void deleteKeyPoint(String currentKeyPoint) async {
    setState(() {
      markers[currentKeyPoint] =
          createMarker(markers[currentKeyPoint]!.point, () => {}, grayMarker);
    });
  }

  void completeTour() {
    showDialog(
      context: context,
      builder: (context) => const CongratulationsModal(),
    ).then((value) {
      setState(() {
        isTourActive = false;
        selectedTour = null;
        hasReachedKeyPoint = false;
        resetMap();
        navBarController.setNavBarVisibility(true);
      });
      valueNotifier.value = 0;
    });
  }

  void showAbandonModal() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        contentTextStyle: const TextStyle(color: textLightColor, fontSize: 16),
        title: const Text(
          'Abandon Tour',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: textColor, fontSize: 20),
        ),
        content: const Text('Are you sure you want to abandon the tour?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'No',
              style: TextStyle(
                  decorationColor: borderColor,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                  fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              abandonTour();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void abandonTour() {
    navBarController.setNavBarVisibility(true);
    selectedTour!.abandonTour();
    isTourActive = false;
    selectedTour = null;
    hasReachedKeyPoint = false;
    valueNotifier.value = 0;
    resetMap();
  }

  void startTour() {
    if (selectedTour == null) throw Exception("Tour not selected");
    selectedTour!.startTour();
    isTourActive = true;
    navBarController.setNavBarVisibility(false);
    hasReachedKeyPoint = false;
    LatLng nextKeyPointLocation = selectedTour!.getNextKeyPointLocation();
    createPolyline(currentLoc, nextKeyPointLocation, "user", primaryColor);
    keypointCheck();
    mapController.animateTo(
        dest: currentLoc, zoom: mapController.mapController.camera.zoom);
  }

  void resetMap() {
    setState(() {
      selectedTour = null;
    });
    clearMarkers();
    clearPolylines();
    getTourMarkers();
  }

  AnimatedMarker createMarker(
      LatLng point, Function()? onTap, ImageProvider image) {
    return AnimatedMarker(
      point: point,
      width: 60,
      height: 60,
      duration: const Duration(milliseconds: 600),
      builder: (_, animation) {
        final size = 60.0 * animation.value;
        return GestureDetector(
          onTap: onTap,
          child: Image(
            image: image,
            width: size,
            height: size,
          ),
        );
      },
    );
  }
}
