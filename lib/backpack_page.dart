import 'package:flutter/material.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
  Widget build(BuildContext context) {
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
                child: Text('File upload'),
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
          Expanded(
            child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  crossAxisCount: 2,
                  children: List.generate(files.length, (index){
                    var file = files[index];
                    return Card(
                      color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              iconFromExtension(file.extension!),
                              size: 50,
                              color: Colors.white
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              file.name,
                              style: const TextStyle(fontSize: 15, color: Colors.white),
                              softWrap: true
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(onPressed: () {openTheFile(file.name);}, icon: const Icon(Icons.open_in_new_rounded), iconSize: 35, color: Colors.white),
                              IconButton(onPressed: () {deletingFile(file.name);}, icon: const Icon(Icons.delete), iconSize: 35, color: Colors.white),
                            ],
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
    final directory = await getApplicationDocumentsDirectory();
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
      itemList.sort((a, b) => a.name.compareTo(b.name));    // Sort by file name (alphabetical)
      break;
    case SortMode.size:
      itemList.sort((a, b) => a.size.compareTo(b.size));    // Sort by file size (in bytes)
      break;
    case SortMode.extension:
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
  size,
  extension,
}

extension SortOptionsExtension on SortOptions {
  String get label {
    switch (this) {
      case SortOptions.name:
        return 'Name';
      case SortOptions.size:
        return 'Size';
      case SortOptions.extension:
        return 'Extension';
    }
  }

  SortMode get mode {
    switch (this) {
      case SortOptions.name:
        return SortMode.name;
      case SortOptions.size:
        return SortMode.size;
      case SortOptions.extension:
        return SortMode.extension;
    }
  }
}

enum SortMode {
  name,
  size,
  extension,
}