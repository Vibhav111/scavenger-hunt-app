import 'dart:convert';

class Task {
  final int id;
  final String title;
  final String description;
  final List<String> clues;
  final String location;
  final String imageUrl;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required dynamic clues,
    required this.location,
    required this.imageUrl
  }): clues = _parseClues(clues);

  static List<String> _parseClues(dynamic clues) {
    if (clues is List<String>) {
      return clues;
    } 
    else if (clues is List<dynamic>) {
      return clues.map((clue) => clue.toString()).toList();
    } 
    else if (clues is String) {
      try {
        final decodedClues = jsonDecode(clues);
        if (decodedClues is List<dynamic>) {
          return decodedClues.map((clue) => clue.toString()).toList();
        }
         } catch (e) {
          
        print("Error parsing clues: $e");
        return [];
         }}
    
      return [];
    
  }
}

