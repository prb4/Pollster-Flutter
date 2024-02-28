import 'package:flutter/material.dart';
import 'package:pollster_flutter/common.dart';
import 'package:pollster_flutter/http.dart';
import 'package:pollster_flutter/responder.dart';
import 'dart:convert';

class UserFeedback extends StatelessWidget {

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold (
        appBar: const CommonAppBar(msg: "User Feedback"),
        resizeToAvoidBottomInset: false,   //new line
        body: Column(
          children: <Widget>[
            Card(
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textEditingController,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your feedback. Thanks!",
                  ),
                  maxLines: 16, //or null 
                ),
              )
            ),
            const Spacer(),
            SubmitButton(message: "Submit", onPressed: () async {
                debugPrint("User feedback: ${_textEditingController.text}");
                Codec<String, String> stringToBase64 = utf8.fuse(base64);
                String encodedFeedback = stringToBase64.encode(_textEditingController.text);
                Map<String, dynamic> data = {};
                data['message'] = encodedFeedback;
                data['encoded'] = true;
                final response = await sendPostRequest(data, "/feedback");
                debugPrint("/feedback respones: ${response.toString()}");
                Navigator.pop(context);

              }),
            const Spacer()
          ],
        )
      )
    );
  }
}