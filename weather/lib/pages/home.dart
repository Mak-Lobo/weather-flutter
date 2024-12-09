import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 8, 0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, "/location");
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
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue.withOpacity(0.3)),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 50, 10, 0),
              child: Column(
                children: [
                  Text(
                    "Weather Today",
                    style: TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(255, 176, 196, 222),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.5,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "THIKA",
                            style: TextStyle(
                              fontFamily: "DM Serif Display",
                              fontSize: 32,
                              color: Color.fromARGB(255, 10, 101, 109),
                            ),
                          ),
                          Text(
                            "June 12 2023",
                            style: TextStyle(
                              fontFamily: "DM Serif Display",
                              // color: Color.fromRGBO(127, 155, 158, 255),
                              color: Color.fromARGB(255, 10, 101, 109),
                              fontSize: 24,
                            ),
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
