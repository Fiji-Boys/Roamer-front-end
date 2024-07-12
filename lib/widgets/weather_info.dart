// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';

import 'package:figenie/consts.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather/weather.dart';

class WeatherInfo extends StatefulWidget {
  final LatLng currentLoc;

  const WeatherInfo({super.key, required this.currentLoc});

  @override
  State<WeatherInfo> createState() => _WeatherInfo();
}

class _WeatherInfo extends State<WeatherInfo> {
  final WeatherFactory _weatherFactory = WeatherFactory(weatherApiKey);

  Weather? _weather;
  // late String _city;

  @override
  void initState() {
    super.initState();
    // fetchCity(widget.currentLoc).then((city) => setState(() {
    //       _city = city;
    //     }));
    _weatherFactory
        .currentWeatherByCityName("Novi Sad")
        .then((weather) => setState(() {
              _weather = weather;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: secondaryColor,
        ),
      );
    }

    // Container takes up the full width of the screen
    return Container(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(10.0),
      // ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        // color: primaryContentColor.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on,
                color: textColor,
                size: 20,
                shadows: <Shadow>[
                  Shadow(
                    blurRadius: 9.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
              _locationHeader(),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [_weatherIcon(), _currentTemp()],
          ),
        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        shadows: <Shadow>[
          Shadow(
            blurRadius: 7.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ],
      ),
    );
  }

  Widget _weatherIcon() {
    // Ensure that _weather is not null and has a valid weatherIcon value
    final iconUrl = _weather?.weatherIcon != null
        ? "http://openweathermap.org/img/wn/${_weather!.weatherIcon}@4x.png"
        : null;

    // If there is no valid icon URL, we don't want to display the container
    if (iconUrl == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                child: Image.network(
                  iconUrl,
                  width: MediaQuery.of(context).size.height * 0.055,
                  height: MediaQuery.of(context).size.height * 0.055,
                  color: Colors.black.withOpacity(0.3),
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
              Positioned(
                child: Image.network(
                  iconUrl,
                  width: MediaQuery.of(context).size.height * 0.05,
                  height: MediaQuery.of(context).size.height * 0.05,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(
        color: textColor,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        shadows: <Shadow>[
          Shadow(
            blurRadius: 8.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ],
      ),
    );
  }
}

// Future<String> fetchCity(LatLng currentLoc) async {
//   List<Placemark> placemarks = await placemarkFromCoordinates(
//       currentLoc.latitude, currentLoc.longitude);
//   return placemarks[0].locality!;
// }
