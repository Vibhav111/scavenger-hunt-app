import 'package:flutter/material.dart';
import 'package:scavenger_hunt_app/screens/chat_screen.dart';
import 'package:scavenger_hunt_app/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:scavenger_hunt_app/models/task.dart';

import 'detailed_task_screen.dart';


class MyTaskPage extends StatefulWidget {

  @override
  _MyTaskPageState createState() => _MyTaskPageState();
}
class _MyTaskPageState extends State<MyTaskPage> {
    List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    // Fetch tasks when the home page is loaded
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    String apiUrl = 'https://thescavengerhunt.azurewebsites.net/api/tasks';
    // Replace with your tasks API endpoint

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('jwtToken');
    print('JWT Token: $jwtToken');

    if (jwtToken != null) {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $jwtToken'},
      );

      if (response.statusCode == 200) {
        final tasksData = jsonDecode(response.body) as List<dynamic>;
        setState(() {
        tasks = tasksData.map((task) {
          // Convert the clues list to a List<String>
          // List<String> cluesList = (task[3] as List<dynamic>).cast<String>();
          // print("list of clues $cluesList");
          return Task(
            id:task[0],
          title: task[1],
          description: task[2],
          clues: task[3], 
          location: task[4],
          imageUrl: task[5]
        );}).toList();
      });
      } else {


        // Handle API call failure
      }
    } else {
      // Handle no JWT token scenario
    }
  }

   Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('jwtToken'); // Remove the JWT token from shared preferences
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
     
      return Scaffold(
        appBar: AppBar(title: Text('My Events'),
        actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],),
        body: Center(
          child:tasks.isEmpty ? const Text('No tasks available' ): ListView.builder(
          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailedTaskScreen(task: tasks[index]),
                        ),
                      );
                    },
                    child: TaskCard(task: tasks[index]),
                  );
                },
              ),
      ),
    );
  }
}
        
     
    
  


class TaskCard extends StatelessWidget {
  final Task task;

  TaskCard({required this.task});
  

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          children: [Image.network(task.imageUrl ,
          width: 200,// Replace with your SVG file path
              fit: BoxFit.cover,
           
          ),

const SizedBox(width: 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  task.description,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8.0),
                
                                      Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: task.clues.map((clue) => Row(
                              children: [
                                 Icon(Icons.donut_small, color: Colors.red,size: 15,),
                                 SizedBox(width: 10,),
                                Text(clue, style: TextStyle(fontSize: 14.0)),
                              ],
                            )).toList(),
                          ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.map, color: Colors.orange,),
                    SizedBox(width: 10,),
                    Text(
                      'Location: ${task.location}',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
  SizedBox(height: 15,),
                                Row(
                                  children: [
                                    ElevatedButton(
                     style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),),
                    onPressed: (){},
                    child: Text('Submit Claim', style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(width: 20,),
                                    ElevatedButton(
                     style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),),
                    onPressed: (){},
                    child: Text('Help', style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(width: 20,),
                                    ElevatedButton(
                     style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),),
                    onPressed: (){

                           Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(eventId: task.id, senderId: 1,),
                        ),
                      );
                    },
                    child: Text('Enter Group Chat', style: TextStyle(color: Colors.white),),
                  ),
                                  ],
                                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
 
