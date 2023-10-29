import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



Future<Question> fetchQuestion() async {
  final response = await http
    .get(Uri.parse("http://192.168.1.219:5000/fetch"));

  if (response.statusCode == 200) {
    debugPrint("Response code is 200");
    return Question.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    debugPrint("Response code is NOT 200");
    throw Exception("Failed to load question");
  }
}

class Question {
  final String question;
  final List<String> answers;

  const Question({
    required this.question,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    debugPrint("Converting question");
    final List<dynamic> answersList = json['answers'];
    final List<String> parsedAnswers = List<String>.from(answersList);
    debugPrint(parsedAnswers.toString());
    return Question(
      question: json['question'] as String,
      answers: parsedAnswers,
    );
  }
}

Future<void> sendPostRequest(Map<String, dynamic> data) async {
  debugPrint("SendingPostRequest");
  final url = Uri.parse("http://192.168.1.219:5000/submit");
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200){
    debugPrint("Sent successfully");
  } else {
    debugPrint("Failed to send");
  }
}