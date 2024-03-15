import 'package:flutter/material.dart'; // Needed for widgets
import 'package:provider/provider.dart'; // Needed to watch MyAppState

// Necessary modules from this project
import 'package:learning_backpack/app_state.dart';
import 'package:learning_backpack/utilities.dart';



class JourneysPage extends StatefulWidget {
  const JourneysPage({super.key});

  @override
  State<JourneysPage> createState() => _JourneysPageState();
}

class _JourneysPageState extends State<JourneysPage> {
  int _selectedIndex = 0; // Which journey (set of trails) is being viewed
  var journeys = [];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    journeys = appState.journeys; // Get loaded journeys from global appState
    print("selectedtrail journeys ${appState.selectedTrail}");

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
                // STUB
                // Currently does nothing - ideally would allow adding a new Journey
              },
              tooltip: "Import new Journey WIP",
              child: const Icon(Icons.add),
            ),
            destinations: _buildNavRailDestinations(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _getPage(_selectedIndex, appState),
          ),
        ],
      ),
    );
  }

  // Side panel which shows loaded journeys
  List<NavigationRailDestination> _buildNavRailDestinations() {
    List<NavigationRailDestination> destinations = [
      for(var journey in journeys)
        NavigationRailDestination(
        icon: getIconFromWord(journey.name),
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

  Widget _getPage(int index, appState) {
    return ListView(
      restorationId: 'list_demo_list_view',
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        Column( // Journey title and progress bar
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "${journeys[index].name} Journey",
                  style: const TextStyle(fontSize: 20),
                ),
                Text("${(journeys[index].getPercentage()*100).toInt()}% Done"),
                const Padding(padding: EdgeInsets.all(5.0)),
                LinearProgressIndicator(
                  value: journeys[index].getPercentage(),
                  semanticsLabel: 'Linear progress indicator',
                ),
              ],
            ),
        for (int i = 0; i < journeys[index].trails.length; i++) // List of trails
          Container(
            color: journeys[index].trails[i] == appState.selectedTrail ? Colors.blueGrey : Colors.transparent, // change color if trail is selected
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: ListTile(
                onTap: () { // selectedTrail is loaded into trail map page on tap/click
                  appState.selectTrailMap(
                    journeys[index].trails[i]
                  );
                },
                visualDensity: VisualDensity.comfortable,
                leading: ExcludeSemantics(
                  child: CircleAvatar(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator( // Shows progress of individual trail
                            value: journeys[index].trails[i].getPercentage(),
                            color: Colors.green,
                            backgroundColor: Colors.grey,
                            strokeWidth: 10.0,
                          ),
                          const Icon(Icons.park, size: 40.0, color: Color.fromARGB(255, 83, 83, 83),),
                          Center(
                            child: Text(
                              "${i + 1}",
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
                            "Trail: ${journeys[index].trails[i].name}  ", 
                            maxLines: 5, 
                            softWrap: true,
                            style: TextStyle(color: journeys[index].trails[i] == appState.selectedTrail ? Colors.white : null,) // change color if trail is selected
                          ),
                      ),
                    ],
                  ),
                ),
            ),
          )
      ],
    );
  }
}
