import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pollster_flutter/common.dart';
import 'package:pollster_flutter/http.dart';
import 'package:pollster_flutter/responder.dart';
import 'package:pollster_flutter/signup.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  String email = "";

  void setEmail(String str){
    email = str;
    debugPrint("Email: $email");
  }

  void showShortLivedPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Dismiss the dialog after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
              // Pop back to the previous screen
          Navigator.popUntil(context, ModalRoute.withName('/home'));
              //Navigator.pop(context);
        });

        // Return the dialog widget
        return const AlertDialog(
          title: Text('Password Reset Successful'),
          content: Text('Check your email for a reset link.'),
        );
      },
    );
  }

    bool validateEmail(String value){
    debugPrint("Validating email: $value");

    if (value.isEmpty) {
      debugPrint('This field is required');
      return false;
    }

    // using regular expression
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      debugPrint("Please enter a valid email address");
      return false;
    }

    debugPrint("Valid email");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(msg: "Forgot Password"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Enter email'),
              onChanged: (String value) {
                setEmail(value);
                debugPrint("Forgot'd email: $value");
              },
            ),
            SubmitButton(
              message: "Submit", 
              onPressed: () async {
                //validate email locally first
                if (!validateEmail(email)){

                  Timer(const Duration(seconds: 2), () {
                  Navigator.pop(context); // Dismisses dialog
                  //Navigator.pop(context); // Navigates back to previous screen
                  });

                  showDialog( //TODO - fix this error here and below
                    context: context,
                    builder: (_) => const AlertDialog(
                      title: Text('Invalid email'),
                      content: Text('Email is not valid. Try again'),
                    ),
                  );

                } else {

                  var data = {
                      "email": email
                    };

                  final response = await sendPostRequest(data, "/password/reset");
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
                        title: Text('Password Reset Successful'),
                        content: Text('Check your email for a reset link.'),
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
                        title: Text('Password Reset Failed'),
                        content: Text('Re-enter your email.'),
                      ),
                    );
                  }
                }
              })
          ],
        )
      ),
    );
  }
}