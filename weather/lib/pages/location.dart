import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  late List<Weather> saved, suggest = [];
  bool _isLoading = false;

  // Fetch location function
  void showData() async {
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
      weatherSel = tempWeather;
      _isLoading = false;
    });
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
          style: BorderStyle.solid
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      insetAnimationDuration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                iconSize: 16,
                color: Colors.red,
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
                    "${weatherSel!.condIcon}",
                    width: 50,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Condition: ${weatherSel!.condText}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "DM Serif Display",
                    ),
                  ),
                  Text(
                    "Temperature: ${weatherSel!.currentData?["temp_c"] ?? "N/A"}°C",
                    style: const TextStyle(fontSize: 16),
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
          backgroundColor: Colors.lightBlue,
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
              Column(
                children: [
                  Center(
                    child: SpinKitPulse(
                      size: 100,
                      color: Colors.blueGrey[600],
                    ),
                  ),
                ],
              )
            else if (weatherSel != null)
              Card(
                color: Colors.blueGrey,
                elevation: 10,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  side: BorderSide(
                    color: Color.fromARGB(100, 97, 187, 187),
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return (windSize) ? Dialog.fullscreen(child: dialogView) : dialogView;
                      },
                    );
                  },
                  title: Text("${weatherSel?.localName}"),
                  subtitle: Text("${weatherSel?.condText}"),
                  leading: Image.network(
                    weatherSel?.condIcon ?? "",
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return (windSize) ? Dialog.fullscreen(child: dialogView) : dialogView;
                            },
                          );
                        },
                        title: Text("${saved[index].localName}"),
                        subtitle: Text("${saved[index].condText}"),
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
