// import 'dart:js_util';

import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:learning_backpack/utilities.dart';


class MyAppState extends ChangeNotifier {
  List<Journey> journeys = [];
  Trail selectedTrail = Trail("title", []);
  
  void selectTrailMap(Trail trailParam){
    selectedTrail = trailParam;
    notifyListeners();
    print("selectedTrail from appstate $selectedTrail");
  }
  void loadJourneys(List<Journey> journeysParam){
    journeys = journeysParam;
    notifyListeners();
  }
}
