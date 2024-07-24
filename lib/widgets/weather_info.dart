import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _weatherFactory
        .currentWeatherByCityName("Novi Sad")
        .then((weather) => setState(() {
              _weather = weather;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: foregroundColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _weather == null
          ? const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: secondaryColor,
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _weatherIcon(),
                const SizedBox(width: 8.0),
                _currentTemp(),
              ],
            ),
    );
  }

  Widget _weatherIcon() {
    final iconUrl = _weather?.weatherIcon != null
        ? "http://openweathermap.org/img/wn/${_weather!.weatherIcon}@4x.png"
        : null;
    if (iconUrl == null) {
      return const SizedBox.shrink();
    }
    return Positioned(
      child: Image.network(
        iconUrl,
        width: MediaQuery.of(context).size.height * 0.04,
        height: MediaQuery.of(context).size.height * 0.04,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
