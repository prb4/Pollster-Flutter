import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:pollster_flutter/http.dart';
import 'package:pollster_flutter/models/poll.dart';
import 'package:pollster_flutter/contacts_widget.dart';

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
      body: SafeArea(
        child: Column(
        children: [
          Wrap(
            children: selectedContacts.map(
              (selectedContact) {
                return MyClickableChip(
                  label: selectedContact.displayName,
                  onTap: () {
                    final index = selectedContacts.indexOf(selectedContact);
                    debugPrint("[-] Removing contact from list: ${index.toString()} : ${selectedContact.displayName}");
                    //ref.read(myContactsProvider).removeContact(index);
                  },
                );
              }
            ).toList(),
          ),
          Expanded(
            child: ListView.builder( //TODO - too close to the top
              padding: const EdgeInsets.all(8),
              itemCount: polls.length,
              itemBuilder: (context, index) =>
                PollReview(poll: polls[index]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
          //                  Navigator.push(
          //                    context,
          //                    MaterialPageRoute(builder: (context) => const Creator()),
          //                  ); 

            },
            child: const Text('Confirm'),
          ),
        ]
      )
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
        
        child: Stack(
          children: [
            Column(
              children: [ 
                  Text(poll.question!),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.all(8),
                    itemCount: poll.answers!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 50,
                        child: Center(child: Text(poll.answers![index])),
                      );
                    }
                  ),

              ]
            ),
            CornerIcon(icon: Icons.edit, color: Colors.black, alignment: Alignment.topLeft, onTap: () {
              debugPrint("Clicked on edit button");
            },),
            CornerIcon(icon: Icons.delete, color: Colors.red, alignment: Alignment.topRight, onTap: () {
              debugPrint("Clicked on delete button");
            },)
          ]
        )
      );
    }
}

class CornerIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Alignment alignment;
  final Function onTap;

  const CornerIcon({required this.icon, required this.color, required this.alignment, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: 24.0,
            color: color,
          ),
        )
      )
    );
  }
}