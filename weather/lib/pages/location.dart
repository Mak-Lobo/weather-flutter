import "package:flutter/material.dart";

import 'package:weather/service/weather.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  // Weather code
  Weather weatherSel = Weather();
  final area = TextEditingController();
  List<Weather> saved = [];

  //fetch location function
  Future<void> locationFetch () async{
    await weatherSel.fetchData(area.text);

  }

  @override
  Widget build(BuildContext context) {
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
              color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.search_sharp),
                  hintText: "Search Location",
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.all(Radius.circular(20)),
                  // ),
                ),
                onChanged: (area) {
                  print(area);
                },
              ),
            ),
            Expanded(
              child: saved.isEmpty ? const Center(
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
              ): ListView.builder(
                itemCount: saved.length,
                itemBuilder: (context, index) {
                  return Card(
                    surfaceTintColor: Colors.blue[900],
                    elevation: 15,
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  );
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}
