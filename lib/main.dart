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
    //trail map
    TrailMapPage(),

    //notifications page placeholder
    BackPackPage(),

    //badges page
    Text(
      'Index 2: Badges',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Trail Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cases),
            label: 'Backpack',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.radio_button_unchecked),
            label: 'Badges',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBar Sample'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.book),
              ),
              Tab(
                icon: Icon(Icons.person),
              ),
              Tab(
                icon: Icon(Icons.east),
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
