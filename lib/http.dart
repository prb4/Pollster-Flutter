import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



Future<Question> fetchQuestion() async {
  final response = await http
    .get(Uri.parse("http://192.168.1.219:5000/data"));

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