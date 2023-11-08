import 'package:flutter/material.dart';
import 'package:pollster_flutter/http.dart';
import 'package:pollster_flutter/models/user.dart';



class LoginPage extends StatelessWidget {
  String password = "";
  String username = "";

  void updatePassword(String value){
    debugPrint("Password: $value");
    password = value;
  }

  void updateUsername(String value){
    debugPrint("Username: $value");
    username = value;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Username'),
                    onChanged: (String value) {
                      updateUsername(value);
                    },                  
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true, // To hide password input
                    onChanged: (String value) {
                      updatePassword(value);
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle login button click
                      User user = User(username: username, password: password);
                      sendPostRequest(user.toJson(), "login");

                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Handle "Forgot Password" button click
                    },
                    child: const Text('Forgot Password?'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle "Sign Up" button click
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
