import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather/service/weather.dart';
import 'pages/home.dart';
import 'pages/location.dart';
import 'pages/comparison.dart';


void main() async {

  // initializing hive
  await Hive.initFlutter();
  Hive.registerAdapter(WeatherAdapter()); // registering an adapter
  await Hive.openBox<List>('weather');
  runApp(MaterialApp(
    // home: HomePage(),
    initialRoute: "/",
    routes: {
      "/":(context) => const HomePage(),
      '/location':(context) => const Location(),
      '/locationTest': (context) => LocationPickerScreen(),
    },
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
