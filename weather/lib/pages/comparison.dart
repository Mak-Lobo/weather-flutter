import "package:flutter/material.dart";
import 'package:weather/service/weather.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  // Text controller and weather data
  TextEditingController area = TextEditingController();
  Weather? weatherSel;
  List<Weather> saved = [];
  bool isLoading = false;

  // Fetch weather data for search
  void showData() async {
    setState(() {
      isLoading = true;
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
      isLoading = false;
    });
  }

  // Save location to the saved list
  void savedData() {
    if (weatherSel != null) {
      setState(() {
        saved.add(weatherSel!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final windSize = MediaQuery.sizeOf(context).width <= 600;

    // Dialog content
    Widget dialogView = Dialog(
      backgroundColor: Colors.blue[100],
      shape: const RoundedRectangleBorder(),
      insetAnimationDuration: const Duration(milliseconds: 100),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: weatherSel != null
            ? Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Location: ${weatherSel?.localName}",
              style: const TextStyle(
                fontFamily: "DM Sans",
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(weatherSel?.condIcon ?? "", width: 50),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Condition: ${weatherSel?.condText ?? ""}"),
                    Text("Time: ${weatherSel?.dateTime ?? ""}"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: savedData,
              label: const Text("Save Location"),
              icon: const Icon(Icons.add_location_alt_outlined),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Colors.blueAccent.withOpacity(0.45),
                ),
              ),
            ),
          ],
        )
            : const Text("No weather data to show"),
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
            // Search field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: area,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search_sharp),
                  hintText: "Search Location",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                onSubmitted: (text) => showData(),
              ),
            ),

            // Search results or loading indicator
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (weatherSel != null)
              Card(
                surfaceTintColor: Colors.blue[900],
                elevation: 15,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return windSize
                            ? Dialog.fullscreen(child: dialogView)
                            : dialogView;
                      },
                    );
                  },
                  title: Text("${weatherSel?.localName}"),
                  subtitle: Text("${weatherSel?.condText}"),
                  leading: Image.network(weatherSel?.condIcon ?? ""),
                ),
              )
            else
              const SizedBox(),

            // Saved locations
            Expanded(
              child: saved.isEmpty
                  ? const Center(
                child: Text(
                  "No saved locations.",
                  style: TextStyle(
                    fontFamily: "DM Serif Display",
                    fontSize: 28,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              )
                  : ListView.builder(
                itemCount: saved.length,
                itemBuilder: (context, index) {
                  return Card(
                    surfaceTintColor: Colors.blue[900],
                    elevation: 15,
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: ListTile(
                      onTap: () {
                        weatherSel = saved[index];
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return windSize
                                ? Dialog.fullscreen(child: dialogView)
                                : dialogView;
                          },
                        );
                      },
                      title: Text("${saved[index].localName}"),
                      subtitle: Text("${saved[index].condText}"),
                      leading:
                      Image.network(saved[index].condIcon ?? ""),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
