import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather/service/weather.dart';

class Database {
  final _myData = Hive.box<List>('weather');

  // a list that refers to the saved list
  List<Weather> saved = [];

  // initializing the data
  Future<void> initialization () async {
    await Hive.initFlutter();
  }
  void loadData () {
    // loading the stored data
    final dynamic tempHold = _myData.get('MyLocation'); // data stored is loaded into the variable
    if (tempHold is List && tempHold.isNotEmpty) {
      saved = List<Weather>.from(tempHold);
    } else {
      saved = [];
    }
  }

  void updateData () {
    // updating any changes made
    _myData.put('MyLocation', saved);
  }
}