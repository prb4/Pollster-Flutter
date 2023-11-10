import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:pollster_flutter/http.dart';
import 'package:pollster_flutter/models/poll.dart';


class Confirmation extends StatelessWidget {
  final List<Contact> selectedContacts;
  final List<Poll> polls;
  List<CreatingQuestion> createdQuestions = [];

  Confirmation({required this.selectedContacts, required this.polls});

  @override
  Widget build(BuildContext context) {
    debugPrint("In confirmation");

    FinalPoll finalPoll = FinalPoll(polls: polls, contacts: selectedContacts);
    
    sendPostRequest(finalPoll.toJson(), "submit/poll");

    return const Text("In confirmation");
    
  }
}