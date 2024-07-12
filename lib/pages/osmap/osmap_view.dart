import 'package:figenie/consts.dart';
import 'package:figenie/pages/osmap/osmap_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

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
            options: MapOptions(zoom: 16, center: state.startLoc),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
              MarkerLayer(markers: state.markers),
              PolylineLayer(
                polylineCulling: false,
                polylines: [
                  Polyline(
                      points: state.route, color: primaryColor, strokeWidth: 5)
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
