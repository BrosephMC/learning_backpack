import 'package:flutter/material.dart';
import 'package:learning_backpack/utilities.dart';

class JourneysPage extends StatefulWidget {
  const JourneysPage({super.key});

  @override
  State<JourneysPage> createState() => _JourneysPageState();
}

class _JourneysPageState extends State<JourneysPage> {
  int _selectedIndex = 0;
  var import = parseJourneys("assets/sample2.txt");

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
      for(var journey in import!)
        NavigationRailDestination(
        icon: const Icon(Icons.public),
        label: SizedBox(
          width: 120.0,
          child: Text(
            journey.name,
            maxLines: 1,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ];
    return destinations;
  }

  Widget _getPage(int index) {
    return ListView(
      restorationId: 'list_demo_list_view',
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "${import![index].name} Journey",
                  style: const TextStyle(fontSize: 20),
                ),
                const Text("25% Done"),
                const Padding(padding: EdgeInsets.all(5.0)),
                const LinearProgressIndicator(
                  value: 0.5,
                  semanticsLabel: 'Linear progress indicator',
                ),
              ],
            ),
        for (int i = 0; i < import![index].trails.length; i++)
          ListTile(
            onTap: () {
              // print("$index was pressed!");
            },
            visualDensity: VisualDensity.comfortable,
            leading: ExcludeSemantics(
              child: CircleAvatar(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const CircularProgressIndicator(
                        value: 0.25,
                        color: Colors.green,
                        backgroundColor: Colors.grey,
                        strokeWidth: 10.0,
                        // strokeCap: StrokeCap.round,
                      ),
                      const Icon(Icons.park, size: 40.0, color: Color.fromARGB(255, 83, 83, 83),),
                      Center(
                        child: Text(
                          "$i",
                          style: const TextStyle(color: Colors.white),
                        )
                      ),
                    ],
                  )
              ),
            ),
            title: 
              Row(
                children: [
                  Flexible(
                    child:
                      Text(
                        "Trail: ${import![index].trails[i].name}  ", 
                        maxLines: 5, 
                        softWrap: true,
                      ),
                  ),
                ],
              ),
            )
      ],
    );
  }
}