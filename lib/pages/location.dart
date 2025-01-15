import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

import 'package:weather/service/weather.dart';
import 'package:weather/custom/custom_widget.dart';
import 'package:weather/service/database.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  // Weather code
  TextEditingController area = TextEditingController();
  Weather? weatherSel;
  List<Weather> suggest = [];
  bool _isLoading = false;
  bool _isSaved = false;
  Timer? _update;

  // opening Hive Database
  Database db = Database();

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
    _update = Timer.periodic(const Duration(minutes: 5), (timer) {
      showData();
    });
  }

  // Stop automatic updates
  void stopUpdate() {
    _update?.cancel();
  }

  void saveData() async {
    for (int index = 0; index < db.saved.length; index ++){
      if (weatherSel != null) {
        if (db.saved[index].localName != weatherSel?.localName ){
          setState(() {
            db.saved.add(weatherSel!);
          });
        }
        setState(() {
          _isSaved = true;
        });
      } else {
        setState(() {
          _isSaved = false;
        });
      }
    }
    print(db.saved.toString());
    area.clear();
    db.updateData();
  }

  @override
  void initState() {
    super.initState();
    db.loadData();
    print(db.saved);
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

  //dialog popup
  Widget dialogPop() {
    return Dialog(
      backgroundColor: Colors.blue[300],
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
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
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
                    "Temperature: ${weatherSel?.currentData?["temp_c"] ??
                        "N/A"}°C",
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            if (!_isSaved) ElevatedButton.icon(
              onPressed: () {
                saveData();
                Navigator.pop(context);
              },
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[300],
        appBar: AppBar(
          backgroundColor: Colors.blue[700],
          title: const Text(
            "Location",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
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

              //if the search location is valid
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
                        return dialogPop();
                      },
                    );
                  },
                  title: TileTitle(
                      title: "${weatherSel?.localName}",
                  ),
                  subtitle: TileSubtitle(
                      subtitle: "${weatherSel?.condText}"),
                  leading: Image.network(
                    weatherSel?.condIcon ?? "",
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
                  ),
                ),
              )
            else
              const SizedBox(),

            // Saved data
            if (db.saved.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: db.saved.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.blue[400],
                      elevation: 15,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: ListTile(
                        onTap: () async {
                          setState(() {
                            weatherSel = db.saved[index];
                          });
                          await weatherSel?.fetchData(db.saved[index].localName);
                          setState(() {
                            db.saved[index] = Weather(
                              localName: weatherSel?.localName,
                              condText: weatherSel?.condText,
                              condIcon: weatherSel?.condIcon,
                              dateTime: weatherSel?.dateTime,
                            );
                          });
                          db.updateData();
                          // carrying data to home page
                          Navigator.pop(context, {
                            'localName': db.saved[index].localName,
                            'condText': db.saved[index].condText,
                            'condIcon': db.saved[index].condIcon,
                            'dateTime': db.saved[index].dateTime,
                          });
                        },
                        title: TileTitle(
                          title: "${db.saved[index].localName}",
                        ),
                        subtitle: TileSubtitle(
                          subtitle: "As of ${db.saved[index].lastUpdate}. \nWeather: ${db.saved[index].condText}",
                        ),
                        trailing: PopupMenuButton(
                          color: Colors.blue[500],
                          icon:  const Icon(Icons.more_vert_rounded),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              child: TextButton.icon(
                                onPressed: () async {
                                  setState(() {
                                    db.saved.removeAt(index);
                                  });
                                  db.updateData();
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
                                      return dialogPop();
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
