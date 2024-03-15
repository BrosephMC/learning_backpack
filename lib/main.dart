import 'package:flutter/material.dart'; // Needed for widgets
import 'package:provider/provider.dart'; // Needed for ChangeNotifierProvider for MyAppState

// Necessary modules from this project
import 'package:learning_backpack/app_state.dart';
import 'package:learning_backpack/journeys_page.dart';
import 'package:learning_backpack/trail_map_page.dart';
import 'package:learning_backpack/backpack_page.dart';
import 'package:learning_backpack/utilities.dart';



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
      // Default to loading the Journeys from assets/sample3.txt when creating the app
      create: (context) => MyAppState()..loadJourneys(
        parseJourneys("assets/sample3.txt")!
      ),

      // Wrapping everything in a SafeArea ensures that our UI will never overlap
      // any hardware obstructions, like The Notch on an iPhone
      child: const SafeArea(
        child: MaterialApp(
          home: BottomNavigationBarExample(),
        ),
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

class _BottomNavigationBarExampleState extends State<BottomNavigationBarExample> {
  // What page is currently loaded
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  // A list of the pages in the app
  static const List<Widget> _widgetOptions = <Widget>[
    JourneysPage(),

    TrailMapPage(),

    BackpackPage(),

    // Placeholder content for the Badges page
    Text(
      'Badges and Social',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body is set to the currently loaded page
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      // Tabs at the bottom of the screen
      bottomNavigationBar: NavigationBar(
        // Change to the corresponding page when each tab is clicked
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: _selectedIndex,

        // The tab buttons to click to switch pages, with icon and label
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
