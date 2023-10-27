import 'dart:convert';

import 'package:http/http.dart' as http;



Future<Question> fetchQuestion() async {
  final response = await http
    .get(Uri.parse("http://127.0.0.1:8000/data"));

    if (response.statusCode == 200) {
      return Question.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
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
    return Question(
      question: json['question'] as String,
      answers: json['answers'] as List<String>,
    );
  }
}