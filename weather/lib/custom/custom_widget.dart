import 'package:flutter/material.dart';

class HeadText extends StatelessWidget {
  final String text;
  final bool softwrap;
  const HeadText({super.key, required this.text, this.softwrap = true}) ;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "DM Serif Display",
        fontSize: 32,
        color: Colors.black,
      ),
      softWrap: softwrap,
    );
  }
}

class SmallHeadText extends StatelessWidget {
  final String text;
  final bool softWrap;
  const SmallHeadText({super.key, required this.text, this.softWrap = true});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "DM Sans",
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      softWrap: softWrap,
    );
  }
}

//list tile tiles
class TileTitle extends StatelessWidget {
  final String title;
  const TileTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: "DM Serif Display",
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }
}

// list tile subtitle
class TileSubtitle extends StatelessWidget {
  final String subtitle;
  const TileSubtitle({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      style: const TextStyle(
        fontFamily: "DM Poppins",
        fontSize: 15,
        color: Colors.black,
      ),
    );
  }
}

// custom card
class CustomCard extends StatelessWidget {
  final Widget child;
  const CustomCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[400],
      elevation: 15,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: child,
    );
  }
}




