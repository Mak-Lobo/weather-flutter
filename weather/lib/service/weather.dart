import 'dart:async';
import 'dart:io'; // testing using user input through terminal

import 'package:http/http.dart';
import 'dart:convert';

class Weather {
  // API key
  String key = "67219082d5a04530a56211552243011";

  // fetching data
  Future<void> fetchData (String? location) async {

    // URL for weather
    Uri weatherURL = Uri.parse("http://api.weatherapi.com/v1/current.json?key=$key&q=$location");

    // getting response
    Response weatherResponse = await get(weatherURL);
    print(weatherResponse);

    //printing the body
    Map weatherData = jsonDecode(weatherResponse.body);
    print(weatherData);
    
    //print parts of data
    print(weatherData["location"]);
    print(weatherData.keys);
    
    // passing each value in the map as its own separate key-value pair
    weatherData.forEach((key, value) {
      print("$key : $value ");
    });

  }
}

void main() {
  Weather weatherTest = Weather();
  print("Enter location : ");
  String? location = stdin.readLineSync();
  weatherTest.fetchData(location);


}