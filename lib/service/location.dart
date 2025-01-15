import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'unpack_geocode.dart';
import 'dart:async';

class LocationPicker {
  bool _enable = true;
  LocationPermission? _permit;
  late LocationSettings localSettings;
  double? localeLat, localeLong;
  String? locate;

  Future<void> localeInfo() async {
    try {
      // Check if location services are enabled
      _enable = await Geolocator.isLocationServiceEnabled();
      if (!_enable) {
        stdout.write('Location services are disabled.');
        return;
      }

      // Request and check for location permissions
      _permit = await Geolocator.checkPermission();
      if (_permit == LocationPermission.denied) {
        _permit = await Geolocator.requestPermission();
        if (_permit == LocationPermission.denied) {
          stdout.write('Location permissions are denied.');
          return;
        }
      }

      if (_permit == LocationPermission.deniedForever) {
        stdout.write(
            'Location permissions are permanently denied, we cannot request permissions.');
        return;
      }

      // Get the current position
      // GPS location accuracy

      if (defaultTargetPlatform == TargetPlatform.android) {
        localSettings = AndroidSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 100,
            forceLocationManager: true,
            intervalDuration: const Duration(seconds: 10),
            //(Optional) Set foreground notification config to keep the app alive
            //when going to the background
            foregroundNotificationConfig: const ForegroundNotificationConfig(
              notificationText:
              "Example app will continue to receive your location even when you aren't using it",
              notificationTitle: "Running in Background",
              enableWakeLock: true,
            )
        );
      } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
        localSettings = AppleSettings(
          accuracy: LocationAccuracy.high,
          activityType: ActivityType.fitness,
          distanceFilter: 100,
          pauseLocationUpdatesAutomatically: true,
          // Only set to true if our app will be started up in the background.
          showBackgroundLocationIndicator: false,
        );
      } else if (kIsWeb) {
        localSettings = WebSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          maximumAge: const Duration(minutes: 5),
        );
      } else {
        localSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        );
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: localSettings
      );

      localeLat = position.latitude;
      localeLong = position.longitude;

      // Use a Reverse Geocode class to get a more accurate location
      ReverseGeo accurateLoc = ReverseGeo();
      await accurateLoc.getLocation(localeLat!, localeLong!);

      // Debug information
      stdout.write('Latitude: $localeLat, Longitude: $localeLong');
    } catch (e) {
      stdout.write('Error: $e');
    }
  }
}

void main() async {
  LocationPicker locationPicker = LocationPicker();
  await locationPicker.localeInfo();
}
