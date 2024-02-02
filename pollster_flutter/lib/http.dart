import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'package:pollster_flutter/models/poll.dart';
import 'package:pollster_flutter/user_session.dart';

String ip = "http://192.168.1.151:5000/";
//String ip = "http://172.16.44.50:5000/";



Future<List<ReceivedVotes>> fetchPolls() async {
  String address = ip + "fetch?user_id=${UserSession().userId.toString()}";

  final response = await http
    .get(Uri.parse(address));

  if (response.statusCode == 200) {
    debugPrint("Response code is 200");
    //debugPrint("response body: ${response.body}");
    final data = jsonDecode(response.body);
    debugPrint("json decoded: ${data.length}");
    debugPrint("json: ${data.toString()}");
    debugPrint("json type: ${data.runtimeType}");

    final List<ReceivedVotes> receivedVotesList = [];

    for (var i = 0; i < data.length; i++) {
      debugPrint("Data item: ${data[i].toString()}");
      
      final String uuid = data[i]['poll_id'];
      final String title = data[i]['title'];
      int len = data[i]['votes'].length;

      List<Vote> polls = [];

      for (var x = 0; x < len; x++){
        final _polls = data[i]['votes'][x];
        //debugPrint("Polls question: ${_polls['question']}");
        //debugPrint("Polls answers: ${_polls['answers']}");
        Vote poll = Vote.fromJson(_polls);
        polls.add(poll);
      }

      ReceivedVotes receivedPolls = ReceivedVotes(votes: polls, uuid: uuid, title: title);
      receivedVotesList.add(receivedPolls);
    }
    return receivedVotesList;
  } else {
    debugPrint("Response code is NOT 200");
    throw Exception("Failed to load question");
  }
}

class CreatingQuestion {
  final Vote poll;
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

    Vote newPoll = Vote(question: json['question'], question_id: json['question_id'], answers: parsedAnswers);

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

