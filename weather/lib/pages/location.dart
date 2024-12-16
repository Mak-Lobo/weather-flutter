import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

import 'package:weather/service/weather.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  // Weather code
  TextEditingController area = TextEditingController();
  Weather? weatherSel;
  List<Weather> saved = [];
  List<Weather> suggest = [];
  bool _isLoading = false;
  Timer? _update;

  // Fetch location function
  void showData() async {
    // no data fetching if input is empty
    if (area.text.isEmpty) {
      setState(() {
        weatherSel = null;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Weather tempWeather = Weather(
      localName: "",
      condText: "",
      condIcon: "",
      dateTime: "",
    );

    await tempWeather.fetchData(area.text);

    setState(() {
      // 'tempweather' variable holds fetched data
      weatherSel = tempWeather.localName?.isNotEmpty == true
          ? tempWeather : null;
      _isLoading = false;
    });
  }

  void autoUpdate() {
    _update = Timer.periodic(const Duration(minutes: 15), (timer) {
      showData();
    });
  }

  // Stop automatic updates
  void stopUpdate() {
    _update?.cancel();
  }

  @override
  void initState() {
    super.initState();
    // Automatically start updates when the screen is loaded
    autoUpdate();
  }

  @override
  void dispose() {
    // Clean up the timer to avoid memory leaks
    stopUpdate();
    area.dispose(); // Dispose the controller
    super.dispose();
  }

  void saveData() {
    if (weatherSel != null) {
      setState(() {
        saved.add(weatherSel!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final windSize = MediaQuery.sizeOf(context).width < 600;

    Widget dialogView = Dialog(
      backgroundColor: Colors.blue[100],
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      insetAnimationDuration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (windSize) Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                iconSize: 16,
                color: Colors.blue,
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
              ),
            ),
            Text(
              "Location: ${weatherSel?.localName ?? "Unknown"}",
              style: const TextStyle(
                fontFamily: "DM Sans",
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (weatherSel != null)
              Column(
                children: [
                  Image.network(
                    "${weatherSel?.condIcon}",
                    width: 50,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Condition: ${weatherSel?.condText}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "DM Serif Display",
                    ),
                  ),
                  Text(
                    "Temperature: ${weatherSel?.currentData?["temp_c"] ?? "N/A"}°C",
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: saveData,
              label: const Text("Save Location"),
              icon: const Icon(Icons.add_location_alt_outlined),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[300],
        appBar: AppBar(
          backgroundColor: Colors.blue[700],
          title: const Text(
            "Location",
            style: TextStyle(
              fontFamily: "ChakraPetch",
              fontSize: 24,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              // input area
              child: TextField(
                style: const TextStyle(
                  fontFamily: "Poppins"
                ),
                controller: area,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search_sharp),
                  hintText: "Search Location",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                onChanged: (area) {
                  showData();
                },
              ),
            ),

            // Output for data retrieval
            if (_isLoading)
              Center(
                child: SpinKitPulse(
                  size: 100,
                  color: Colors.blueGrey[600],
                ),
              )

            else if (weatherSel != null)
              Card(
                color: Colors.blue,
                elevation: 10,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  side: BorderSide(
                    width: 2.5,
                    color: Color.fromARGB(100, 97, 187, 187),
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return (windSize)
                          ? Dialog.fullscreen(child: dialogView) : dialogView;
                      },
                    );
                  },
                  title: Text("${weatherSel?.localName}"),
                  subtitle: Text("${weatherSel?.condText}"),
                  leading: Image.network(
                    weatherSel?.condIcon ?? "",
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
                  ),
                  titleTextStyle: const TextStyle(
                    fontFamily: 'DM Serif Display',
                    fontSize: 20,
                    color: Colors.black
                  ),
                  subtitleTextStyle: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              )
            else
              const SizedBox(),

            // Saved data
            if (saved.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: saved.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.blue[400],
                      elevation: 15,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            weatherSel = saved[index];
                          });
                          // carrying data to home page
                          Navigator.pop(context, {
                            'localName': saved[index].localName,
                            'condText': saved[index].condText,
                            'condIcon': saved[index].condIcon,
                            'dateTime': saved[index].dateTime,
                          });
                        },
                        title: Text(
                          "${saved[index].localName}",
                          style: const TextStyle(
                            fontFamily: "DM Serif Display",
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          "${saved[index].condText}",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        trailing: PopupMenuButton(
                          color: Colors.blue[500],
                          icon:  const Icon(Icons.more_vert_rounded),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              child: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    saved.removeAt(index);
                                  });
                                },
                                label: const Text("Delete"),
                                icon: const Icon(Icons.delete_rounded),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue[400],
                                  textStyle: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              child: TextButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return (windSize)
                                        ? Dialog.fullscreen(child: dialogView)
                                        : dialogView;
                                    },
                                  );
                                },
                                label: const Text("Details"),
                                icon: const Icon(Icons.info_rounded),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue[400],
                                  textStyle: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              const Center(
                child: Text(
                  "No saved locations.",
                  style: TextStyle(
                    fontFamily: "DM Serif Display",
                    fontSize: 28,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
