import 'package:flutter/material.dart';
import 'package:scavenger_hunt_app/models/task.dart';

class DetailedTaskScreen extends StatelessWidget {
  final Task task;

  DetailedTaskScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Task Details')),
      body: Container(
        
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(task.imageUrl), // Replace with your background image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Text(
                task.description,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Location: ${task.location}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              const Text(
                'Clues:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: task.clues
                    .map((clue) => Text(clue, style: TextStyle(fontSize: 16.0)))
                    .toList(),
              ),
              // Add more details or features as needed
            ],
          ),
        ),
      ),
    );
  }
}
