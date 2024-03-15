import 'package:flutter/material.dart';
import 'package:learning_backpack/utilities.dart';
//#import 'dart:io';

import 'package:provider/provider.dart';
//#import 'package:file_picker/file_picker.dart';
//#import 'package:open_file/open_file.dart';
//#import 'package:path/path.dart';
//#import 'package:path_provider/path_provider.dart';

import 'package:learning_backpack/app_state.dart';
import 'package:learning_backpack/journeys_page.dart';
import 'package:learning_backpack/trail_map_page.dart';
import 'package:learning_backpack/backpack_page.dart';

//
// runApp()
//
void main() {
  runApp(const LearningBackpackApp());
}



//
// Learning Backpack App
//
class LearningBackpackApp extends StatelessWidget {
  const LearningBackpackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState()..selectTrailMap(
        parseJourneys("assets/sample2.txt")![0].trails[1]
      ),
      child: const MaterialApp(
        home: BottomNavigationBarExample(),
      ),
    );
  }
}



//
// Home (Bottom Navigation Bar Example)
//
class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    JourneysPage(),

    TrailMapPage(),

    BackpackPage(),

    Text(
      'Badges and Social',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('BottomNavigationBar Sample'),
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.travel_explore),
            label: 'Journeys',
            tooltip: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'Trail Map',
            tooltip: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.luggage),
            label: 'Backpack',
            tooltip: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.military_tech),
            label: 'Badges',
            tooltip: '',
          ),
        ],
      ),
    );
  }
}
