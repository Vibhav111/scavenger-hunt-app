import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:scavenger_hunt_app/screens/login_page.dart';
import 'package:scavenger_hunt_app/screens/register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          children: [
            // Main content slowly appearing on the screen
            AnimatedOpacity(
              opacity: 1.0, 
              curve: Curves.easeInCirc,// Change the value to 1.0 to make the content fully opaque
              duration: Duration(seconds: 1), // Set the duration to control the fade-in speed
              child: Expanded(child: MainContent()),
            ),
          ],
        ),
      ),
    );
  }
}





class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Scavenger Hunt',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: const Text(
                'Embark on a thrilling journey of discovery and adventure with Scavenger Hunt! Unravel clues, solve riddles, and compete in exciting challenges as you explore a world of mystery and fun. Are you ready to unleash your inner detective and conquer the hunt of a lifetime?',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white
                ),
              ),
            ),
            SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [          ElevatedButton(
            style: ElevatedButton.styleFrom(
                    primary: ui.Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // Reduce button height
                  ),
              onPressed: () {
                // Navigate to the page with live events
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(),
                  ),
                );
              },
              child: Text('Join Us ', style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black
              )),
            ),
    SizedBox(width: 30,),
    
                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                    primary: ui.Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // Reduce button height
                  ),
                        
              onPressed: () {
                // Navigate to the page with live events
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Text('Login', style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black
              )),
            )],)
          ],
        ),
      ),
    );
  }
}

class LiveEventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Events'),
      ),
      body: Center(
        child: Text('This is the live events page'),
      ),
    );
  }
}
