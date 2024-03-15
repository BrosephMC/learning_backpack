import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


class MyAppState extends ChangeNotifier {
  int numcategorys = 0;
  List<int> tasksPercategory = [];
  List< List<int> > numDescriptionsPertask = [ [] ];
  List< List<int> > trailMapSelected = [ [] ];
  List<String> categoryTitles = [];
  List< List<String> > taskTitlesPercategory = [ [] ];
  List< List< List<String> > > taskDescriptionsPertask = [ [ [] ] ];

  List<PlatformFile> files = [];

  void setTrailMapFromList(List< List< List<String> > > trailMapDesc) {
    numcategorys = trailMapDesc.length;

    tasksPercategory = List<int>.generate(
      numcategorys,
      (int index) => trailMapDesc[index].length - 1
    );

    categoryTitles = List<String>.generate(
      numcategorys,
      (int index) => trailMapDesc[index][0][0]
    );

    taskTitlesPercategory = List< List<String> >.generate(
      numcategorys,
      (int outIndex) => List<String>.generate(
        tasksPercategory[outIndex],
        (int inIndex) => trailMapDesc[outIndex][inIndex + 1][0]
      )
    );

    numDescriptionsPertask = List< List<int> >.generate(
      numcategorys,
      (int categoryIndex) => List<int>.generate(
        tasksPercategory[categoryIndex],
        (int taskIndex) => trailMapDesc[categoryIndex][taskIndex + 1].length - 1
      )
    );

    taskDescriptionsPertask = List< List< List<String> > >.generate(
      numcategorys,
      (int categoryIndex) => List< List<String> >.generate(
        tasksPercategory[categoryIndex],
        (int taskIndex) => List<String>.generate(
          numDescriptionsPertask[categoryIndex][taskIndex],
          (int taskDescIndex) => trailMapDesc[categoryIndex][taskIndex + 1][taskDescIndex + 1]
        )
      )
    );

    trailMapSelected = List< List<int> >.generate(
      numcategorys,
      (int index) => List<int>.generate(tasksPercategory[index], (int index) => 0)
    );

    notifyListeners();
  }
}
