import 'dart:async';
import 'dart:io'; // testing using user input through terminal
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart';
import 'dart:convert';

part 'weather.g.dart';
@HiveType(typeId: 0)
class Weather {
  // API key
  final String key = "67219082d5a04530a56211552243011";
  Map? weatherData, locale, currentData, condition;
  String? error;
  @HiveField(0)
  String? localName;

  @HiveField(1)
  String? condText;

  @HiveField(2)
  String? condIcon;

  @HiveField(3)
  String? dateTime;

  @HiveField(4)
  String? lastUpdate;
  String?  name, savedTime;

  Weather({
    this.lastUpdate,
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
          "https://api.weatherapi.com/v1/current.json?key=$key&q=$location");

      // getting response
      Response weatherResponse = await get(weatherURL);
      //print(weatherResponse);

      // formating dates
      String formatDate(String? date) {
        if (date == null) return '';
        try {
          return DateFormat('MMMM dd, yyyy HH:mm').format(DateTime.parse(date));
        } catch (e) {
          return 'Invalid Date';
        }
      }

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
        dateTime = formatDate(locale?['localtime']);
        lastUpdate = formatDate(currentData?['last_updated']);

      } else {
        stdout.write("Fetch failed. Location does not exist: ${weatherResponse.statusCode}\n");
      }
      // formatting the dates

    } catch(e) {
      stdout.write("No connection: $e\n");
    }
  }

  Future<void> dataKeys (String? area) async {
    await fetchData(area);

    // null check
    if (weatherData != null) {
      var locationKey = weatherData?["location"];
      var currentKey = weatherData?["current"];

      print("Location Details");
      locationKey.forEach((key, value) {
        print("$key -> $value\t\t");
      });

      print("\nCurrent weather Details");
      currentKey.forEach((key, value) {
        print("$key -> $value\t\t");
      });
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