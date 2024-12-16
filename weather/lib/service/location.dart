import 'dart:io';

import 'package:location/location.dart';
import 'unpack_geocode.dart';
import 'dart:async';

class LocationPicker  {
  Location locale = Location();
  bool _enable = true;
  PermissionStatus? _permit;
  LocationData? _localeData;
  final LocationAccuracy _localeAccuracy = LocationAccuracy.powerSave;
  double? localeLat, localeLong;
  String? locate;

  Future<void> localeInfo () async {
    // checking if the device location is enabled
    try {
      _enable = await locale.serviceEnabled();
      if (!_enable) {
        _enable = await locale.requestService(); // request service
        if (!_enable) {
          return;
        }
      }

      // permission granting
      _permit = await locale.hasPermission();
      if (_permit == PermissionStatus.denied) {
        _permit = await locale.requestPermission();
        if (_permit != PermissionStatus.granted) {
          return;
        }
      }

      _localeData = await locale.getLocation();
      localeLat = _localeData?.latitude;
      localeLong = _localeData?.longitude;
      ReverseGeo accurateLoc = ReverseGeo();
      await accurateLoc.getLocation(localeLat!, localeLong!);

      // print(_localeData);
      // print(_localeAccuracy);}
    } catch (e) {
      stdout.write('Error: $e');
    }
  }
}

void main() {
  LocationPicker();
}