import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';

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
  List<String> description; // One line per element
  int status;
  String notes;

  Task(this.name, this.description, this.status, this.notes);

  @override
  String toString() => 'Task(name: $name, description: $description, notes: $notes)';
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
      currentTask = Task(line.substring(4).trim(), [], 0, "");
      currentCategory!.tasks.add(currentTask);
    } else if (line.startsWith('    *')) {
      // Task Description
      currentTask!.description.add(line.substring(5).trim());
    } else if (line.isEmpty) {
      journeys.add(currentJourney!);
    }
  }

   print(journeys);
  return journeys;
  } catch (e) {
    print("could not read from file");
    return [];
  }
}



//
// Returns an Icon given a category, to be used for generating trail icons based on their name
//
Icon getIconFromWord(String phrase) {
  var categories = [
    {
      'keywords' : <String>[ 'food' ],
      'icon' : Icons.fastfood
    },
    {
      'keywords' : <String>[ 'language', 'read', 'word', 'bible' ],
      'icon' : Icons.menu_book
    },
    {
      'keywords' : <String>[ 'travel', 'navigation' ],
      'icon' : Icons.explore
    },
    {
      'keywords' : <String>[ 'mission', 'world' ],
      'icon' : Icons.public
    },
    {
      'keywords' : <String>[ 'faith', 'church', 'spirit', 'holy', 'minist' ],
      'icon' : Icons.church
    },
    {
      'keywords' : <String>[ 'people', 'person', 'commun', 'group', 'partner', 'corp', 'relat', 'fam' ],
      'icon' : Icons.groups
    },
    {
      'keywords' : <String>[ 'video', 'watch' ],
      'icon' : Icons.ondemand_video
    },
    {
      'keywords' : <String>[ 'finance', 'money', 'currency' ],
      'icon' : Icons.attach_money
    },
    {
      'keywords' : <String>[ 'video', 'watch' ],
      'icon' : Icons.ondemand_video
    },
    {
      'keywords' : <String>[ 'learn', 'school', 'teach' ],
      'icon' : Icons.school
    },
    {
      'keywords' : <String>[ 'plan', 'note', 'document', 'write' ],
      'icon' : Icons.edit_note
    },
    {
      'keywords' : <String>[ 'heal', 'safe', 'med' ],
      'icon' : Icons.health_and_safety
    },
  ];
  
  // Check if we match any category, which gives us a category-specific icon
  for (var category in categories) {
    for (var keyword in category['keywords'] as List<String>) {
      if(RegExp(keyword, caseSensitive: false).hasMatch(phrase)){
        return Icon(category['icon'] as IconData);
      }
    }
  }

  // Default to mountains icon
  return const Icon(Icons.filter_hdr);
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



//
// Turns a number of bytes into its corresponding units
// E.g., formatBytes(1928903, 3) returns '1.929 MB'
//
String formatBytes(int bytes, int decimalPlaces) {
  if (bytes <= 0) return '0 B';
  const suffixes = [ 'B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB' ];
  final i = (log(bytes) / log(1024)).floor();
  final mantissa = (bytes / pow(1024, i)).toStringAsFixed(decimalPlaces);
  return '$mantissa ${suffixes[i]}';
}



//
// Scales down the size of a file name based on how long it is
// To make the file name more readable
//
double scaleFileName(String name) {
  double scale = 5 / pow(name.length, 0.55);
  if (scale < 0.65) scale = 0.65;
  if (scale > 1) scale = 1;
  return scale;
}