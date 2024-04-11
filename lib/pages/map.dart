import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:figenie/consts.dart';
import 'package:figenie/model/key_point.dart';
import 'package:figenie/model/tour.dart';
import 'package:figenie/utils/weather_menu.dart';
import 'package:figenie/widgets/loading.dart';
import 'package:figenie/widgets/tour_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

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

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng startLoc = LatLng(45.262610, 19.838718);
  LatLng? currentLoc;

  Map<String, Polyline> currentPolylines = {};

  BitmapDescriptor userIcon = BitmapDescriptor.defaultMarker;

  Map<String, Marker> markers = {};

  @override
  void initState() {
    super.initState();
    getUserIcon();
    getLocationUpdates();
    getTours();
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
                  ),
            selectedTour == null ? Container() : TourInfo(tour: selectedTour!),
            selectedTour != null && !isTourActive
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
                          _resetMap();
                        },
                      ),
                    ))
                : Container()
          ],
        ),
      ),
    );
  }

  void _getTourMarkers() {
    for (var tour in tours) {
      markers[tour.name] = Marker(
          markerId: MarkerId(tour.name),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          position: tour.getLocation(),
          onTap: () {
            _showTour(tour);
          });
    }
    setState(() {});
  }

  void _showTour(Tour tour) {
    showKeypoints(tour);
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

  void showKeypoints(Tour tour) {
    _clearPolylines();
    _clearMarkers();
    selectedTour = tour;
    for (int i = 0; i < tour.keyPoints.length; i++) {
      markers[tour.keyPoints[i].name] = Marker(
        markerId: MarkerId(tour.keyPoints[i].name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        position: tour.keyPoints[i].getLocation(),
        onTap: () {
          _showKeyPoint(tour.keyPoints[i]);
        },
      );
      if (i != tour.keyPoints.length - 1) {
        createPolyline(
          tour.keyPoints[i].getLocation(),
          tour.keyPoints[i + 1].getLocation(),
          "${tour.keyPoints[i].name}/${tour.keyPoints[i + 1].name}",
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
    createPolyline(currentLoc!, selectedTour!.getNextKeyPointLocation(), "user",
        primaryColor);
  }

  void _showKeyPoint(KeyPoint kp) {
    // Ovde nesto da se desi kada se stisne keypoint
  }

  void _clearMarkers() {
    markers.clear();
    markers["_currentLocation"] = Marker(
        markerId: const MarkerId("_currentLocation"),
        icon: userIcon,
        position: currentLoc!,
        zIndex: 100);
  }

  void _clearPolylines() {
    currentPolylines.clear();
  }

  void getTours() {
    List<KeyPoint> keyPoints = [
      KeyPoint(
          id: 1,
          name: "Sima",
          description: "Description of Sima",
          images: ["image1.jpg", "image2.jpg"],
          latitude: 45.262501,
          longitude: 19.839263),
      KeyPoint(
          id: 2,
          name: "Vruce kifle",
          description: "Description of Vruce kifle",
          images: ["image3.jpg", "image4.jpg"],
          latitude: 45.255452,
          longitude: 19.841251),
    ];
    List<KeyPoint> keyPoints2 = [
      KeyPoint(
          id: 3,
          name: "Univer",
          description: "Description of Univer",
          images: ["image1.jpg", "image2.jpg"],
          latitude: 45.253334,
          longitude: 19.844478),
      KeyPoint(
          id: 4,
          name: "Burgija",
          description: "Description of Burgija",
          images: ["image3.jpg", "image4.jpg"],
          latitude: 45.239358,
          longitude: 19.850856),
    ];
    List<KeyPoint> keyPoints3 = [
      KeyPoint(
          id: 5,
          name: "NTP",
          description: "Description of NTP",
          images: ["image1.jpg", "image2.jpg"],
          latitude: 45.244923,
          longitude: 19.847757),
      KeyPoint(
          id: 6,
          name: "Turbo kruzni",
          description: "Description of Turbo",
          images: ["image3.jpg", "image4.jpg"],
          latitude: 45.244777,
          longitude: 19.84679),
      KeyPoint(
          id: 7,
          name: "Tocionica",
          description: "Description of Turbo kruzni",
          images: ["image3.jpg", "image4.jpg"],
          latitude: 45.24262,
          longitude: 19.846887),
      KeyPoint(
          id: 8,
          name: "Iza ugla",
          description: "Description of Tocionica",
          images: ["image3.jpg", "image4.jpg"],
          latitude: 45.242733,
          longitude: 19.849508),
      KeyPoint(
          id: 9,
          name: "NTP opet",
          description: "Description of NTP opet",
          images: ["image3.jpg", "image4.jpg"],
          latitude: 45.244368,
          longitude: 19.848467),
    ];

    List<KeyPoint> keyPoints4 = [
      KeyPoint(
          id: 5,
          name: "Sumnjivo dvoriste",
          description: "Setam samo sa osobama zenskog pola",
          images: ["image1.jpg", "image2.jpg"],
          latitude: 45.244085,
          longitude: 19.852904),
    ];

    Tour newTour = Tour(
        name: "Put do kifli",
        description: "Najbrzi put do vrucih(mozda) kifli",
        keyPoints: keyPoints);
    Tour newTour2 = Tour(
        name: "Poseta burice",
        description: "Do mog dragog brata",
        keyPoints: keyPoints2);
    Tour newTour3 = Tour(
        name: "Setnja sa Luburom",
        description: "Sa nasim dragim profesorom",
        keyPoints: keyPoints3);
    Tour newTour4 = Tour(
        name: "Sumnjivo dvoriste na limanu",
        description: "Easter egg tura",
        keyPoints: keyPoints4);
    tours.add(newTour);
    tours.add(newTour2);
    tours.add(newTour3);
    tours.add(newTour4);
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

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(
          () {
            final newLoc =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            if (currentLoc != newLoc) {
              currentLoc = newLoc;
              if (isTourActive && selectedTour != null) {
                if (calculateDistance()) {
                  if (selectedTour!.nextKeyPoint + 1 <
                      selectedTour!.keyPoints.length) {
                    deleteRoute(
                        "${selectedTour!.keyPoints[selectedTour!.nextKeyPoint].name}/${selectedTour!.keyPoints[selectedTour!.nextKeyPoint + 1].name}");
                  }
                  deleteKeyPoint(
                      selectedTour!.keyPoints[selectedTour!.nextKeyPoint].name);
                  showSnackBar(context,
                      "Completed key point ${selectedTour!.keyPoints[selectedTour!.nextKeyPoint].name}");
                  selectedTour!.completeKeyPoint();
                }

                if (selectedTour!.isCompleted) {
                  debugPrint("COMPLETED");
                  showSnackBar(context, "Completed tour ${selectedTour!.name}");
                  isTourActive = false;
                  return;
                }
                createPolyline(
                    currentLoc!,
                    selectedTour!.getNextKeyPointLocation(),
                    "user",
                    primaryColor);
              }
              markers["_currentLocation"] = Marker(
                  markerId: const MarkerId("_currentLocation"),
                  icon: userIcon,
                  position: currentLoc!,
                  zIndex: 100);
            }
          },
        );
      }
    });
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
    return distance < 40;
  }

  void deleteKeyPoint(String currentKeyPoint) {
    markers.remove(currentKeyPoint);
  }

  void deleteRoute(String route) {
    currentPolylines.remove(route);
  }
}
