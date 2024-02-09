import 'package:flutter/material.dart';
import 'package:pollster_flutter/crypto.dart';
import 'package:pollster_flutter/home_page.dart';
import 'package:pollster_flutter/http.dart';
import 'package:pollster_flutter/models/user.dart';
import 'package:pollster_flutter/signup.dart';
import 'package:pollster_flutter/theme/dark_theme.dart';
import 'package:pollster_flutter/theme/light_theme.dart';
import 'package:pollster_flutter/user_session.dart';

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
      routes: {
        '/home':(BuildContext context) => const Home()
      },
      theme: darkTheme,
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
                        //User user = User(username: username, password: password);
                        User user = User(username: "user1", password: "6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b");
                        final response = await sendPostRequest(user.toJson(), "login");
                        //TODO - improve authentication
                        debugPrint("Response: ${response.toString()}");
                        debugPrint("Response message: ${response['message']}");
                        if (response['message'] == "OK") {
                          //Navigator.push(
                          //  context,
                          //  MaterialPageRoute(builder: (context) => const Home(), settings: const RouteSettings(name: "/home")),
                          //  MaterialPageRoute(builder: (context) => const Home()),
                          //); 
                          debugPrint("Log in response: ${response.toString()}");
                          UserSession().username = username;
                          UserSession().userId = response['user_id'];

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: const RouteSettings(name: "/home"),
                              builder: (context) => const Home(),
                            ),
                          );

                          //Navigator.of(context).pushNamed('/home');
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
