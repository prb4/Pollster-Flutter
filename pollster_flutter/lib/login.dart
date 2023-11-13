import 'package:flutter/material.dart';
import 'package:pollster_flutter/crypto.dart';
import 'package:pollster_flutter/home_page.dart';
import 'package:pollster_flutter/http.dart';
import 'package:pollster_flutter/models/user.dart';
import 'package:pollster_flutter/signup.dart';

class LoginPage extends StatelessWidget {
  String password = "";
  String username = "";

  void updatePassword(String value){
    debugPrint("Password: $value");
    password = encrypt(value);
    //password = value;
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
            child: Builder(
              builder: (context) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      decoration: const InputDecoration(labelText: 'Username'),
                      onChanged: (String value) {
                        updateUsername(value);
                      },                  
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true, // To hide password input
                      onChanged: (String value) {
                        updatePassword(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        // Handle login button click
                        User user = User(username: username, password: password);
                        final response = await sendPostRequest(user.toJson(), "login");
                        //TODO - improve authentication
                        debugPrint("Response: " + response.toString());
                        if (response['message'] == "OK") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Home()),
                          ); 
                        } else {
                          debugPrint("[!] Failed to authenticate properly");
                          //TODO
                        }

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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        ); 
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
