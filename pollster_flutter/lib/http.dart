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

Future<List<CreatedPollMetadata>> fetchHistoricCreated() async {
  String address = ip + "/history/created?user_id=${UserSession().userId.toString()}";

  final response = await http
    .get(Uri.parse(address));

  if (response.statusCode == 200) {
    debugPrint("Response code is 200");
    //debugPrint("response body: ${response.body}");
    final jsonData = jsonDecode(response.body);
    //debugPrint("json: ${data.toString()}");

    List<dynamic> createdPollsJsonDynamicList = jsonData['created_polls_metadata'];

    debugPrint("Created Polls Metadata: ${createdPollsJsonDynamicList.runtimeType}");

    List<CreatedPollMetadata> createdPollMetadataList = [];
    for (var createdPollMetadata in createdPollsJsonDynamicList){

      // Convert List<dynamic> to List<Recipient>
      List<Recipient> recipientList = [];
      for (Map<String, dynamic> item in createdPollMetadata['recipients']){
        recipientList.add(Recipient.fromJson(item));
      }

      createdPollMetadata['recipients'] = recipientList;
      CreatedPollMetadata tmp = CreatedPollMetadata.fromJson(createdPollMetadata);
      createdPollMetadataList.add(tmp);
      debugPrint("[-] Added item to createdPollMetadataList: ${tmp.toString()}");
    }

    return createdPollMetadataList;
  } else {
    debugPrint("Response code is NOT 200");
    throw Exception("Failed fetchHistory");
  }
}

Future<List<ReceivedPollMetadata>> fetchHistoricReceieved() async {
  String address = ip + "/history/received?user_id=${UserSession().userId.toString()}";

  final response = await http
    .get(Uri.parse(address));

  if (response.statusCode == 200) {
    debugPrint("Response code is 200");
    //debugPrint("response body: ${response.body}");
    final jsonData = jsonDecode(response.body);
    //debugPrint("json: ${data.toString()}");

    List<dynamic> receievedPollsJsonDynamicList = jsonData['received_polls_metadata'];

    debugPrint("Receieved Polls Metadata: ${receievedPollsJsonDynamicList.runtimeType}");

    List<ReceivedPollMetadata> receivedPollMetadataList = [];
    for (var jsonMap in jsonData['received_polls_metadata']){
      ReceivedPollMetadata tmp = ReceivedPollMetadata.fromJson(jsonMap);
      receivedPollMetadataList.add(tmp);
      debugPrint("[-] Added item to receievedPollMetadataList: ${tmp.toString()}");
    }

    return receivedPollMetadataList;
  } else {
    debugPrint("Response code is NOT 200");
    throw Exception("Failed fetchHistory");
  }
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

