import 'package:flutter/material.dart';

/// Flutter code sample for [BottomNavigationBar].

void main() => runApp(const BottomNavigationBarExampleApp());

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarExample(),
    );
  }
}

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
    Text(
      'Trip Planning and Settings',
      style: optionStyle,
    ),

    TrailMapPage(),

    BackPackPage(),

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
            label: 'Trip Planning',
            tooltip: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'Trail Map',
            tooltip: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag),
            label: 'Backpack',
            tooltip: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.radio_button_unchecked),
            label: 'Badges',
            tooltip: '',
          ),
        ],
      ),
    );
  }
}

class TrailMapPage extends StatelessWidget {
  const TrailMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          // title: const Text('TabBar Sample'),
          title: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Your Progress",
                  style: TextStyle(fontSize: 20),
                ),
                LinearProgressIndicator(
                  value: 0.5,
                  semanticsLabel: 'Linear progress indicator',
                ),
              ],
            ),
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.book),
                child: Text("Language"),
              ),
              Tab(
                icon: Icon(Icons.person),
                child: Text("People"),
              ),
              Tab(
                icon: Icon(Icons.east),
                child: Text("Mission"),
              ),
              Tab(
                icon: Icon(Icons.abc),
                child: Text("Text"),
              ),
              Tab(
                icon: Icon(Icons.abc),
                child: Text("Text"),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text("Language"),
            ),
            Center(
              child: Text("People"),
            ),
            Center(
              child: Text("Mission"),
            ),
            Center(
              child: Text("Text"),
            ),
            Center(
              child: Text("Text"),
            ),
          ],
        ),
      ),
    );
  }
}

class BackPackPage extends StatelessWidget {
  const BackPackPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications_sharp),
              title: Text('Notification 1'),
              subtitle: Text('This is a notification'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications_sharp),
              title: Text('Notification 2'),
              subtitle: Text('This is a notification'),
            ),
          ),
        ],
      ),
    );
  }
}
