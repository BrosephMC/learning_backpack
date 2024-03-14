import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

void main() => runApp(const LearningBackpackApp());

class LearningBackpackApp extends StatelessWidget {
  const LearningBackpackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: const MaterialApp(
        home: BottomNavigationBarExample(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  static const int numSections = 5;
  static const List<int> numSubsections = [7, 3, 4, 2, 5];
  List< List<bool> > trailMapSelected = List< List<bool> >.generate(
    numSections,
    (int index) => List<bool>.generate(numSubsections[index], (int index) => false)
  );
  List<PlatformFile> files = [];
}

class TrailMapSection extends StatefulWidget {
  final String title;
  final List<TrailMapSubsection> children;
  final int trailMapIndex;

  const TrailMapSection({
    super.key,
    required this.title,
    required this.children,
    required this.trailMapIndex
  });

  @override
  State<TrailMapSection> createState() => _TrailMapSectionState();
}

class _TrailMapSectionState extends State<TrailMapSection> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final int numItems = widget.children.length;
    List<bool> selected = appState.trailMapSelected[widget.trailMapIndex];//List<bool>.generate(numItems, (int index) => false);

    return SingleChildScrollView(
      child: DataTable(
        onSelectAll: (bool? value) {},

        columns: <DataColumn>[
          DataColumn(
            label: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
              )
            )
          ),
        ],
        rows: List<DataRow>.generate(
          numItems,
          (int index) => DataRow(
            color: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              // All rows will have the same selected color.
              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.12);
              }
              return null; // Use default value for other states
            }),
            cells: <DataCell>[
              DataCell(
                TrailMapSubsection(title: widget.children[index].title)
              )
            ],
            selected: selected[index],
            onSelectChanged: (bool? value) {
              setState(() {
                selected[index] = value!;
                appState.trailMapSelected[widget.trailMapIndex][index] = value;
              });
            },
          ),
        ),
      ),
    );
  }
}

class TrailMapSubsection extends StatelessWidget {
  final String title;

  const TrailMapSubsection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontStyle: FontStyle.italic
        )
      )
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
    JourneyPage(),

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
            label: 'Journey',
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
      initialIndex: 0,
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
                  "Trail Title - 50% Done",
                  style: TextStyle(fontSize: 20),
                ),
                Padding(padding: EdgeInsets.all(5.0)),
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
              child: TrailMapSection(
                trailMapIndex: 0,
                title: 'Learn the Language',
                children: [
                  TrailMapSubsection( title: 'Complete Duolingo course' ),
                  TrailMapSubsection( title: 'Have a conversation with someone fluent in the language' ),
                  TrailMapSubsection( title: 'Write a story in the language' ),
                  TrailMapSubsection( title: 'Do something else' ),
                  TrailMapSubsection( title: 'Do something else again' ),
                  TrailMapSubsection( title: 'Do more stuff' ),
                  TrailMapSubsection( title: 'Finish the rest of the stuff' )
                ]
              ),
            ),
            Center(
              child: TrailMapSection(
                trailMapIndex: 1,
                title: 'Know the People',
                children: <TrailMapSubsection>[
                  TrailMapSubsection( title: 'Read [this book] on the country' ),
                  TrailMapSubsection( title: 'Talk with [this missionary] who has been to the country' ),
                  TrailMapSubsection( title: 'Take this quiz on the country\'s culture' )
                ]
              ),
            ),
            Center(
              child: TrailMapSection(
                trailMapIndex: 2,
                title: 'Prepare for Missions',
                children: <TrailMapSubsection>[
                  TrailMapSubsection( title: 'Attend bi-annual SIM conference' ),
                  TrailMapSubsection( title: 'Go to training event on [specific date]' ),
                  TrailMapSubsection( title: 'Find host churches to support your mission' ),
                  TrailMapSubsection( title: 'Write your first newsletter' )
                ]
              )
            ),
            Center(
              child: TrailMapSection(
                trailMapIndex: 3,
                title: 'Text',
                children: <TrailMapSubsection>[
                  TrailMapSubsection( title: 'Text' ),
                  TrailMapSubsection( title: 'Text' )
                ]
              )
            ),
            Center(
              child: TrailMapSection(
                trailMapIndex: 4,
                title: 'Text',
                children: <TrailMapSubsection>[
                  TrailMapSubsection( title: 'Text' ),
                  TrailMapSubsection( title: 'Text' ),
                  TrailMapSubsection( title: 'Text' ),
                  TrailMapSubsection( title: 'Text' ),
                  TrailMapSubsection( title: 'Text' )
                ]
              )
            ),
          ],
        ),
      ),
    );
  }
}

class DataTableExample extends StatefulWidget {
  const DataTableExample({super.key});

  @override
  State<DataTableExample> createState() => _DataTableExampleState();
}

class _DataTableExampleState extends State<DataTableExample> {
  static const int numItems = 20;
  List<bool> selected = List<bool>.generate(numItems, (int index) => false);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text('Number'),
          ),
        ],
        rows: List<DataRow>.generate(
          numItems,
          (int index) => DataRow(
            color: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              // All rows will have the same selected color.
              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
              }
              // Even rows will have a grey color.
              if (index.isEven) {
                return Colors.grey.withOpacity(0.3);
              }
              return null; // Use default value for other states and odd rows.
            }),
            cells: <DataCell>[DataCell(Text('Row $index'))],
            selected: selected[index],
            onSelectChanged: (bool? value) {
              setState(() {
                selected[index] = value!;
              });
            },
          ),
        ),
      ),
    );
  }
}

class JourneyPage extends StatelessWidget {
  const JourneyPage({super.key});

  // final JourneyPageType type;

  @override
  Widget build(BuildContext context) {
    // final localizations = GalleryLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        // title: const Text("title"),
        title: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Journey - 25% Done",
                  style: TextStyle(fontSize: 20),
                ),
                Padding(padding: EdgeInsets.all(5.0)),
                CircularProgressIndicator(
                  value: 0.25,
                  semanticsLabel: 'Linear progress indicator',
                  color: Colors.blue,
                  backgroundColor: Colors.grey,
                ),
              ],
            ),
          ),
      ),
      // body: Scrollbar(
        body: ListView(
          restorationId: 'list_demo_list_view',
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            for (int index = 1; index < 21; index++)
              ListTile(
                onTap: () {
                  print("$index was pressed!");
                },
                leading: ExcludeSemantics(
                  child: CircleAvatar(child: Text('$index')),
                ),
                title: Text(
                  index.toString(),
                ),
                subtitle: const Text("text"),
              ),
          ],
        ),
      // ),
    );
  }
}

class BackpackPage extends StatefulWidget{
  const BackpackPage({super.key});

  @override
   State<BackpackPage> createState() => _BackpackPageState();
}

class _BackpackPageState extends State<BackpackPage>{
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    List<PlatformFile> files = appState.files;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text('Backpack', style: TextStyle(fontSize: 20),),
          ),
          Expanded(
            child: ListView(
              children:[
                for(var file in files)
                  ListTile(
                    leading: const Icon(Icons.feed),
                    title: Text(file.name),
                    onTap: () => openTheFile(file)
                  ),
              ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: FloatingActionButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(allowMultiple: true);
                if(result == null) return;
                setState((){
                  files += result.files;
                  appState.files = files;
                });
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
  void openTheFile(PlatformFile file){
    OpenFile.open(file.path);
  }
}