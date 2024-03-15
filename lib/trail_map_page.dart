import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learning_backpack/app_state.dart';
import 'package:learning_backpack/utilities.dart';

class TrailMapPage extends StatelessWidget {
  const TrailMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var categoryTitles = appState.categoryTitles;
    var numcategorys = appState.numcategorys;
    var taskTitlesPercategory = appState.taskTitlesPercategory;
    var tasksPercategory = appState.tasksPercategory;
    var numDescriptionsPertask = appState.numDescriptionsPertask;
    var taskDescriptionsPertask = appState.taskDescriptionsPertask;

    return DefaultTabController(
      initialIndex: 0,
      length: numcategorys,
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
              for (int i = 0; i < numcategorys; i++)
                Tab(
                  icon: getIconFromWord(categoryTitles[i]),
                  child: Text(categoryTitles[i])
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            for (int i = 0; i < numcategorys; i++)
              Center(
                child: TrailMapcategory(
                  title: categoryTitles[i],
                  children: <TrailMaptask>[
                    for (int j = 0; j < tasksPercategory[i]; j++)
                      TrailMaptask(
                        title: taskTitlesPercategory[i][j],
                        descriptionList: <String>[
                          for (int k = 0; k < numDescriptionsPertask[i][j]; k++)
                            taskDescriptionsPertask[i][j][k],
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

class TrailMapcategory extends StatelessWidget {
  final String title;
  final List<TrailMaptask> children;

  const TrailMapcategory({
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

class TrailMaptask extends StatefulWidget {
  final String title;
  final List<String> descriptionList; // One element per line
  final int trailMapIndex;
  final int trailMapSubindex;

  const TrailMaptask({
    super.key,
    required this.title,
    required this.descriptionList,
    required this.trailMapIndex,
    required this.trailMapSubindex
  });

  @override
  State<TrailMaptask> createState() => _TrailMaptaskState();
}

class _TrailMaptaskState extends State<TrailMaptask> {
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
