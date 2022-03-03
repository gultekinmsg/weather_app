import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/widget_testing/home_page.dart';
import 'package:weather_app/observers/simple_bloc_observer.dart';
import 'package:weather_app/repository/weather_api_client.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/repository/weather_repository.dart';
import 'package:weather_app/views/weather_view.dart';

// WEATHER APP (bloc)
// void main() {
//   Bloc.observer = SimpleBlocObserver();
//   WeatherAPIClient weatherAPIClient =
//       WeatherAPIClient(httpClient: http.Client());

//   WeatherRepository weatherRepository =
//       WeatherRepository(weatherAPIClient: weatherAPIClient);
//   runApp(MyApp(
//     weatherRepository: weatherRepository,
//   ));
// }

// class MyApp extends StatelessWidget {
//   final WeatherRepository weatherRepository;

//   const MyApp({Key key, @required this.weatherRepository})
//       : assert(weatherRepository != null),
//         super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Weather',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(),
//       themeMode: ThemeMode.dark,
//       darkTheme: ThemeData(brightness: Brightness.dark),
//       home: BlocProvider(
//         create: (context) => WeatherBloc(weatherRepository: weatherRepository),
//         child: const WeatherView(),
//       ),
//     );
//   }
// }

/* FOR WIDGET TESTING
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: HomePage(
      ),
    );
  }
}
*/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
