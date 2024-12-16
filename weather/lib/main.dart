import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/location.dart';
import 'pages/comparison.dart';


void main() {
  runApp(MaterialApp(
    // home: HomePage(),
    initialRoute: "/locationTest",
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
