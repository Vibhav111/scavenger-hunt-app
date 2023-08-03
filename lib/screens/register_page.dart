import 'package:flutter/material.dart';
import 'package:scavenger_hunt_app/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_screen.dart';
import 'task_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();
    

    // Your Flask back-end login API endpoint URL
    String apiUrl = 'https://thescavengerhunt.azurewebsites.net/api/register';

    try {
      print("try block");
      final response = await http.post(Uri.parse(apiUrl), 
       headers: {
          'Content-Type': 'application/json', // Set content-type header to JSON
        },
      body: jsonEncode({
        'email': email,
        'password': password,
        'name':name
      }));
      print(response.body);

      if (response.statusCode == 201) {
        // Login successful
        final data = jsonDecode(response.body);
        print("tokennnnnn");
        String jwtToken = data['token'];

        // Store the JWT token securely using shared_preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print("token");
        prefs.setString('jwtToken', jwtToken);
        print("jwt token is $jwtToken");

        // Navigate to the home page
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } else if (response.statusCode == 409) {
      // User already exists
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Registration Failed'),
          content: Text('User with the provided email already exists. Please use a different email.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Registration failed due to some other error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Registration Failed'),
          content: Text('An error occurred while registering. Please try again later.'),
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
        children: [SvgPicture.asset(
              'lib/assets/images/registration.svg', // Replace with your SVG file path
              fit: BoxFit.cover,
           
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                      Text(
              ' Please Register Yourself',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange
              ),
            ),
            SizedBox(height: 20,),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 16),
                   TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                     style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),),
                    onPressed: _login,
                    child: Text('Register'),
                  ),
                  SizedBox(height: 15,),
                  ElevatedButton(
                   style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),),
                onPressed: (){
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
                },
                child: Text(' Already Have an account?'),
              )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
