import 'package:flutter/material.dart';
import 'package:weather/service/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Picker',
      home: LocationPickerScreen(),
    );
  }
}

class LocationPickerScreen extends StatelessWidget {
  final LocationPicker _locationPicker = LocationPicker();

  LocationPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Picker'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _locationPicker.localeInfo();
          },
          child: const Text('Get Location'),
        ),
      ),
    );
  }
}
