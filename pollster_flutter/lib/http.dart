import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'package:pollster_flutter/models/poll.dart';

//String ip = "http://192.168.1.220:5000/";
String ip = "http://172.16.44.50:5000/";



Future<List<ReceivedPolls>> fetchPolls() async {
  //TODO - fix this
  String address = ip + "fetch?user_id=1";

  final response = await http
    .get(Uri.parse(address));

  if (response.statusCode == 200) {
    debugPrint("Response code is 200");
    //debugPrint("response body: ${response.body}");
    final data = jsonDecode(response.body);
    debugPrint("json decoded: ${data.length}");

    final List<ReceivedPolls> receivedPollList = [];

    for (var i = 0; i < data.length; i++) {
      int len = data[i]['polls'].length;
      final String uuid = data[i]['uuid'];
      final String title = data[i]['title'];

      List<Poll> polls = [];

      for (var x = 0; x < len; x++){
        final _polls = data[i]['polls'][x];
        //debugPrint("Polls question: ${_polls['question']}");
        //debugPrint("Polls answers: ${_polls['answers']}");
        Poll poll = Poll.fromJson(_polls);
        polls.add(poll);
      }

      ReceivedPolls receivedPolls = ReceivedPolls(polls: polls, uuid: uuid, title: title);
      receivedPollList.add(receivedPolls);
    }
    return receivedPollList;
  } else {
    debugPrint("Response code is NOT 200");
    throw Exception("Failed to load question");
  }
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

