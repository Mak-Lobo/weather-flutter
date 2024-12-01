import 'package:flutter/material.dart';
import 'pages/home.dart';


void main() {
  runApp(const MaterialApp(
    home: HomePage(),
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
