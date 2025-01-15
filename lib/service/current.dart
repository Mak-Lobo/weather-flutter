import 'package:weather/service/unpack_geocode.dart';
import 'package:weather/service/location.dart';
import 'package:weather/service/weather.dart';
import 'package:weather/service/forecast.dart';
import 'dart:async';

class currentLocationWeather {
  String? _currentLocation;
  Map deviceLocData = {};
  Future<Map> getCurrentData () async {
    // retrieve device coordinates
    LocationPicker devicePick = LocationPicker();
    await devicePick.localeInfo();
    if(devicePick.localeLat == null || devicePick.localeLong == null) {
      // print('Error. Coordinate fetch unsucessfull.');
      return {};
    }

    ReverseGeo devicePickName = ReverseGeo();
    await devicePickName.getLocation(devicePick.localeLat!, devicePick.localeLong!);
    _currentLocation = devicePickName.nameOnly!;

    Weather _currentWeather = Weather(
      localName: '',
      condIcon: '',
      condText: '',
      dateTime: '',
    );
    await _currentWeather.fetchData(_currentLocation);
    // showing current time for device
    _currentWeather.dateTime = DateTime.now().toString();
    print("My device location: $_currentLocation");

    deviceLocData['localeName'] = _currentWeather.localName;
    deviceLocData['condText'] = _currentWeather.condText;
    deviceLocData['condIcon'] = _currentWeather.condIcon;
    deviceLocData['dateTime'] = _currentWeather.dateTime;
    deviceLocData['updatedAt'] = _currentWeather.lastUpdate;

    return deviceLocData;
  }

  Future<void> currentForecast () async{
    // forecast data for current location
    WeatherForecast currentForecast = WeatherForecast();

    await currentForecast.getforecast(_currentLocation, '3');
    print(currentForecast.dailyForecast);
  }
}

void main() {
  currentLocationWeather localForecast = currentLocationWeather();
  localForecast.currentForecast();
}