import 'dart:async';
import 'dart:io'; // testing using user input through terminal

import 'package:http/http.dart';
import 'dart:convert';

class Weather {
  // API key
  final String key = "67219082d5a04530a56211552243011";
  Map? weatherData, locale, currentData, condition;
  String? error;
  String? localName,  condText, condIcon, dateTime, name;

  Weather({
    required this.localName,
    required this.condText,
    required this.condIcon,
    required this.dateTime,
  });
  // fetching data
  Future<void> fetchData (String? location) async {
    // URL for weather
    try {
      Uri weatherURL = Uri.parse(
          "http://api.weatherapi.com/v1/current.json?key=$key&q=$location");

      // getting response
      Response weatherResponse = await get(weatherURL);
      //print(weatherResponse);

      if (weatherResponse.statusCode == 200) {
        weatherData = jsonDecode(weatherResponse.body);

        // separating keys
        locale = weatherData?["location"];
        localName = "${locale?['name']}, ${locale?['country']}";
        name = locale?['name'];
        currentData = weatherData?['current'];
        condition = currentData?['condition'];
        condText = condition?['text'];
        condIcon = "https:${condition?['icon']}";
        dateTime = locale?['localtime'];
      } else {
        stdout.write("Fetch failed. Location does not exist: ${weatherResponse.statusCode}\n");
      }
    } catch(e) {
      stdout.write("No connection: $e\n");
    }
  }

  // Future<List<Null>> locSuggest () async {
  //   await Future.delayed(const Duration(seconds: 1));
  //   return List.generate(weatherData!.length, (i) {
  //     Weather(
  //       locale: '',
  //
  //
  //     );
  //   });
  // }

  Future<void> dataKeys (String? area) async {
    await fetchData(area);

    // null check
    if (weatherData != null) {
      var locationKey = weatherData?["location"];
      var currentKey = weatherData?["current"];

      // print("Location Details");
      // locationKey.forEach((key, value) {
      //   print("$key -> $value\t\t");
      // });

      // print("\nCurrent weather Details");
      // currentKey.forEach((key, value) {
      //   print("$key -> $value\t\t");
      // });
    } else {
     error = "No weather data available. Check internet connection and try again";
    }

  }
}

void main() {
  Weather weatherTest = Weather(
    localName: "",
    condText: "",
    condIcon: "",
    dateTime: "",
  );
  stdout.write("Enter location : ");
  String? location = stdin.readLineSync();
  weatherTest.dataKeys(location);
}