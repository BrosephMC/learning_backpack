import 'package:flutter/material.dart'; // Needed for widgets
import 'package:provider/provider.dart'; // Needed to watch MyAppState
import 'package:flutter/services.dart'; // Needed for TextInputFormatter

// Project external files
import 'package:learning_backpack/app_state.dart';
import 'package:learning_backpack/utilities.dart';

class TrailMapPage extends StatelessWidget {
  const TrailMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var selectedTrail = appState.selectedTrail;
    print("selectedTrail from trail_map_page $selectedTrail");

    return DefaultTabController(
      initialIndex: 0,
      length: selectedTrail.categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Trail percent completion text
                Text(
                  "${selectedTrail.name} - ${(selectedTrail.getPercentage()*100).toInt()}%",
                  style: const TextStyle(fontSize: 20),
                ),

                const Padding(padding: EdgeInsets.all(5.0)),

                // Trail percent completion progress bar
                LinearProgressIndicator(
                  value: selectedTrail.getPercentage(),
                  semanticsLabel: 'Linear progress indicator',
                ),
              ],
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            
            // Create the tabs for the categories in the current trail
            tabs: <Widget>[
              for (int i = 0; i < selectedTrail.categories.length; i++)
                Tab(
                  // Intuitively assign an icon based on the name of the category
                  icon: getIconFromWord(selectedTrail.categories[i].name),
                  child: Text(
                    selectedTrail.categories[i].name,
                    
                    // Strikethrough the name if it is fully completed
                    style: selectedTrail.categories[i].getPercentage() == 1 ? const TextStyle(decoration: TextDecoration.lineThrough) : null,
                  )
                ),
            ],
          ),
        ),
        body: TabBarView(
          // Create different pages, one for each category in the trail
          children: <Widget>[
            // Loop through the trail categories
            for (int i = 0; i < selectedTrail.categories.length; i++)
              Center(
                child: TrailMapCategory(
                  title: selectedTrail.categories[i].name,
                  children: <TrailMapTask>[
                    // Loop through the tasks in the current trail category
                    for (int j = 0; j < selectedTrail.categories[i].tasks.length; j++)
                      TrailMapTask(
                        title: selectedTrail.categories[i].tasks[j].name,
                        descriptionList: selectedTrail.categories[i].tasks[j].description,
                        
                        // We need to keep track of what trail and category we are in
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



//
// Trail Category class
//
class TrailMapCategory extends StatelessWidget {
  final String title;
  final List<TrailMapTask> children;

  const TrailMapCategory({
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
            
            // Add the child widgets (tasks)
            for (var child in children) child,
          ]
        ),
      ]
    );
  }
}



//
// Trail Task class
//
class TrailMapTask extends StatefulWidget {
  final String title;
  final List<String> descriptionList; // If the description is multiple lines, each line is a new element in this list
  final int trailMapIndex;
  final int trailMapSubindex;

  const TrailMapTask({
    super.key,
    required this.title,
    required this.descriptionList,
    required this.trailMapIndex,
    required this.trailMapSubindex
  });

  @override
  State<TrailMapTask> createState() => _TrailMapTaskState();
}

class _TrailMapTaskState extends State<TrailMapTask> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    // Create TextField controllers
    final notesController = TextEditingController();
    final minutesSpentController = TextEditingController();

    // Load trail states from MyAppState, so that the value of the TextFields are retained throughout every build() and align with the saved values
    notesController.text = appState.selectedTrail.categories[widget.trailMapIndex].tasks[widget.trailMapSubindex].notes;
    minutesSpentController.text = appState.selectedTrail.categories[widget.trailMapIndex].tasks[widget.trailMapSubindex].minutesSpent.toString();

    // The status of this task (0 = Not Started, 1 = In Progress, 2 = Completed)
    int status = appState.selectedTrail.categories[widget.trailMapIndex].tasks[widget.trailMapSubindex].status;
    
    // The styles for each of the three Status buttons, in order from 0-2
    const List<String> messages = [ 'Not Started', 'In Progress', 'Complete' ];
    final List<Color> colors =[ Colors.red, Colors.orange, Colors.lightGreen[700]! ];
    const List<double> opacities = [ 0.22, 0.25, 0.32 ];
    const List<Icon> icons = [ Icon(Icons.close_rounded), Icon(Icons.hourglass_bottom_rounded), Icon(Icons.check_rounded) ];

    return Padding(
      padding: const EdgeInsets.all(8),

      // An ExpansionTile will toggle showing its `children` when clicked
      child: ExpansionTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 5),

          // The title of this task
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
            // Vertical spacer
            const SizedBox(
              width: 15
            ),

            // Create all three status buttons
            for (int i = 0; i < 3; i++)
              Tooltip(
                message: messages[i],

                // The Container creates the circle behind the button
                child: Container(
                  decoration: BoxDecoration(
                    // Transparent unless selected
                    color: status == i ? colors[i].withOpacity(opacities[i]) : Colors.transparent,
                    shape: BoxShape.circle
                  ),

                  child: IconButton(
                    icon: icons[i],

                    // Gray unless selected
                    color: status == i ? colors[i] : Colors.grey,

                    // Update the local state variable (status) AND the global MyAppState variable to keep track of the status of this task
                    onPressed: () {
                      setState(() {
                        status = i;
                        appState.selectedTrail.categories[widget.trailMapIndex].tasks[widget.trailMapSubindex].status = i;
                      });
                    },
                  )
                )
              ),
          ]
        ),

        // Click on a task to show more detail about it:
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,

            // Wrap everything in a light gray color
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
                          // 'Minutes Spent:' text
                          const Text(
                            'Minutes Spent:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 16
                            ),
                          ),

                          // The TextField to let the user enter the minutes they've spent on this task
                          TextField(
                            decoration: null,
                            maxLength: 5,

                            // This ensures they can only type numbers, so nothing breaks
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: minutesSpentController,

                            // Update the local TextField content variable (minutesSpentController.text)
                            // AND the global MyAppState variable to keep track of the minutes spent on this task
                            onChanged: (String contents) {
                              if (contents.isEmpty) contents = '0'; // Edge case of no input
                              int val = int.parse(contents);
                              appState.selectedTrail.categories[widget.trailMapIndex].tasks[widget.trailMapSubindex].minutesSpent = val;
                              minutesSpentController.text = val.toString();
                            }
                          ),

                          // Horizontal spacer
                          const SizedBox(
                            height: 15
                          ),

                          // 'Task Description:' Text
                          const Text(
                            'Task Description:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 16
                            ),
                          ),

                          // Loop through all of the lines in this task description
                          for (var desc in widget.descriptionList)
                            // This can be modified, currently each description line is a simple Text widget
                            Text(
                              desc,
                              style: const TextStyle(
                                fontSize: 15
                              )
                            ),
                        ]
                      ),
                    ),

                    // Vertical spacer
                    const SizedBox(width: 25),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // 'My Notes:' Text
                            const Text(
                              'My Notes:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: 16
                              ),
                            ),

                            // Wrap everything in a deep blue border
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: const Color.fromARGB(255, 34, 0, 126)),
                                borderRadius: const BorderRadius.all(Radius.circular(15))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),

                                // The TextField to let the user enter any notes they have for this task
                                child: TextField(
                                  decoration: null,

                                  // This lets the user hit 'enter' to go to a new line
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 100, // If the notes go above a hundred lines, they should probably be stored in a separate file
                                  controller: notesController,

                                  // Update the local TextField content variable (notesController.text)
                                  // AND the global MyAppState variable to keep track of the user's notes for this task
                                  onChanged: (String contents) {
                                    notesController.text = contents;
                                    appState.selectedTrail.categories[widget.trailMapIndex].tasks[widget.trailMapSubindex].notes = contents;
                                  }
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
