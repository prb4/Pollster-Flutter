import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'package:pollster_flutter/models/poll.dart';

String ip = "http://192.168.1.220:5000/";



Future<Question> fetchQuestion() async {
  String address = ip + "fetch";
  final response = await http
    .get(Uri.parse(address));

  if (response.statusCode == 200) {
    debugPrint("Response code is 200");
    return Question.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    debugPrint("Response code is NOT 200");
    throw Exception("Failed to load question");
  }
}

class Question {
  final String? question;
  final List<String>? answers;

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

  Map<String, dynamic> toJson() => {
    'question': question,
    'answers': answers
  };
}

class CreatingQuestion {
  final Poll poll;
  final List<Contact>? contacts;

  const CreatingQuestion({
    required this.poll,
    required this.contacts,
  });

  factory CreatingQuestion.fromJson(Map<String, dynamic> json) {
    debugPrint("Converting question");
    final List<dynamic> answersList = json['answers'];
    final List<String> parsedAnswers = List<String>.from(answersList);

    final List<dynamic> contactsList = json['contacts'];
    final List<Contact> parsedContacts = List<Contact>.from(contactsList);

    Poll newPoll = Poll(question: json['question'], answers: parsedAnswers);

    debugPrint(parsedAnswers.toString());
    return CreatingQuestion(
      //TODO - this rework may break
      poll: newPoll,
      contacts: parsedContacts,
    );
  }

  Map<String, dynamic> toJson() => {
    'question': poll.question,
    'answers': poll.answers,
    'contacts': contacts,
  };
}

class FinalPoll {
  final List<Poll>? polls;
  final List<Contact>? contacts;

  const FinalPoll({
    required this.polls,
    required this.contacts,
  });

  Map<String, dynamic> toJson() => {
    'polls': polls,
    'contacts': contacts,
  };
}

Future<Map<String, dynamic>> sendPostRequest(Map<String, dynamic> data, String endpoint) async {
  String address = ip + endpoint;

  debugPrint("SendingPostRequest");
  final url = Uri.parse(address);
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200){
    debugPrint("Sent successfully");
    debugPrint(response.body.toString());
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    debugPrint(jsonResponse.toString());
    return jsonResponse;
  } else {
    debugPrint("Failed to send");
    throw Exception('Post failed');
  }
}

