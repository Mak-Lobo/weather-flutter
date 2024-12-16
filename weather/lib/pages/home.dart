import "package:flutter/material.dart";
import 'package:weather/service/current.dart';


// the imported 'location' and 'weather' files used for the current location

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map _data = {};
  Map _deviceLocData = {};

  // current location weather
  Future<void> current () async {
    // current location's weather
    currentLocationWeather userDeviceWeather = currentLocationWeather();
    _deviceLocData = await userDeviceWeather.getCurrentData();

    setState(() {
      _deviceLocData = _deviceLocData;
    });
  }

  @override
  void initState() {
    super.initState();
    current();
  }

  @override
  Widget build(BuildContext context) {
    // getting data passed
    _data = _data.isNotEmpty
        ? _data
        : ModalRoute.of(context)?.settings.arguments as Map? ?? {};

    return Scaffold(
      body: Container(
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
              padding: const EdgeInsetsDirectional.fromSTEB(10, 50, 10, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Weather Today",
                    style: TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(255, 176, 196, 222),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _deviceLocData['localeName'] ?? "No location selected",
                            style: const TextStyle(
                              fontFamily: "DM Serif Display",
                              fontSize: 32,
                              color: Color.fromARGB(255, 10, 101, 109),
                            ),
                            softWrap: true,
                          ),
                          Text(
                            _deviceLocData['condText'] ?? "Condition unavailable",
                            style: const TextStyle(
                              fontFamily: "DM Serif Display",
                              color: Color.fromARGB(255, 10, 101, 109),
                              fontSize: 24,
                            ),
                            softWrap: true,
                          ),
                          if (_deviceLocData['condIcon'] != null)
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                _deviceLocData['condIcon'],
                              ),
                              radius: 30,
                              backgroundColor: Colors.transparent,
                            ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _data['localeName'] ?? "No location selected",
                            style: const TextStyle(
                              fontFamily: "DM Serif Display",
                              fontSize: 32,
                              color: Color.fromARGB(255, 10, 101, 109),
                            ),
                            softWrap: true,
                          ),
                          Text(
                            _data['condText'] ?? "Condition unavailable",
                            style: const TextStyle(
                              fontFamily: "DM Serif Display",
                              color: Color.fromARGB(255, 10, 101, 109),
                              fontSize: 24,
                            ),
                            softWrap: true,
                          ),
                          if (_data['condIcon'] != null)
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                _data['condIcon'],
                              ),
                              radius: 30,
                              backgroundColor: Colors.transparent,
                            ),
                          Text(
                            _data['dateTime'] ?? "Invalid data",
                            style: const TextStyle(
                              fontFamily: "DM Serif Display",
                              fontSize: 32,
                              color: Color.fromARGB(255, 10, 101, 109),
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
