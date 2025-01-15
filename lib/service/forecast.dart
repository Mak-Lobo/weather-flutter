import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';

class WeatherForecast {
  Map? forecastData;
  List<Map<String, dynamic>> dailyForecast = [];
  List<Map<String, dynamic>> hourlyForecast = [];
  Map hourlyMap = {};
  Map dailyMap = {};
  final String key = "67219082d5a04530a56211552243011";

  // forecast function
  Future<void> getforecast(String? location, String day) async {
    // parse URL
    Uri url = Uri.parse(
      "https://api.weatherapi.com/v1/forecast.json?key=$key&q=$location&days=$day&aqi=no&alerts=no"
    );
    try{
      Response forecastResponse = await get(url);
      if (forecastResponse.statusCode == 200) {

        forecastData = jsonDecode(forecastResponse.body);
        dailyForecast.clear();
        hourlyForecast.clear();
        //clearing previous data
        List<dynamic> forecastDay = forecastData?['forecast']['forecastday'];
        for (var day in forecastDay) {
          // daily forecast information
          Map<String, dynamic> dataDailyHold = {
            'day' : (day['date']),
            'maxTemp' : day['day']['maxtemp_c'],
            'minTemp' : day['day']['mintemp_c'],
            'condText': "General condition: ${day['day']['condition']['text']}",
            'condIcon' : "https:${day['day']['condition']['icon']}",
          };

          // adding to the list and map
          dailyForecast.add(dataDailyHold);
          dailyMap[day['date']] = dataDailyHold;

          //hourly forecast information
          List<dynamic> forecastHours = day['hour'];
          if (!hourlyMap.containsKey(day['date'])) {
            // Initialize an empty list for the day in the map
            hourlyMap[day['date']] = <Map<String, dynamic>>[];
          }
          for (var hr in forecastHours) {
            Map<String, dynamic> dataHourlyHold = {
              'date': day['date'],
              'time' : hr['time'],
              'temperature' : hr['temp_c'],
              'condText': hr['condition']['text'],
              'condIcon' : "https:${hr['condition']['icon']}",
            };
            // adding to the list and map
            hourlyForecast.add(dataHourlyHold);
            (hourlyMap[day['date']] as List<Map<String, dynamic>>).add(dataHourlyHold);
          }
        }
        print("\n$dailyForecast");
        print("\n$hourlyForecast");
        print('\t\n Daily forecast map -> \n$dailyMap');
        print('\t\n Hourly forecast map -> \n$hourlyMap');


      } else {
        print("Error: Unable to fetch data. HTTP Status: ${forecastResponse.statusCode}");
        print(forecastResponse.body);
      }
    } catch(e){
      print("Error: $e");
    }
  }
}

void main() {
  stdout.write("Enter location and days: ");
  String? loc = stdin.readLineSync();
  String? d = stdin.readLineSync();
  WeatherForecast foredata = WeatherForecast();
  foredata.getforecast(loc, d!);
}