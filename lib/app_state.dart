import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


class MyAppState extends ChangeNotifier {
  int numSections = 0;
  List<int> subsectionsPerSection = [];
  List< List<int> > numDescriptionsPerSubsection = [ [] ];
  List< List<int> > trailMapSelected = [ [] ];
  List<String> sectionTitles = [];
  List< List<String> > subsectionTitlesPerSection = [ [] ];
  List< List< List<String> > > subsectionDescriptionsPerSubsection = [ [ [] ] ];

  List<PlatformFile> files = [];

  void setTrailMapFromList(List< List< List<String> > > trailMapDesc) {
    numSections = trailMapDesc.length;

    subsectionsPerSection = List<int>.generate(
      numSections,
      (int index) => trailMapDesc[index].length - 1
    );

    sectionTitles = List<String>.generate(
      numSections,
      (int index) => trailMapDesc[index][0][0]
    );

    subsectionTitlesPerSection = List< List<String> >.generate(
      numSections,
      (int outIndex) => List<String>.generate(
        subsectionsPerSection[outIndex],
        (int inIndex) => trailMapDesc[outIndex][inIndex + 1][0]
      )
    );

    numDescriptionsPerSubsection = List< List<int> >.generate(
      numSections,
      (int sectionIndex) => List<int>.generate(
        subsectionsPerSection[sectionIndex],
        (int subsectionIndex) => trailMapDesc[sectionIndex][subsectionIndex + 1].length - 1
      )
    );

    subsectionDescriptionsPerSubsection = List< List< List<String> > >.generate(
      numSections,
      (int sectionIndex) => List< List<String> >.generate(
        subsectionsPerSection[sectionIndex],
        (int subsectionIndex) => List<String>.generate(
          numDescriptionsPerSubsection[sectionIndex][subsectionIndex],
          (int subsectionDescIndex) => trailMapDesc[sectionIndex][subsectionIndex + 1][subsectionDescIndex + 1]
        )
      )
    );

    trailMapSelected = List< List<int> >.generate(
      numSections,
      (int index) => List<int>.generate(subsectionsPerSection[index], (int index) => 0)
    );

    notifyListeners();
  }
}
