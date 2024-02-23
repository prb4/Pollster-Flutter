import 'package:flutter/material.dart';
import 'package:pollster_flutter/common.dart';
import 'package:pollster_flutter/crypto.dart';
import 'package:pollster_flutter/forgot_password.dart';
import 'package:pollster_flutter/home_page.dart';
import 'package:pollster_flutter/http.dart';
import 'package:pollster_flutter/models/user.dart';
import 'package:pollster_flutter/signup.dart';
import 'package:pollster_flutter/theme/theme.dart';
import 'package:pollster_flutter/user_session.dart';

class LoginPage extends StatelessWidget {
  String password = "";
  String username = "";

  void updatePassword(String value){
    debugPrint("Password: $value");
    password = value;
    //password = value;
  }

  void updateEmail(String value){
    debugPrint("Email: $value");
    username = value;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home':(BuildContext context) => const Home(),
        '/forgotPassword': (BuildContext context) => ForgotPassword(),
      },
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Login",
            style: Theme.of(context).textTheme.headlineLarge
          ),
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
                      decoration: const InputDecoration(labelText: 'Email'),
                      onChanged: (String value) {
                        updateEmail(value);
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
                        //User user = User(email: username, password: encrypt(password));
                        User user = User(email: "user1@email.com", password: "6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b");
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
                      child: Text('Login', style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgotPassword');
                        //Navigator.of(context).push(
                          
                            //MaterialPageRoute(
                            //  settings: const RouteSettings(name: "/login"),
                            //  builder: (context) => ForgotPassword(),
                            //)
                        //);
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
