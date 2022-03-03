import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/bloc/weather_events.dart';
import 'package:weather_app/bloc/weather_states.dart';
import 'package:weather_app/models/weather.dart';

final weatherCityController = TextEditingController();

class WeatherView extends StatefulWidget {
  const WeatherView({Key key}) : super(key: key);

  @override
  State<WeatherView> createState() => _WeatherState();
}

Completer<void> _refreshCompleter;

class _WeatherState extends State<WeatherView> {
  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

    return Scaffold(
      backgroundColor: const Color(0xff00001f),
      body: BlocConsumer<WeatherBloc, WeatherStates>(
        listener: (context, WeatherStates state) {
          if (state is WeatherLoaded) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        builder: (context, WeatherStates state) {
          print(context);
          print(state);
          if (state is WeatherEmpty) {
            return const EnterCity();
          } else if (state is WeatherLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WeatherLoaded) {
            final weather = state.weather;
            return RefreshIndicator(
              onRefresh: () {
                BlocProvider.of<WeatherBloc>(context)
                    .add(RefreshWeather(city: weather.location));
                return _refreshCompleter.future;
              },
              child: ListView(
                children: <Widget>[
                  DisplayWeather(
                    weather: weather,
                  ),
                ],
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(left: 35.0, right: 30),
                  child: Text(
                    'Could not fetch weather for the given location',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
                  },
                  child: const InkWell(
                    child: Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            );
          }
        },
      ),
    );
  }
}

class EnterCity extends StatelessWidget {
  const EnterCity({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.blueAccent[100],
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40))),
              child: const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: Text(
                      'Search for Weather',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32),
              child: TextFormField(
                  controller: weatherCityController,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.light,
                  enableSuggestions: true,
                  textInputAction: TextInputAction.search,
                  validator: (value) {
                    if (value.isEmpty) return 'Enter City Name';
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Enter City Name',
                      focusColor: Colors.blueAccent[100],
                      alignLabelWithHint: true,
                      hintText: 'Eg London',
                      prefixIcon: const Icon(Icons.location_on),
                      helperText:
                          'Enter the location for which you want to search')),
            ),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  print("weatherCityController.text"+weatherCityController.text);
                  BlocProvider.of<WeatherBloc>(context)
                      .add(FetchWeather(city: weatherCityController.text));
                }
              },
              color: Colors.blueAccent[100],
              splashColor: Colors.black,
              padding: const EdgeInsets.only(left: 32, right: 32),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: BorderSide(color: Colors.blueAccent[100])),
              child: const Padding(
                padding: EdgeInsets.only(left: 32, right: 32),
                child: Text('Search',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            const Spacer(),
            const SafeArea(
              child: Text('This app is a demo app for Flutter Bloc Pattern'),
            )
          ],
        ),
      ),
    );
  }
}

class DisplayWeather extends StatelessWidget {
  final Weather weather;
  final DateTime now = DateTime.now();

  DisplayWeather({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 80, left: 20),
                    child: Text(
                      weather.location,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20),
                    child: Text(
                      DateFormat('EEEE MMMM d, yyyy hh:mm a').format(now),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 65, right: 20),
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
                  },
                  child: const InkWell(
                    child: Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                const Spacer(),
                Image.network(
                  'http://openweathermap.org/img/wn/' +
                      weather.icon +
                      '@2x.png',
                  scale: 0.8,
                  color: Colors.white,
                ),
                const Spacer()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                const Spacer(),
                Text(
                  (weather.currentTemp - 275.5).floor().toString() + '°',
                  style: const TextStyle(
                      fontSize: 70, fontWeight: FontWeight.w400),
                ),
                const Spacer()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                const Spacer(),
                Text(
                  weather.condition,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                const Spacer()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 55, left: 30, right: 30),
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      weather.windSpeed.toString() + 'km/h',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Wind',
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  children: <Widget>[
                    Text(
                      weather.humidity.toString() + '%',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Humidity',
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  children: <Widget>[
                    Text(
                      (weather.maxTemp - 275.5).floor().toString() + '°',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Maximum',
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
            child: Row(
              children: <Widget>[
                const Spacer(),
                Column(
                  children: <Widget>[
                    Text(
                      weather.pressure.toString() + ' atm',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Pressure',
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  children: <Widget>[
                    Text(
                      (weather.minTemp - 275.5).floor().toString() + '°',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Minimum',
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
