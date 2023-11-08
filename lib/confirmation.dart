import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:pollster_flutter/http.dart';


class Confirmation extends StatelessWidget {
  final List<Contact> selectedContacts;
  //final List<PollItem> pollItems;
  final String question;
  final List<String>? answers;

  const Confirmation({required this.selectedContacts, required this.question, required this.answers});

  @override
  Widget build(BuildContext context) {
    debugPrint("In confirmation: $selectedContacts, $question, $answers");
    CreatingQuestion createdQuestion = CreatingQuestion(question: question, answers:answers, contacts: selectedContacts);

    debugPrint("Sending question to POST endpoint");
    sendPostRequest(createdQuestion.toJson(), "submit/question");

    return const Text("In confirmation");
    
  }
}