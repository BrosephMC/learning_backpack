import 'package:flutter/material.dart';
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
      create: (context) => MyAppState()..setTrailMapFromList(
        // [
        //   [ 'Title 1', 'Task 1.1', 'Task 1.2', 'Task 1.3', 'Task 1.4', 'Task 1.5', 'Task 1.6' ],
        //   [ 'Title 2', 'Task 2.1', 'Task 2.2', 'Task 2.3', 'Surprise, Task 2.7' ]
        // ]
        // readFromFile(p.join(Directory.current.path, 'assets', 'sample.txt')),
        [
          [ 
            [ 'Language' ],
            [
                'Complete Duolingo course',
                'Go to this link: duolingo.com/hereIsSomeLink',
                'Complete up to Chapter 5',
                'Here is some more lines'
            ],
            [
                'Read [this book] on the language',
                'Here is some additional info about the book',
                'Idk what else to say'
            ],
          ],

          [
            [ 'Mission' ],
            [
              'Attend SIM conference',
              'Go to this bi-annual SIM conference',
              'Here is the date: [some date]',
              'Here is the time: [some time]',
              'Here is the address: [some address]'
            ],
            [
              'Learn how to write newsletters',
              'Watch this video: youtube.com/blahblah'
            ],
            [
              'Find a host church',
              'Find a host church (or multiple) to support you in your mission',
              'Here is a helpful article for how to ask for support: somelink.com/somelink'
            ],
            [
              'I need filler',
              'Here\'s some filler',
              'Here\'s some more',
              'And some more',
              'Filler',
              'Filler',
              'Filler'
            ]
          ],

          [
            [ 'Lipsum' ],
            [
              'Lorem ipsum',
              'Lorem ipsum dolor sit amet',
              'Consectetur adipiscing elit',
              'Ut imperdiet ante mi, ac luctus dui ultrices id',
              'Duis eu faucibus orci',
              'Sed et sagittis est, id tempus purus'
            ],
            [
              'Vestibulum gravida maximus scelerisque',
              'Nullam accumsan luctus lectus, id aliquam odio blandit vel',
              'Donec sollicitudin ipsum eget mauris gravida ullamcorper',
              'Aenean imperdiet purus ac nibh iaculis, sit amet pharetra elit facilisis',
              'Etiam ornare urna diam, ut aliquet lacus interdum id',
              'Fusce eget aliquet nisl, in ultrices nulla',
              'Praesent vel luctus turpis, id placerat ligula',
              'Quisque sagittis odio nec erat malesuada iaculis'
            ],
            [
              'AAAAAAAAA',
              'AAA',
              'AAA',
              'AAA',
              'AAA',
              'AAA',
              'AAA',
              'AAA',
              'AAA',
              'AAA'
            ]
          ]
        ]
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
