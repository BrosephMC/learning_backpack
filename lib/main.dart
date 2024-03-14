import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

void main() {
  runApp(const LearningBackpackApp());
}

class LearningBackpackApp extends StatelessWidget {
  const LearningBackpackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState()..setTrailMapFromList(
        [
          [ 'Title 1', 'Task 1.1', 'Task 1.2', 'Task 1.3', 'Task 1.4', 'Task 1.5', 'Task 1.6' ],
          [ 'Title 2', 'Task 2.1', 'Task 2.2', 'Task 2.3', 'Surprise, Task 2.7' ]
        ]
      ),
      child: const MaterialApp(
        home: BottomNavigationBarExample(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  int numSections = 0;
  List<int> subsectionsPerSection = [];
  List< List<bool> > trailMapSelected = [ [] ];
  List<String> sectionTitles = [];
  List< List<String> > subsectionTitlesPerSection = [ [] ];

  List<PlatformFile> files = [];

  void setTrailMapFromList(List< List<String> > trailMapDesc) {
    numSections = trailMapDesc.length;

    subsectionsPerSection = List<int>.generate(
      numSections,
      (int index) => trailMapDesc[index].length - 1
    );

    sectionTitles = List<String>.generate(
      numSections,
      (int index) => trailMapDesc[index][0]
    );

    subsectionTitlesPerSection = List< List<String> >.generate(
      numSections,
      (int outIndex) => List<String>.generate(
        subsectionsPerSection[outIndex],
        (int inIndex) => trailMapDesc[outIndex][inIndex + 1]
      )
    );

    initTrailMapList();
  }

  void initTrailMapList() {
    trailMapSelected = List< List<bool> >.generate(
      numSections,
      (int index) => List<bool>.generate(subsectionsPerSection[index], (int index) => false)
    );

    notifyListeners();
  }
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
    var appState = context.watch<MyAppState>();
    var sectionTitles = appState.sectionTitles;
    var numSections = appState.numSections;
    var subsectionTitlesPerSection = appState.subsectionTitlesPerSection;

    return DefaultTabController(
      initialIndex: 0,
      length: numSections,
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
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: <Widget>[
              for (int i = 0; i < numSections; i++)
                Tab(
                  icon: const Icon(Icons.book),
                  child: Text(sectionTitles[i])
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            for (int i = 0; i < numSections; i++)
              Center(
                child: TrailMapSection(
                  trailMapIndex: i,
                  title: sectionTitles[i],
                  children: <TrailMapSubsection>[
                    for (var task in subsectionTitlesPerSection[i])
                      TrailMapSubsection( title: task ),
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