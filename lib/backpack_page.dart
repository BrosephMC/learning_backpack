import 'package:flutter/material.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';

import 'package:learning_backpack/utilities.dart';


class BackpackPage extends StatefulWidget{
  const BackpackPage({super.key});

  @override
   State<BackpackPage> createState() => _BackpackPageState();
}

class _BackpackPageState extends State<BackpackPage>{
  SortOptions? selectedOption;
  List<PlatformFile> files =  [];//list of files
  @override
  
//#########################################################################
  //Method to initialize the file list and retrieve values from storage
  void initState(){
      super.initState();
      loadFiles();
  }
//#########################################################################
  @override
  Widget build(BuildContext context) {
    const tileSize = 170;
    int numTiles = (MediaQuery.of(context).size.width / tileSize).floor();
    if (numTiles < 2) numTiles = 2;
    double tileScale = (MediaQuery.of(context).size.width / tileSize) / numTiles;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(allowMultiple: true);
                  print("$result.path");
                  if(result == null) return;
                  //final file = result.files.first;
                  setState((){
                    files += result.files;
                  });
        //#########################################################################
                  //For file saving
                  for(var theFile in result.files){
                    File savedFile = File(theFile.path!);
                    await saveFile(theFile.name, savedFile);
                    print("$savedFile");
                    print("file saved");
                  }
        //#########################################################################
                },
                child: const Text('File upload'),
              ),
              
              // Insert the code for the drop down UI here
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownMenu<SortOptions>(
                enableSearch: false,
                initialSelection: SortOptions.name,
                requestFocusOnTap: false,
                label: const Text('Sort by...'),
                onSelected: (SortOptions? label) {
                  setState(() {
                    selectedOption = label;
                    if (label != null) {
                      sortItemList(files, label.mode);
                    }
                  });
                },

                dropdownMenuEntries: SortOptions.values
                  .map<DropdownMenuEntry<SortOptions>>(
                    (SortOptions mode) {
                      return DropdownMenuEntry<SortOptions>(
                        value: mode,
                        label: mode.label,
                        enabled: mode.label != 'Grey'
                      );
                    }).toList(),
              ),
            ),

            ]
          ),

          Center(
            child: Text(
              files.isEmpty
                ? 'You have no items in your backpack.'
                : 'You have ${files.length} item${files.length == 1 ? '' : 's'} in your backpack.',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              )
            )
          ),

          Expanded(
            child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 5 * tileScale,
                  mainAxisSpacing: 5 * tileScale,
                  crossAxisCount: numTiles,
                  children: List.generate(files.length, (index){
                    var file = files[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25 * tileScale),
                      ),
                      color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(6 * tileScale),
                                child: Icon(
                                  iconFromExtension(file.extension!),
                                  size: 32 * tileScale,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 7,
                            child: Center(
                              child: Container(
                                width: tileSize * 2.0,
                                color: const Color.fromRGBO(12, 94, 161, 1),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(8 * tileScale, 8 * tileScale, 8 * tileScale, 3 * tileScale),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      file.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15 * tileScale * scaleFileName(file.name),
                                        color: Colors.white
                                      )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(8 * tileScale * 0),
                                child: Container(
                                  child: Text(
                                    formatBytes(file.size, 2),
                                    style: TextStyle(
                                      fontSize: 12 * tileScale,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'monospace'
                                    )
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 5,
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(onPressed: () {openTheFile(file.name);}, icon: const Icon(Icons.open_in_new_rounded), iconSize: 28 * tileScale, color: Colors.white),
                                  IconButton(
                                    onPressed: () async {
                                      final theDelete = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: const Text('Are you sure you want to delete this file?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (theDelete == true) {
                                        // Assuming you have a function to delete the file
                                        deletingFile(file.name);
                                      }
                                    },
                                    icon: const Icon(Icons.delete),
                                    iconSize: 28 * tileScale,
                                    color: Colors.white
                                  ),
                                ],
                                ),
                            ),
                          ),
                        ]      
                      ),
                    );
                  }),
                ),
          )
        ],
      ),
    );
  }
//#########################################################################
  //Method to open files
  void openTheFile(String filename) async{
    try {
      final file = await _localFile(filename);
      OpenFile.open(file.path);
      print("file opened");
    } catch (e) {
      print("Error opening file: $e");
    }
    
  }
    //Obtain the Application Documents directory (where files will be stored, in the App's system-allocated, protected folders
  Future<String> get _localPath async {
    //final directory = await getApplicationDocumentsDirectory();
    final directory = await Directory('assets/app_storage').create(recursive: true);
    return directory.path;
  }

  //Create a reference to the file location
  Future<File> _localFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  //code for saving files 
  Future<void> saveFile(String filename, File file) async {
    final destinationFile = await _localFile(filename);
    try {
      await file.copy(destinationFile.path);
    } catch (e) {
      print("Error saving file: $e");
    }
  }

  //code to delete files of the passed filename
  Future<void> deleteFile(String filename) async {
    try {
      final file = await _localFile(filename);
      await file.delete();
      print("file deleted");
    } catch (e) {
      print("Error deleting file: $e");
    }
  }

  //Method to delete files and remove from the working file list that is being displayed
  void deletingFile(String filename){
    deleteFile(filename);
    setState((){
      files.removeWhere((file) => file.name == filename);
    });
    
  }

  //Method to read a file directory and pass the files into a file list
  Future<List<PlatformFile>> getDir() async{
    List<PlatformFile> theFiles = [];
    bool userfile = false;
    final theDir = await _localPath;
    final myDir = Directory(theDir);
    if(myDir.listSync().isEmpty){
      return theFiles;
    }
    // Use a for loop to handle asynchronous operations correctly
    for (var file in myDir.listSync()) {
        if (file is File) {
          // Await the file length operation before adding the PlatformFile object
          //check if file is accessible to the user
          try {
            await file.openRead();
            userfile = true;
          } catch (e){
            userfile = false;
          }
          //add files to the file list from the local app storage
          if (userfile){
            int size = await file.length();
            String filename = basename(file.path);
            theFiles.add(PlatformFile(name: filename, size: size));
          }
          else{
            continue;
          }
          
          
        }
        
    }
    
    return theFiles;
  }
  
  //Method to load files from storage to a file list
  void loadFiles() async{
    List<PlatformFile> loadedFiles = await getDir();
    setState(() {
      files = loadedFiles;
      print("$files");
    }); 
  }

  Future<void> sortItemList(List<PlatformFile> itemList, SortMode sortBy) async {
  switch (sortBy) {
    case SortMode.name:
      itemList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));    // Sort by file name (alphabetical)
      break;
    case SortMode.smToLg:
      itemList.sort((a, b) => a.size.compareTo(b.size));    // Sort by file size (in bytes) smallest first
      break;
    case SortMode.lgToSm:
      itemList.sort((a, b) => b.size.compareTo(a.size));    // Sort by file size (in bytes) largest first (inverse of the above)
      break;
    case SortMode.extension:
      //itemList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));    // Sort by file name (alphabetical) to keep sorting via extension
      itemList.sort((a, b) => a.extension!.compareTo(b.extension!));    // Sort by file type (extension)
      break;
    default:
      // Do nothing: leave it in default order (inverse of file system sort)
  }
}

//#########################################################################
}

enum SortOptions {
  name,
  smToLg,
  lgToSm,
  extension,
}

extension SortOptionsExtension on SortOptions {
  String get label {
    switch (this) {
      case SortOptions.name:
        return 'Name';
      case SortOptions.smToLg:
        return 'Smallest';
      case SortOptions.lgToSm:
        return 'Largest';
      case SortOptions.extension:
        return 'Extension';
    }
  }

  SortMode get mode {
    switch (this) {
      case SortOptions.name:
        return SortMode.name;
      case SortOptions.smToLg:
        return SortMode.smToLg;
      case SortOptions.lgToSm:
        return SortMode.lgToSm;
      case SortOptions.extension:
        return SortMode.extension;
    }
  }
}

enum SortMode {
  name,
  smToLg,
  lgToSm,
  extension,
}