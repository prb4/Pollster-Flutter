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

    //FinalPoll finalPoll = FinalPoll(polls: polls, contacts: selectedContacts);
    
    //sendPostRequest(finalPoll.toJson(), "submit/poll");

    return Scaffold(
      body: ListView.builder( //TODO - too close to the top
        padding: const EdgeInsets.all(8),
        itemCount: polls.length,
        itemBuilder: (context, index) =>
          PollReview(poll: polls[index]),
      )
    );    
  }
}

class PollReview extends StatelessWidget {
  final Poll poll;

  const PollReview({required this.poll});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          children: [ 
            SizedBox(
              width: 300,
              height: 100,
              child: Center(child: Text(poll.question!))
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: poll.answers!.length,
              itemBuilder: (context, index) => 
                SizedBox(
                  width: 300,
                  height: 100,
                  child: Center(child: Text(poll.answers![index])),
                  )
                )
          ]
        )
    );
  }
}