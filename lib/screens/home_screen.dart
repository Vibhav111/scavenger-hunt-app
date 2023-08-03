import 'package:flutter/material.dart';
import 'package:scavenger_hunt_app/screens/main_screen.dart';
import 'package:scavenger_hunt_app/screens/my_task.dart';
import 'package:scavenger_hunt_app/screens/task_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/mydrawer.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('jwtToken'); // Remove the JWT token from shared preferences
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
  }
    return Scaffold(
 
      body: 
          Row(
            children: [ MyDrawer(),
              Expanded(
                
                  child: Column(
                    children: [
                      //Buttons
Container(

            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                ElevatedButton(
                  onPressed: () {
                   logout();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 43, 19, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0), // Reduce button height
                  ),
                  child: const Text(' Logout ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                SizedBox(width: 8.0),
               
              ],
            ),
          ),
          Row(
        children: [
          Expanded(
            child: Card1(),
          ),
          Expanded(
            child: Card2(),
          ),
        ],
      ),
                      // Expanded(
                      //   child: Container(
                      //     width: 200.0,
                      //     padding: EdgeInsets.all(16.0),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                              Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                    onTap:() =>  Navigator.push(context, MaterialPageRoute(builder: (_) => TaskPage())),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      image: DecorationImage(
                                        image: AssetImage('lib/assets/images/park.jpg'), // Replace with the actual image
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    margin: EdgeInsets.all(16.0),
                                    height: 200, // Adjust the height as needed
                                    child: Center(
                                      child: Text(
                                        'Check New Events',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                   onTap:() =>  Navigator.push(context, MaterialPageRoute(builder: (_) => MyTaskPage())),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      image: DecorationImage(
                                        image: AssetImage('lib/assets/images/puzzle.jpg'), // Replace with the actual image
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    margin: EdgeInsets.all(16.0),
                                    height: 200, // Adjust the height as needed
                                    child: Center(
                                      child: Text(
                                        'My Events',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                          //     ],
                          //   ),
                          // ),
                      // ),
                    ],
                  ),
                ),
              
            ],
          ));
  }
  
}

 

class Card1 extends StatelessWidget {
  final List<EventData> events = [
    EventData(eventName: 'Mystical Odyssey', timeLeft: 23),
    EventData(eventName: 'Clue Hunters', timeLeft: 12),
    EventData(eventName: 'Treasure Trails', timeLeft: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Time Remaining',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            for (var event in events)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('${event.eventName}',style:TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: event.timeLeft / 24, // Assuming 24 hours for each event
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          backgroundColor: Colors.grey,
                        ),
                      ),
                       SizedBox(width: 10),
                  Text('${event.timeLeft} hours left', style:TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
                    ],
                  ),
                 
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class Card2 extends StatelessWidget {
  final List<EventData> events = [
    EventData(eventName: 'Mystical Odyssey', tasksCompleted: 70),
    EventData(eventName: 'Clue Hunters', tasksCompleted: 45),
    EventData(eventName: 'Treasure Trails', tasksCompleted: 90),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Expanded(
          child: Column(
            children: [     Text(
                'Tasks Completed ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
         
                  SizedBox(height: 16),
                  for (var event in events)
                    Column(
                      children: [
                        Text('${event.eventName}'),
                        SizedBox(height: 8),
                        CircularProgressIndicator(
                          value: event.tasksCompleted / 100,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          backgroundColor: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text('${event.tasksCompleted}% completed'),
                        SizedBox(height: 16),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventData {
  final String eventName;
  final int timeLeft;
  final int tasksCompleted;

  EventData({
    required this.eventName,
    this.timeLeft = 0,
    this.tasksCompleted = 0,
  });
}
