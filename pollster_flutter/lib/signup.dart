import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pollster_flutter/common.dart';
import 'package:pollster_flutter/http.dart';
import 'package:pollster_flutter/models/user.dart';


class SignUp extends StatelessWidget {
  String password = "";
  String email = "";
  String confirmedPassword = "";
  String phoneNumber = "";

  void updatePassword(String value){
    debugPrint("Password: $value");
    password = value;
  }

  void updateConfirmedPassword(String value){
    debugPrint("Confirmed Password: $value");
    confirmedPassword = value;
  }

  void updateEmail(String value){
    debugPrint("Email: $value");
    email = value;
  }

  void updatedPhoneNumber(String value){
    debugPrint("Phone Number: $value");
    phoneNumber = value;
  }

  void signUpButtonClicked(BuildContext context) async {
    if (password != confirmedPassword) {
      //TODO - throw error and notify user
      debugPrint("Password and confirmed password do NOT match: password: $password, confirmedPassword: $confirmedPassword");
    }

    NewUser newUser = NewUser(email: email, password: password, phoneNumber: phoneNumber);

    final response = await sendPostRequest(newUser.toJson(), "/signup");
    debugPrint("Respones: ${response.toString()}");

    if (response['status'] == "ok") {
      debugPrint("Success");

      Timer(const Duration(seconds: 2), () {
        Navigator.pop(context); // Dismisses dialog
        Navigator.pop(context); // Navigates back to previous screen
        }
      );

      showDialog( //TODO - fix this error here and below
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('User added successful'),
          content: Text('Welcome!'),
        ),
      );
    } else {
      debugPrint("Failed to re-set password");
        Timer(const Duration(seconds: 2), () {
        Navigator.pop(context); // Dismisses dialog
        }
      );

      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Failed to add user'),
          content: Text('Try again, or try a new the forgot password option'),
        ),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CommonAppBar(msg: "Sign up"),
        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (String value) {
                  updateEmail(value);
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (String value) {
                  updatePassword(value);
                },              
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                onChanged: (String value) {
                  updateConfirmedPassword(value);
                },              
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Phone number'),
                keyboardType: TextInputType.phone,
                onChanged: (String value) {
                  updatedPhoneNumber(value);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  signUpButtonClicked(context);
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}