import 'package:weather/service/unpack_geocode.dart';
import 'package:weather/service/location.dart';
import 'package:weather/service/weather.dart';
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

    deviceLocData['localeName'] = _currentWeather.localName;
    deviceLocData['condText'] = _currentWeather.condText;
    deviceLocData['condIcon'] = _currentWeather.condIcon;
    deviceLocData['dateTime'] = _currentWeather.dateTime;

    return deviceLocData;
  }
}