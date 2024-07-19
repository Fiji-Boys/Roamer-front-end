
class MarkerUtils {
  // Function to create custom marker icon with a number
  // static Future<BitmapDescriptor> createCustomMarkerIcon(int number) async {
  //   final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  //   final Canvas canvas = Canvas(pictureRecorder);
  //   final TextPainter textPainter = TextPainter(
  //     text: TextSpan(
  //       text: number.toString(),
  //       style: const TextStyle(color: Colors.white, fontSize: 20),
  //     ),
  //     textDirection: TextDirection.ltr,
  //   );
  //   textPainter.layout();
  //   textPainter.paint(canvas, const Offset(0, 0));
  //   final ui.Image image = await pictureRecorder.endRecording().toImage(50, 50);
  //   final ByteData? byteData =
  //       await image.toByteData(format: ui.ImageByteFormat.png);
  //   if (byteData != null) {
  //     return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
  //   } else {
  //     throw Exception("Failed to convert image to byte data.");
  //   }
  // }

  // // Function to generate markers with numbers for each keypoint
  // static Future<Map<String, Marker>> generateMarkersWithNumbers(
  //     List<KeyPoint> keyPoints) async {
  //   Map<String, Marker> markers = {};
  //   for (int i = 0; i < keyPoints.length; i++) {
  //     final KeyPoint keyPoint = keyPoints[i];
  //     final BitmapDescriptor icon = await createCustomMarkerIcon(
  //         i + 1); // Create custom marker icon with number
  //     final Marker marker = Marker(
  //       markerId: MarkerId(keyPoint.name),
  //       icon: icon,
  //       position: keyPoint.getLocation(),
  //       onTap: () {
  //         // Handle marker tap event if needed
  //       },
  //     );
  //     markers[keyPoint.name] = marker;
  //   }
  //   return markers;
  // }
}
