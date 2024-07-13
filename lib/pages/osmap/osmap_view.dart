import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';

import 'package:figenie/consts.dart';
import 'package:figenie/pages/osmap/osmap_controller.dart';
import 'package:latlong2/latlong.dart';

class OSMapView extends StatelessWidget {
  final OSMapController state;
  const OSMapView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        state.resetMap();
        return false;
      },
      child: Stack(
        children: [
          FlutterMap(
            mapController: state.mapController,
            options: const MapOptions(
                initialZoom: 16, initialCenter: LatLng(45.262501, 19.839263)),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
              MarkerLayer(markers: [
                Marker(
                    point: state.currentLoc,
                    width: 40,
                    height: 40,
                    child: state.userIcon)
              ]),
              AnimatedMarkerLayer(
                markers: state.markers.values.toList(),
              ),
              PolylineLayer(
                polylines: state.currentPolylines.values.toList(),
              )
            ],
          )
        ],
      ),
    );
  }
}
