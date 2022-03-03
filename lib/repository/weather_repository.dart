import 'package:flutter/cupertino.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/repository/weather_api_client.dart';

class WeatherRepository {
  WeatherAPIClient weatherAPIClient;
  WeatherRepository({@required this.weatherAPIClient})
      : assert(weatherAPIClient != null);

  Future<Weather> getWeather(String city) {
        print("city" + city);
        print( weatherAPIClient);


    return weatherAPIClient.getWeather(city);
  }
}
