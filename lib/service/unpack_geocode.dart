import 'dart:async';
import 'dart:io';
import 'package:geocoding/geocoding.dart';

class ReverseGeo {
String? accName, nameOnly;
  Future<void> getLocation (double lat, double long) async {
    List<Placemark> fineLocale = await placemarkFromCoordinates(lat, long);
    try{
      if (fineLocale.isNotEmpty) {
        Placemark currentLocation = fineLocale.first;
        // print(currentLocation);
        // print(fineLocale.last);
        nameOnly = currentLocation.name;
        accName = "${currentLocation.name}, ${currentLocation.country}";
        // print(accName);
        // print(nameOnly);
      }
    } catch(e) {
      stdout.write("Error: $e");
    }
  }
}