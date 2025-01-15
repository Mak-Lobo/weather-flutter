import 'dart:async';

import "package:flutter/material.dart";
import 'package:weather/service/current.dart';
import 'package:weather/custom/custom_widget.dart';
import 'package:weather/service/forecast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map _data = {};
  Map _deviceLocData = {};
  List<Widget> _homeView = [];
  List<Widget> panel = [];
  Map dailyForecastMap = {};
  Map hourlyForecastMap = {};

  // current location weather
  Future<void> current () async {
    // current location's weather
    currentLocationWeather userDeviceWeather = currentLocationWeather();
    _deviceLocData = await userDeviceWeather.getCurrentData();

    setState(() {
      _deviceLocData = _deviceLocData;
    });

    if (_deviceLocData['localeName'] != null) {
      WeatherForecast currentWeatherForecast = WeatherForecast();
      await currentWeatherForecast.getforecast(
          _deviceLocData['localeName'], "3");
      setState(() {
        dailyForecastMap = currentWeatherForecast.dailyMap;
        hourlyForecastMap = currentWeatherForecast.hourlyMap;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    current();
    Timer.periodic(const Duration(minutes: 5), (timer) {
      current();
    });
  }

  //sheet panel widget
  List<Widget> sheetPanel () {
    return panel = [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Forecast Data: ${_deviceLocData['localeName']}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      if (dailyForecastMap.isNotEmpty)
        ... dailyForecastMap.entries.map((entry) {
          final dailyData = entry.value;
          return ListTile(
            title: Text("Date: ${dailyData['day']}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Max Temp: ${dailyData['maxTemp']}°C"),
                Text("Min Temp: ${dailyData['minTemp']}°C"),
                Text(dailyData['condText']),
              ],
            ),
            leading: dailyData['condIcon'] != null
                ? Image.network(dailyData['condIcon'])
                : null,
          );
        }),
      if (hourlyForecastMap.isNotEmpty)
        ...hourlyForecastMap.entries.map((entry) {
          final hourlyDataList = entry.value as List<Map<String, dynamic>>;
          return Column(
            children: hourlyDataList.map((hourlyData) {
              return CustomCard(
                child: ListTile(
                  title: Text("Time: ${hourlyData['time']}"),
                  subtitle: Text("Temperature: ${hourlyData['temperature']}°C"),
                  leading: hourlyData['condIcon'] != null
                      ? Image.network(hourlyData['condIcon'])
                      : null,
                ),
              );
            }).toList(),
          );
        }),
      const Divider(
        thickness: 1.5,
        indent: 2,
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    // getting data passed
    _data = _data.isNotEmpty
        ? _data
        : ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    // ignore: no_leading_underscores_for_local_identifiers
    final _size = MediaQuery.sizeOf(context).width <600;
    print("Device condIcon URL: ${_deviceLocData['condIcon']}");
    print("Received condIcon: ${_deviceLocData['condIcon']}");
    print("Device location: ${_deviceLocData['localeName']}");

    // details in home page
    _homeView = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadText(
            text: _deviceLocData['localeName'] ?? " ",
          ),
          SmallHeadText(
            text: _deviceLocData['condText'] ?? " ",
          ),
          if (_deviceLocData['condIcon'] != null)
            CircleAvatar(
              backgroundImage: NetworkImage(
                _deviceLocData['condIcon']?.isNotEmpty == true
                    ? _deviceLocData['condIcon']
                    : 'https://media.wired.com/photos/5b17381815b2c744cb650b5f/master/w_1920,c_limit/GettyImages-134367495.jpg',
              ),
              radius: 15,
              backgroundColor: Colors.white.withOpacity(0.25),
            ),
          SmallHeadText(
            text: "Updated as of ${_deviceLocData['updatedAt']}",
          ),
          const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
        ],
      ),
      const Divider(
        height: 10,
        color: Colors.black,
        thickness: 1.5,
      ),

      // selected location
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          HeadText(
           text:  _data['localeName'] ?? " ",
          ),
          SmallHeadText(
            text: _data['condText'] ?? " ",
          ),
          if (_data['condIcon'] != null)
            CircleAvatar(
              backgroundImage: NetworkImage(
                _data['condIcon'] ?? 'https://media.wired.com/photos/5b17381815b2c744cb650b5f/master/w_1920,c_limit/GettyImages-134367495.jpg',
              ),
              radius: 15,
              backgroundColor: Colors.white.withOpacity(0.25),
            ),
          SmallHeadText(
            text: _data['dateTime'] ?? " ",
          ),
        ],
      )
    ];
    bool size = MediaQuery.sizeOf(context).width < 600;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/weather.jpg"),
                fit: BoxFit.cover,
                opacity: 0.75,
              ),
            ),
            child: Column(
              children: [
                // Search Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 75, 8, 0),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Navigate to the '/location' screen and wait for data to be returned
                      final returnValue = await Navigator.pushNamed(
                        context,
                        "/location",
                      );
                      if (returnValue != null && returnValue is Map) {
                        setState(() {
                          _data = {
                            'localeName': returnValue['localName'],
                            'condText': returnValue['condText'],
                            'condIcon': returnValue['condIcon'],
                            'dateTime': returnValue['dateTime'],
                          };
                        });
                      }
                    },
                    label: const Text(
                      "Search",
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 176, 196, 222),
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    icon: const Icon(
                      Icons.search_sharp,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 55,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Weather Today",
                        style: TextStyle(
                          fontSize: 24,
                          color: Color.fromARGB(255, 4, 91, 110),
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      (!_size) ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _homeView,
                      ) : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _homeView,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.15, // Panel starts hidden
            minChildSize: 0.0875,    // Minimum height of the panel
            maxChildSize: 0.8,     // Maximum height of the panel (80% of screen)
            builder: (context, controller) {
              return Container(
                color: Colors.blue[300],
                child: ListView(
                  controller: controller,
                  children: sheetPanel(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
