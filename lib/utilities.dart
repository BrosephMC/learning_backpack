import 'package:flutter/material.dart';
import 'dart:io';

//this will be removed
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


//
// Journey, Trail, Category, Task Classes
//
class Journey {
  String name;
  List<Trail> trails;

  Journey(this.name, this.trails);

  @override
  String toString() => 'Journey(name: $name, trails: $trails)';
}

class Trail {
  String name;
  List<Category> categories;

  Trail(this.name, this.categories);

  @override
  String toString() => 'Trail(name: $name, categories: $categories)';
}

class Category {
  String name;
  List<Task> tasks;

  Category(this.name, this.tasks);

  @override
  String toString() => 'Category(name: $name, tasks: $tasks)';
}

class Task {
  String name;
  String description;

  Task(this.name, this.description);

  @override
  String toString() => 'Task(name: $name, description: $description)';
}


//
// Creates a list of Journeys from a given text file describing them
//
List<Journey>? parseJourneys(String filePath) {
  // Note: Must end the file with 2 newlines
  try{
  final file = File(filePath);
  final lines = file.readAsLinesSync();

  List<Journey> journeys = [];
  Journey? currentJourney;
  Trail? currentTrail;
  Category? currentCategory;
  Task? currentTask;

  for (final line in lines) {
    if (line.startsWith('\$')) {
      // Journey
      currentJourney = Journey(line.substring(1).trim(), []);
    } else if (line.startsWith(' #')) {
      // Trail
      currentTrail = Trail(line.substring(2).trim(), []);
      currentJourney!.trails.add(currentTrail);
    } else if (line.startsWith('  >')) {
      // Category
      currentCategory = Category(line.substring(3).trim(), []);
      currentTrail!.categories.add(currentCategory);
    } else if (line.startsWith('   -')) {
      // Task
      currentTask = Task(line.substring(4).trim(), "");
      currentCategory!.tasks.add(currentTask);
    } else if (line.startsWith('    *')) {
      // Task Description
      currentTask!.description = line.substring(5).trim();
    } else if (line.isEmpty) {
      journeys.add(currentJourney!);
    }
  }

  return journeys;
  } catch (e) {
    print("could not read from file");
    return [];
  }
}



//
// Returns an Icon given a category, to be used for generating trail icons based on their name
//
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



//
// Returns IconData based on the given file extension
// It returns IconData, not an Icon, so you can modify the style before creating an Icon widget
//
IconData iconFromExtension(String ext) {
  var categories = [
    { // Images
      'keywords' : <String>[ 'png', 'jpg', 'jpeg', 'webp', 'avif', 'bmp', 'ico', 'tiff', 'svg', 'gif', 'apng' ],
      'icon' : Icons.image_rounded
    },

    { // Audio
      'keywords' : <String>[ 'mp3', 'wav', 'aac', 'ogg', 'flac', 'wma', 'aiff', 'mid', 'midi' ],
      'icon' : Icons.volume_up_rounded
    },

    { // Videos
      'keywords' : <String>[ 'mp4', 'avi', 'mov', 'wmv', 'mkv', 'flv', 'webm', 'mpg', 'mpeg' ],
      'icon' : Icons.movie_rounded
    },

    { // Documents
      'keywords' : <String>[ 'doc', 'docx', 'odt' ],
      'icon' : Icons.description_rounded
    },

    { // PDF
      'keywords' : [ 'pdf' ],
      'icon' : Icons.picture_as_pdf_rounded
    },

    { // PDF-like files
      'keywords' : [ 'djvu', 'xps', 'epub', 'mobi', 'azw', 'cbz', 'cbr', 'fb2', 'pdb', 'lit', 'tex' ],
      'icon' : Icons.file_copy_rounded
    },

    { // Spreadsheets
      'keywords' : <String>[ 'xls', 'xlsx', 'csv', 'ods' ],
      'icon' : Icons.grid_on_sharp
    },

    { // Presentations
      'keywords' : <String>[ 'ppt', 'pptx', 'odp' ],
      'icon' : Icons.slideshow_rounded
    },

    { // Text
      'keywords' : <String>[ 'txt', 'rtf', 'md' ],
      'icon' : Icons.text_snippet_rounded
    },

    { // Archives
      'keywords' : <String>[ 'zip', 'rar', '7z', 'tar', 'gz', 'bz2' ],
      'icon' : Icons.folder_zip_rounded
    },
  ];
  
  // Check if we match any category, which gives us a category-specific icon
  for (var category in categories) {
    for (var keyword in category['keywords'] as List<String>) {
      if(RegExp(keyword, caseSensitive: false).hasMatch(ext)){
        return category['icon'] as IconData;
      }
    }
  }

  // Default to paperclip icon
  return Icons.attachment;
}
