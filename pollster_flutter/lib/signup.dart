import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pollster_flutter/common.dart';
import 'package:pollster_flutter/crypto.dart';
import 'package:pollster_flutter/http.dart';
import 'package:pollster_flutter/models/user.dart';


class SignUp extends StatelessWidget {
  String password = "";
  String email = "";
  String confirmedPassword = "";
  String phoneNumber = "";
  bool emailValidated = false;
  bool numberValidated = false;

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

  bool validateEmail(String value){
    debugPrint("Validating email: $value");

    if (value.isEmpty) {
      debugPrint('This field is required');
      emailValidated = false;
      return false;
    }

    // using regular expression
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      debugPrint("Please enter a valid email address");
      emailValidated = false;
      return false;
    }

    debugPrint("Valid email");
    emailValidated = true;
    return true;
  }

  void validateNumber(String value) {
    debugPrint("Validating number: $value");

    if (value.isEmpty){
    
      debugPrint("Number is empty");
      numberValidated = false;
    
    } else if(!RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(value)) {
      
      debugPrint("Please enter a valid phone number");
      numberValidated = false;

    } else {
      
      debugPrint("Valid phone number");
      numberValidated = true;

    }
  }

  void signUpButtonClicked(BuildContext context) async {
    if (password != confirmedPassword) {
      //TODO - throw error and notify user
      debugPrint("Password and confirmed password do NOT match: password: $password, confirmedPassword: $confirmedPassword");
      Timer(const Duration(seconds: 2), () {
        Navigator.pop(context); // Dismisses dialog
        //Navigator.pop(context); // Navigates back to previous screen
        }
      );

      showDialog( //TODO - fix this error here and below
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Password mis-match'),
          content: Text('Passwords don\'t match, try again'),
        ),
      );
    } else if (emailValidated == false) {
      Timer(const Duration(seconds: 2), () {
        Navigator.pop(context); // Dismisses dialog
        //Navigator.pop(context); // Navigates back to previous screen
        }
      );

      showDialog( //TODO - fix this error here and below
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Invalid email'),
          content: Text('Email is not valid. Try again'),
        ),
      );

    } else if (numberValidated == false) {

      debugPrint("Phone number is not valid");
        Timer(const Duration(seconds: 2), () {
        Navigator.pop(context); // Dismisses dialog
        //Navigator.pop(context); // Navigates back to previous screen
        }
      );

      showDialog( //TODO - fix this error here and below
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Number innvalid'),
          content: Text('Invalid phone number, try again'),
        ),
      );

    } else {

      NewUser newUser = NewUser(email: email, password: encrypt(password), phoneNumber: phoneNumber);

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
        debugPrint("Failed to add password");
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
                obscureText: false,
                onChanged: (String value) {
                  validateEmail(value);
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
                  validateNumber(value);
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