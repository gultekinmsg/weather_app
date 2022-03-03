import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';

class WeatherAPIClient {
  String baseUrl =
      'http://api.openweathermap.org/data/2.5/weather?appid=8598c1b0b4e91b68974101d97a10552b';
  http.Client httpClient;

  WeatherAPIClient({@required this.httpClient}) : assert(httpClient != null);

  Future<Weather> getWeather(String city) async {
    var locationUrl = '$baseUrl&q=$city';

    var locationResponse = await httpClient.get(locationUrl);
    if (locationResponse.statusCode != 200) {
      throw Exception('Error getting weather info');
    }
    final weatherJson = jsonDecode(locationResponse.body);
    return Weather.fromJson(weatherJson);
  }
}
