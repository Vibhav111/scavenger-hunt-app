import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scavenger_hunt_app/screens/home_screen.dart';
import 'package:scavenger_hunt_app/screens/login_page.dart';
import 'package:scavenger_hunt_app/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scavenger Hunt App',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: 
       FutureBuilder(
         future: checkJwtToken(), // Check if the JWT token is present in shared preferences
         builder: (context, snapshot) {
          
           if (snapshot.connectionState == ConnectionState.waiting) {
             return CircularProgressIndicator(); // Show loading indicator while checking JWT token
           } else {
             if (snapshot.data == "Login") {
               return LoginPage(); // JWT token exists, show the main page
             } 
             else if (snapshot.data == "Home") {
               return HomeScreen(); // JWT token exists, show the main page
             } 
             else {
               return MainScreen(); // No JWT token, show the login page
             }
           }
         },
       ),
    );
  }}
 Future<String> checkJwtToken() async {
    // Check if the JWT token exists in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('jwtToken');
    
    // return jwtToken != null && jwtToken.isNotEmpty;
      // Check if the JWT token exists and is not empty
  if (jwtToken != null && jwtToken.isNotEmpty) {
    // Decode the JWT token to get its expiration time
    Map<String, dynamic> decodedToken = jsonDecode(
      ascii.decode(base64.decode(base64.normalize(jwtToken.split(".")[1]))),
    );
    
    // Get the expiration timestamp (in seconds) from the decoded token
    int exp = decodedToken['exp'];

    // Check if the token is expired (current timestamp is greater than expiration timestamp)
    if (DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000 >= exp) {
      // Token is expired, show login page
      return 'Login';
    } else {
      // Token is not expired, show task page
      return 'Home';
    }
  } else {
    // JWT token does not exist, show login page
    return 'Main';
  }
  }


