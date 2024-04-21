// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:figenie/consts.dart';
import 'package:figenie/model/key_point.dart';
import 'package:figenie/model/tour.dart';
import 'package:figenie/services/tour_service.dart';
import 'package:figenie/widgets/key_poin_modal.dart';
import 'package:figenie/widgets/weather_info.dart';
import 'package:figenie/widgets/loading.dart';
import 'package:figenie/widgets/tour_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:figenie/widgets/tour_completion.dart';
import 'package:vibration/vibration.dart';

final TourService service = TourService();

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final Location _locationController = Location();

  List<Tour> tours = <Tour>[];
  Tour? selectedTour;
  late bool isTourActive = false;
  late bool hasStarted = false;
  late bool hasReachedKeyPoint = false;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng startLoc = LatLng(45.262501, 19.839263);
  LatLng? currentLoc;
  Map<String, Polyline> currentPolylines = {};
  BitmapDescriptor userIcon = BitmapDescriptor.defaultMarker;
  Map<String, Marker> markers = {};

  late ValueNotifier<double> valueNotifier;

  @override
  void initState() {
    super.initState();
    getUserIcon();
    getLocationUpdates();
    getTours();
    valueNotifier = ValueNotifier(0.0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        _resetMap();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            currentLoc == null
                ? const Center(
                    child: Loading(),
                  )
                : GoogleMap(
                    onMapCreated: ((GoogleMapController controller) =>
                        _mapController.complete(controller)),
                    initialCameraPosition: const CameraPosition(
                      target: startLoc,
                      zoom: 13,
                    ),
                    markers: Set<Marker>.of(markers.values),
                    polylines: Set<Polyline>.of(currentPolylines.values),
                    compassEnabled: false,
                    zoomControlsEnabled: false,
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: currentLoc != null
                    ? WeatherInfo(currentLoc: currentLoc!)
                    : Container(
                        color: foregroundColor,
                        height: 50.0,
                      ),
              ),
            ),
            selectedTour == null
                ? Container()
                : TourInfo(
                    tour: selectedTour!,
                    onStartTour: _startTour,
                    valueNotifier: valueNotifier,
                  ),
            selectedTour != null
                ? Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: FloatingActionButton(
                        shape: const CircleBorder(),
                        backgroundColor: foregroundColor,
                        foregroundColor: textColor,
                        child: const Icon(Icons.close),
                        onPressed: () {
                          if (isTourActive) {
                            _showAbandonModal();
                          } else {
                            _resetMap();
                          }
                        },
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Future<void> _getTourMarkers() async {
    for (var tour in tours) {
      markers[tour.name] = Marker(
          markerId: MarkerId(tour.name),
          icon: await getLocationIcon("orange"),
          position: tour.getLocation(),
          zIndex: 10,
          onTap: () {
            _showTour(tour);
          });
    }
    setState(() {});
  }

  void _showTour(Tour tour) {
    showKeypoints(tour);
    _centerMapToBounds(tour.keyPoints);
  }

  void _centerMapToBounds(List<KeyPoint> keyPoints) {
    if (keyPoints.isEmpty) return;

    double minLat = keyPoints.first.latitude;
    double maxLat = keyPoints.first.latitude;
    double minLng = keyPoints.first.longitude;
    double maxLng = keyPoints.first.longitude;

    for (final keyPoint in keyPoints) {
      minLat = min(minLat, keyPoint.latitude);
      maxLat = max(maxLat, keyPoint.latitude);
      minLng = min(minLng, keyPoint.longitude);
      maxLng = max(maxLng, keyPoint.longitude);
    }

    final southWest = LatLng(minLat, minLng);
    final northEast = LatLng(maxLat, maxLng);

    final bounds = LatLngBounds(southwest: southWest, northeast: northEast);

    _mapController.future.then((controller) {
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 130));
    });
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: const TextStyle(
          color: secondaryColor,
        ),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      width: 300,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _resetMap() {
    selectedTour = null;
    _clearMarkers();
    _clearPolylines();
    _getTourMarkers();
  }

  Future<void> showKeypoints(Tour tour) async {
    _clearPolylines();
    _clearMarkers();
    selectedTour = tour;

    for (int i = 0; i < tour.keyPoints.length; i++) {
      final KeyPoint keyPoint = tour.keyPoints[i];
      markers[keyPoint.name] = await _createKeyPointMaker(keyPoint, i);

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

  void _startTour() {
    if (selectedTour == null) throw Exception("Tour not selected");
    selectedTour!.startTour();
    isTourActive = true;
    LatLng nextKeyPointLocation = selectedTour!.getNextKeyPointLocation();
    createPolyline(currentLoc!, nextKeyPointLocation, "user", primaryColor);
    _keypointCheck();
    _mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
            currentLoc!, 15), // Adjust zoom level as needed
      );
    });
  }

  void _clearMarkers() {
    markers.clear();
    markers["_currentLocation"] = Marker(
        markerId: const MarkerId("_currentLocation"),
        icon: userIcon,
        position: currentLoc!,
        zIndex: 1);
  }

  void _clearPolylines() {
    currentPolylines.clear();
  }

  void getTours() {
    tours = service.getAll();
    _getTourMarkers();
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen(
      (LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          final newLoc =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _setUserMarker(newLoc);
          if (currentLoc != newLoc) {
            setState(
              () {
                currentLoc = newLoc;
                if (isTourActive && selectedTour != null) {
                  _keypointCheck();

                  if (selectedTour!.isCompleted) {
                    _completeTour();
                    return;
                  }

                  if (selectedTour!.type == TourType.secret &&
                      selectedTour!.nextKeyPoint != 0) {
                    return;
                  }

                  createPolyline(
                      currentLoc!,
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

  void _setUserMarker(LatLng loc) {
    markers["_currentLocation"] = Marker(
        markerId: const MarkerId("_currentLocation"),
        icon: userIcon,
        position: loc,
        zIndex: 1);
  }

  void _showAbandonModal() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: foregroundColor,
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
              _abandonTour();
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

  void _abandonTour() {
    selectedTour!.abandonTour();
    isTourActive = false;
    selectedTour = null;
    hasReachedKeyPoint = false;
    valueNotifier.value = 0;
    _resetMap();
  }

  void _completeTour() {
    debugPrint("COMPLETED");
    showDialog(
      context: context,
      builder: (context) => const CongratulationsModal(),
    );
    isTourActive = false;
    selectedTour = null;
    valueNotifier.value = 0;
    _resetMap();
  }

  void _completeKeyPoint() {
    if (selectedTour!.nextKeyPoint + 1 < selectedTour!.keyPoints.length) {
      if (selectedTour!.nextKeyPoint == 0) {
        deleteRoute("user");
      } else {
        deleteRoute(
            "${selectedTour!.keyPoints[selectedTour!.nextKeyPoint].name}/${selectedTour!.keyPoints[selectedTour!.nextKeyPoint + 1].name}");
      }
    }
    deleteKeyPoint(selectedTour!.keyPoints[selectedTour!.nextKeyPoint].name);
    selectedTour!.completeKeyPoint();
    hasReachedKeyPoint = false;
    valueNotifier.value =
        selectedTour!.nextKeyPoint * 100 / selectedTour!.keyPoints.length;
  }

  void _keypointCheck() {
    if (!hasReachedKeyPoint) {
      if (calculateDistance()) {
        _vibrate();
        hasReachedKeyPoint = true;
        if (selectedTour!.nextKeyPoint != 0 &&
            selectedTour!.type == TourType.secret) {
          return;
        }
        _changeNextKeypointMarker(
            selectedTour!.keyPoints[selectedTour!.nextKeyPoint]);
      }
    }
  }

  void _showKeyPoint(KeyPoint keyPoint) {
    showDialog(
        context: context,
        builder: (_) => KeyPointModal(
              keyPoint: keyPoint,
              onComplete: _completeKeyPoint,
            ));
  }

  void _vibrate() async {
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

  void createPolyline(LatLng source, LatLng dest, String polylineId,
      Color polyLineColor) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleMapsApiKey,
        PointLatLng(source.latitude, source.longitude),
        PointLatLng(dest.latitude, dest.longitude),
        travelMode: TravelMode.walking);

    List<LatLng> polylineCoords = [];

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoords.add(LatLng(point.latitude, point.longitude));
      }
      setState(() {
        currentPolylines[polylineId] = Polyline(
            polylineId: PolylineId(polylineId),
            points: polylineCoords,
            width: 6,
            color: polyLineColor);
      });
    }
  }

  void createPolylineLocal(LatLng source, LatLng dest, String polylineId,
      Color polyLineColor) async {
    final response = await http.post(
      Uri.parse("http://192.168.1.9:8086/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{"pos": source, "dest": dest},
      ),
    );

    if (response.statusCode != 200) throw Exception("Failed to create route");
    final list = jsonDecode(response.body) as List;
    debugPrint(list.toString());
    final points = list.map((e) => e.cast<double>()).toList();

    List<LatLng> polylineCoords = [];
    for (var point in points) {
      polylineCoords.add(LatLng(point[0], point[1]));
    }
    setState(() {
      currentPolylines[polylineId] = Polyline(
          polylineId: PolylineId(polylineId),
          points: polylineCoords,
          width: 6,
          color: polyLineColor);
    });
  }

  Future<BitmapDescriptor> getLocationIcon(String color,
      {int size = 180}) async {
    ByteData byteData;
    byteData =
        await DefaultAssetBundle.of(context).load("assets/${color}_marker.png");
    ui.Codec codec = await ui.instantiateImageCodec(
        byteData.buffer.asUint8List(),
        targetWidth: size);
    ui.FrameInfo fi = await codec.getNextFrame();
    final icon = BitmapDescriptor.fromBytes(
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List());

    return icon;
  }

  void getUserIcon() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/user_marker.png");
    ui.Codec codec = await ui
        .instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: 150);
    ui.FrameInfo fi = await codec.getNextFrame();
    final icon = BitmapDescriptor.fromBytes(
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List());
    setState(() {
      userIcon = icon;
    });
  }

  bool calculateDistance() {
    var p = 0.017453292519943295;
    var c = cos;
    if (selectedTour == null) throw Exception("Tour not selected");
    LatLng nextKeyPointLocation = selectedTour!.getNextKeyPointLocation();
    var a = 0.5 -
        c((nextKeyPointLocation.latitude - currentLoc!.latitude) * p) / 2 +
        c(currentLoc!.latitude * p) *
            c(nextKeyPointLocation.latitude * p) *
            (1 -
                c((nextKeyPointLocation.longitude - currentLoc!.longitude) *
                    p)) /
            2;
    double distance = 1000 * 12742 * asin(sqrt(a));
    debugPrint(distance.toString());
    return distance < 100;
  }

  void deleteKeyPoint(String currentKeyPoint) async {
    markers[currentKeyPoint] = Marker(
      markerId: MarkerId("${currentKeyPoint}_completed"),
      icon: await getLocationIcon("gray"),
      position: markers[currentKeyPoint]!.position,
      zIndex: 10,
    );
    // markers.remove(currentKeyPoint);
  }

  void deleteRoute(String route) {
    currentPolylines.remove(route);
  }

  _changeNextKeypointMarker(KeyPoint keyPoint) async {
    markers[keyPoint.name] = Marker(
      markerId: MarkerId(keyPoint.name),
      icon: await getLocationIcon("blue_active", size: 200),
      position: keyPoint.getLocation(),
      zIndex: 10,
      onTap: () {
        _showKeyPoint(keyPoint);
      },
    );
  }

  Future<Marker> _createKeyPointMaker(
    KeyPoint keyPoint,
    int order,
  ) async {
    return Marker(
      markerId: MarkerId(keyPoint.name),
      icon: order == 0
          ? await getLocationIcon("blue")
          : await getLocationIcon("orange"),
      position: keyPoint.getLocation(),
      zIndex: 10,
    );
  }
}
