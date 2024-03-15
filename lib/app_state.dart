import 'package:flutter/material.dart';
import 'package:learning_backpack/utilities.dart';


// Keeps track of user session data
class MyAppState extends ChangeNotifier {
  // All of the journeys imported from file
  List<Journey> journeys = [];

  // The currently selected trail, shown on the Trail Map page
  Trail selectedTrail = Trail("title", []);
  
  // Select a new trail when the user clicks a trail on the Journeys page
  void selectTrailMap(Trail trailParam){
    selectedTrail = trailParam;
    notifyListeners();
    print("selectedTrail from appstate $selectedTrail");
  }

  // Update the list of journeys to a new list
  void loadJourneys(List<Journey> journeysParam){
    journeys = journeysParam;
    notifyListeners();
  }
}
