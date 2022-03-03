import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/bloc/weather_events.dart';
import 'package:weather_app/bloc/weather_states.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/repository/weather_repository.dart';

class WeatherBloc extends Bloc<WeatherEvents, WeatherStates> {
  final WeatherRepository weatherRepository;
  WeatherBloc({@required this.weatherRepository})
      : assert(weatherRepository != null),
        super(WeatherEmpty());

  @override
  Stream<WeatherStates> mapEventToState(
    WeatherEvents event,
  ) async* {
    if (event is FetchWeather) {
      yield WeatherLoading();
      try {
        final Weather weather = await weatherRepository.getWeather(event.city);
        yield WeatherLoaded(weather: weather);
      } catch (error) {
        print(error);
        yield WeatherError();
      }
    } else if (event is RefreshWeather) {
      try {
        final Weather weather = await weatherRepository.getWeather(event.city);
        yield WeatherLoaded(weather: weather);
      } catch (error) {
        print("Error" + error);
        yield state;
      }
    } else if (event is ResetWeather) {
      yield WeatherEmpty();
    }
  }
}
