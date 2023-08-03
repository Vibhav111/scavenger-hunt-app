
import 'package:flutter/material.dart';
import 'package:scavenger_hunt_app/screens/home_screen.dart';
import 'package:scavenger_hunt_app/screens/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'task_page.dart';
import 'package:flutter_svg/flutter_svg.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Your Flask back-end login API endpoint URL
    String apiUrl = 'https://thescavengerhunt.azurewebsites.net/api/login';

    
    try {
      final response = await http.post(Uri.parse(apiUrl), 
      headers: {'Content-Type': 'application/json'},
      body:jsonEncode( {
        'email': email,
        'password': password,
      }));

      print(response.body);

      if (response.statusCode == 200) {
        // Login successful
        final data = jsonDecode(response.body);
        String jwtToken = data['token'];

        // Store the JWT token securely using shared_preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('jwtToken', jwtToken);

        // Navigate to the home page
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } else {
        // Login failed, show error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title:  Text('Login Failed'),
            content: Text('Invalid email or password. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // Handle API call errors
      print('API Call Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'lib/assets/images/login.svg', // Replace with your SVG file path
              fit: BoxFit.cover,
            ),
          ),

      
      
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
               const Text(
              'Welcome Again',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange
              ),
            ), SizedBox(height: 15,),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0), // Reduce button height
                  ),
                onPressed: _login,
                child: Text('Login'),),
                SizedBox(height: 32),
                ElevatedButton(
                  
                   style: ElevatedButton.styleFrom(
                    
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0), // Reduce button height
                  ),
                onPressed: (){
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RegisterPage()));
                },
                child: Text(' Register a new account ?'),
              ),
            ],
          ),
        ),
      ),
    ]));
  }
}