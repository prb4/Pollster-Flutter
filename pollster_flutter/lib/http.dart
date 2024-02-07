import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pollster_flutter/models/poll.dart';
import 'package:pollster_flutter/user_session.dart';

String ip = "http://192.168.1.151:5000/";
//String ip = "http://172.16.44.50:5000/";

Future<Poll> fetchPoll(String poll_id) async {
  debugPrint("in fetchCreatedPoll: $poll_id");
  String endpoint = "/poll?user_id=${UserSession().userId}&poll_id=$poll_id";
  Map<String, dynamic> jsonData = await fetch(endpoint);
  debugPrint("[-] Received poll data: ${jsonData.runtimeType},  ${jsonData.toString()}");
  debugPrint("[---] ${jsonData['questions'][0]['choices'].runtimeType}");

  return Poll.fromJson(jsonData);

}

Future<Map<String, dynamic>> fetch(String endpoint) async {
  String address = ip + endpoint;
  try {
    final response = await http.get(Uri.parse(address));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load data');
    }
  } catch (e) {
    // Handle network errors or exceptions here
    print('Error: $e');
    throw e;
  }
}

Future<List<Map<String, dynamic>>> fetchList(String endpoint) async {
  String address = ip + endpoint;
  try {
    final response = await http.get(Uri.parse(address));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final Map<String, dynamic> data = json.decode(response.body);
      debugPrint("[-] $data");

      if (data.containsKey('createdPollsMetadata'))
      {
        debugPrint("[-] Key contains createdPollsMetadata");
        debugPrint("[-] Type: ${data['createdPollsMetadata'].runtimeType}");
        final List<Map<String, dynamic>> finalData = data['createdPollsMetadata'].cast<Map<String, dynamic>>();
        return finalData;
      }
      else if (data.containsKey('receivedPollsMetadata'))
      {
        debugPrint("[-] Key contains receivedPollsMetadata");
        final List<Map<String, dynamic>> finalData = data['receivedPollsMetadata'].cast<Map<String, dynamic>>();
        return finalData;
      }
      else if (data.containsKey('openPollsMetadata'))
      {
        debugPrint("[-] Key contains openPollsMetadata");
        final List<Map<String, dynamic>> finalData = data['openPollsMetadata'].cast<Map<String, dynamic>>();
        return finalData;      }
      else
      {
        debugPrint("[-] Key contained nothing");
        return []; // TODO - bad
      }
      
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load data');
    }
  } catch (e) {
    // Handle network errors or exceptions here
    print('Error: $e');
    throw e;
  }
}

Future<List<ReceivedVotes>> fetchPolls() async {
  String address = ip + "fetch?user_id=${UserSession().userId.toString()}";

  final response = await http
    .get(Uri.parse(address));

  if (response.statusCode == 200) {
    debugPrint("Response code is 200");
    //debugPrint("response body: ${response.body}");
    final data = jsonDecode(response.body);
    debugPrint("json decoded: ${data.length}");

    final List<ReceivedVotes> receivedVotesList = [];

    for (var i = 0; i < data.length; i++) {
      debugPrint("Data item: ${data[i].toString()}");
      
      final String uuid = data[i]['poll_id'];
      final String title = data[i]['title'];
      int len = data[i]['votes'].length;

      List<Question> polls = [];

      for (var x = 0; x < len; x++){
        final _polls = data[i]['votes'][x];
        //debugPrint("Polls question: ${_polls['question']}");
        //debugPrint("Polls answers: ${_polls['answers']}");
        Question poll = Question.fromJson(_polls);
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

Future<List<PollMetadata>> fetchCreated() async {
  debugPrint("in fetchCreated");
  String endpoint = "/polls?user_id=${UserSession().userId}&created=True&received=False";
  List<Map<String, dynamic>> jsonData = await fetchList(endpoint);


  List<PollMetadata> pollMetadataList = jsonData.map((Map<String, dynamic> item) {
    return PollMetadata(
      creator: item['creator'].toString(),
      title: item['title'], 
      poll_id: item['poll_id'], 
      created: item['created'],
    );
  }).toList();

  debugPrint("[-] pollMetadataList: ${pollMetadataList.toString()}");

  return pollMetadataList;

}


/*
  String address = ip + "/history/created?user_id=${UserSession().userId.toString()}";

  final response = await http
    .get(Uri.parse(address));

  if (response.statusCode == 200) {
    debugPrint("Response code is 200");
    //debugPrint("response body: ${response.body}");
    final jsonData = jsonDecode(response.body);
    //debugPrint("json: ${data.toString()}");

    List<dynamic> createdPollsJsonDynamicList = jsonData['createdPollMetadata'];

    debugPrint("Created Polls Metadata: ${createdPollsJsonDynamicList.runtimeType}");

    List<PollMetadata> createdPollMetadataList = [];
    for (var createdPollMetadata in createdPollsJsonDynamicList){

      // Convert List<dynamic> to List<Recipient>
      List<Recipient> recipientList = [];
      for (Map<String, dynamic> item in createdPollMetadata['recipients']){
        debugPrint("[-] Recipient: ${item.toString()}");
        recipientList.add(Recipient.fromJson(item));
      }

      createdPollMetadata['recipients'] = recipientList;
      PollMetadata tmp = PollMetadata.fromJson(createdPollMetadata);
      createdPollMetadataList.add(tmp);
      debugPrint("[-] Added item to createdPollMetadataList: ${tmp.toString()}");
    }

    return createdPollMetadataList;
  } else {
    debugPrint("Response code is NOT 200");
    throw Exception("Failed fetchHistory");
  }
}
*/
Future<List<PollMetadata>> fetchReceieved() async {
  debugPrint("in fetchReceived");
  String endpoint = "/polls?user_id=${UserSession().userId}&created=False&received=True";
  List<Map<String, dynamic>> jsonData = await fetchList(endpoint);


  List<PollMetadata> pollMetadataList = jsonData.map((Map<String, dynamic> item) {
    return PollMetadata(
      creator: item['creator'].toString(),
      title: item['title'], 
      poll_id: item['poll_id'], 
      created: item['created'],
    );
  }).toList();

  return pollMetadataList;
}

Future<List<PollMetadata>> fetchOpen() async {
  debugPrint("in fetchOpen");
  String endpoint = "/polls?user_id=${UserSession().userId}&open=True&created=False&received=True";
  List<Map<String, dynamic>> jsonData = await fetchList(endpoint);


  List<PollMetadata> pollMetadataList = jsonData.map((Map<String, dynamic> item) {
    return PollMetadata(
      creator: item['creator'].toString(),
      title: item['title'], 
      poll_id: item['poll_id'], 
      created: item['created'],
    );
  }).toList();

  return pollMetadataList;
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

