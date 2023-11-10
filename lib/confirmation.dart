import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:pollster_flutter/http.dart';
import 'package:pollster_flutter/models/poll.dart';


class Confirmation extends StatelessWidget {
  final List<Contact> selectedContacts;
  final List<Poll> polls;
  List<CreatingQuestion> createdQuestions = [];
  //final String question;
  //final List<String>? answers;

  Confirmation({required this.selectedContacts, required this.polls});

  @override
  Widget build(BuildContext context) {
    debugPrint("In confirmation");
    /*
    for (var poll in polls){
      debugPrint("Creating question: question: ${poll.question}, answers: ${poll.answers!.toList()}");
      CreatingQuestion createdQuestion = CreatingQuestion(poll: poll, contacts: selectedContacts);  
      createdQuestions.add(createdQuestion);

    }
    */

    FinalPoll finalPoll = FinalPoll(polls: polls, contacts: selectedContacts);
    debugPrint("Sending question to POST endpoint");
    
    //TODO - handle sending a list to the server
    sendPostRequest(finalPoll.toJson(), "submit/poll");

    return const Text("In confirmation");
    
  }
}