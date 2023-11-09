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
    debugPrint("In confirmation: $selectedContacts, ${polls[0].question}, ${polls[0].answers}");
    for (var poll in polls){
      CreatingQuestion createdQuestion = CreatingQuestion(poll: poll, contacts: selectedContacts);  
      createdQuestions.add(createdQuestion);

    }
    debugPrint("Sending question to POST endpoint");
    
    //TODO - handle sending a list to the server
    //sendPostRequest(createdQuestion.toJson(), "submit/question");

    return const Text("In confirmation");
    
  }
}