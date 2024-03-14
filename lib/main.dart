import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

void main() {
  runApp(const LearningBackpackApp());
}

List<List<String>> readFromFile(String filePath) {
  var file = File(filePath);
  var lines = file.readAsLinesSync();

  List<List<String>> result = [];
  List<String> currentList = [];

  for (var line in lines) {
    line = line.trimLeft();
    if (line.isNotEmpty) {
      currentList.add(line);
    } else if (currentList.isNotEmpty) {
      result.add(List.from(currentList));
      currentList.clear();
    }
  }

  if (currentList.isNotEmpty) {
    result.add(List.from(currentList));
  }

  return result;
}

Icon getIconFromWord(String category){
  if(RegExp("food", caseSensitive: false).hasMatch(category)){
    return const Icon(Icons.fastfood);
  }
  if(RegExp("language", caseSensitive: false).hasMatch(category)
  || RegExp("read", caseSensitive: false).hasMatch(category)
  || RegExp("word", caseSensitive: false).hasMatch(category)){
    return const Icon(Icons.menu_book);
  }
  if(RegExp("navigation", caseSensitive: false).hasMatch(category)
  || RegExp("travel", caseSensitive: false).hasMatch(category)){
    return const Icon(Icons.explore);
  }
  if(RegExp("mission", caseSensitive: false).hasMatch(category)){
    return const Icon(Icons.public);
  }
  if(RegExp("faith", caseSensitive: false).hasMatch(category)
  || RegExp("church", caseSensitive: false).hasMatch(category)){
    return const Icon(Icons.church);
  }
  if(RegExp("people", caseSensitive: false).hasMatch(category)){
    return const Icon(Icons.person);
  } else {
    return const Icon(Icons.filter_hdr);
    // return const Icon(Icons.forest);
  }
}

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

class TrailMapSection extends StatelessWidget {
  final String title;
  final List<TrailMapSubsection> children;

  const TrailMapSection({
    super.key,
    required this.title,
    required this.children
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            for (var child in children) child,
          ]
        ),
      ]
    );
  }
}

class TrailMapSubsection extends StatefulWidget {
  final String title;
  final List<String> descriptionList; // One element per line
  final int trailMapIndex;
  final int trailMapSubindex;

  const TrailMapSubsection({
    super.key,
    required this.title,
    required this.descriptionList,
    required this.trailMapIndex,
    required this.trailMapSubindex
  });

  @override
  State<TrailMapSubsection> createState() => _TrailMapSubsectionState();
}

class _TrailMapSubsectionState extends State<TrailMapSubsection> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    int selected = appState.trailMapSelected[widget.trailMapIndex][widget.trailMapSubindex];
    const List<String> messages = [ 'Not Started', 'In Progress', 'Complete' ];
    final List<Color> colors =[ Colors.red, Colors.orange, Colors.lightGreen[700]! ];
    const List<double> opacities = [ 0.22, 0.25, 0.32 ];
    const List<Icon> icons = [ Icon(Icons.close_rounded), Icon(Icons.hourglass_bottom_rounded), Icon(Icons.check_rounded) ];

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ExpansionTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 18
            ),
          ),
        ),
      
        subtitle: Row(
          children: <Widget>[
            const SizedBox(
              width: 15
            ),
      
            for (int i = 0; i < 3; i++)
              Tooltip(
                message: messages[i],
                child: Container(
                  decoration: BoxDecoration(
                    color: selected == i ? colors[i].withOpacity(opacities[i]) : Colors.transparent,
                    shape: BoxShape.circle
                  ),
                  child: IconButton(
                    icon: icons[i],
                    color: selected == i ? colors[i] : Colors.grey,
                    onPressed: () {
                      setState(() {
                        selected = i;
                        appState.trailMapSelected[widget.trailMapIndex][widget.trailMapSubindex] = i;
                      });
                    },
                  )
                )
              ),
          ]
        ),
      
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(230, 230, 230, 1)
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(60, 10, 0, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Time Spent: 1.5 hours',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 16
                            ),
                          ),
                      
                          const SizedBox(
                            height: 15
                          ),
                      
                          const Text(
                            'Task Description:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 16
                            ),
                          ),
                      
                          for (var desc in widget.descriptionList)
                            Text(
                              desc,
                              style: const TextStyle(
                                fontSize: 15
                              )
                            ),
                        ]
                      ),
                    ),

                    const SizedBox(width: 25),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'My Notes:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: 16
                              ),
                            ),

                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: const Color.fromARGB(255, 34, 0, 126)),
                                borderRadius: const BorderRadius.all(Radius.circular(15))
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: TextField(
                                  decoration: null,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: null
                                ),
                              ),
                            ),
                          ]
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ]
      ),
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

class TrailMapPage extends StatelessWidget {
  const TrailMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var sectionTitles = appState.sectionTitles;
    var numSections = appState.numSections;
    var subsectionTitlesPerSection = appState.subsectionTitlesPerSection;
    var subsectionsPerSection = appState.subsectionsPerSection;
    var numDescriptionsPerSubsection = appState.numDescriptionsPerSubsection;
    var subsectionDescriptionsPerSubsection = appState.subsectionDescriptionsPerSubsection;

    return DefaultTabController(
      initialIndex: 0,
      length: numSections,
      child: Scaffold(
        appBar: AppBar(
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
                  icon: getIconFromWord(sectionTitles[i]),
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
                  title: sectionTitles[i],
                  children: <TrailMapSubsection>[
                    for (int j = 0; j < subsectionsPerSection[i]; j++)
                      TrailMapSubsection(
                        title: subsectionTitlesPerSection[i][j],
                        descriptionList: <String>[
                          for (int k = 0; k < numDescriptionsPerSubsection[i][j]; k++)
                            subsectionDescriptionsPerSubsection[i][j][k],
                        ],
                        trailMapIndex: i,
                        trailMapSubindex: j,
                      ),
                  ]
                )
              ),
          ],
        ),
      ),
    );
  }
}

class JourneysPage extends StatefulWidget {
  const JourneysPage({super.key});

  @override
  State<JourneysPage> createState() => _JourneysPageState();
}

class _JourneysPageState extends State<JourneysPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            groupAlignment: 0.0, // Align items to the center
            leading: FloatingActionButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              tooltip: "Import new Journey WIP",
              child: const Icon(Icons.add),
            ),
            destinations: _buildNavRailDestinations(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _getPage(_selectedIndex),
          ),
        ],
      ),
    );
  }

  List<NavigationRailDestination> _buildNavRailDestinations() {
    // Define your list of navigation rail items here
    List<NavigationRailDestination> destinations = [
      const NavigationRailDestination(
        icon: Icon(Icons.public),
        label: SizedBox(
          width: 120.0,
          child: Text(
            "Very Long Label That Needs to Be Abbreviated",
            maxLines: 1,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.public),
        label: Text('Second Item'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.public),
        label: Text('Third Item'),
      ),
    ];
    return destinations;
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const Center(child: Text('Very Long Title That Doesn\'t Need to Be Abbreviated'));
      case 1:
        return ListView(
          // title: Text("title"),
          restorationId: 'list_demo_list_view',
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Journey Title - 25% Done",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                CircularProgressIndicator(
                  value: 0.25,
                  semanticsLabel: 'Linear progress indicator',
                  color: Colors.blue,
                  backgroundColor: Colors.grey,
                ),
              ],
            ),
            for (int index = 1; index < 11; index++)
              ListTile(
                onTap: () {
                  //print("$index was pressed!");
                },
                leading: ExcludeSemantics(
                  child: CircleAvatar(
                      child: Row(
                        children: [
                          const Icon(Icons.park),
                          Text('$index',)
                          ],
                      )
                  ),
                ),
                title: Text(
                  "trail $index",
                ),
              ),
          ],
        );
      case 2:
        return const Center(child: Text('Third Item'));
      default:
        return Container();
    }
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