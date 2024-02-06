import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:pollster_flutter/crypto.dart';
import 'package:pollster_flutter/home_page.dart';
import 'package:pollster_flutter/http.dart';
import 'package:pollster_flutter/models/poll.dart';
import 'package:pollster_flutter/contacts_widget.dart';
import 'package:pollster_flutter/user_session.dart';

class Confirmation extends StatelessWidget {
  final String title;
  final List<Questions> votes;
  final List<Contact> selectedContacts;
  //final CreatedPoll createdPoll;
  final List<CreatingQuestion> createdQuestions = [];

  Confirmation({
    required this.selectedContacts,
    required this.title,
    required this.votes
    });

  CreatedPoll finalizeCreatedPoll(List<Contact> contacts, String title, List<Questions> votes){
    return CreatedPoll(title: title, poll_id: getUUID(), questions: votes, user_id: UserSession().userId, username: UserSession().username, contacts: contacts);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("In confirmation");

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
                  },
                );
              }
            ).toList(),
          ),
          SizedBox(
            child: Text(title),
            height: 50,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: votes.length,
              itemBuilder: (context, index) =>
                PollReview(poll: votes[index]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              debugPrint("Confirmation button pressed - sending poll");
              CreatedPoll createdPoll = finalizeCreatedPoll(selectedContacts, title, votes);
              
              await sendPostRequest(createdPoll.toJson(), "/submit/poll");
              debugPrint("Navigating...");
             
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => const Home()),
                (route) => false,
                );

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
  final Questions poll;

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
                  Text(poll.prompt),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.all(8),
                    itemCount: poll.choices.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 50,
                        child: Center(child: Text(poll.choices[index])),
                      );
                    }
                  ),

              ]
            ),
            /*
            CornerIcon(icon: Icons.edit, color: Colors.black, alignment: Alignment.topLeft, onTap: () {
              debugPrint("Clicked on edit button");
            },),
            CornerIcon(icon: Icons.delete, color: Colors.red, alignment: Alignment.topRight, onTap: () {
              debugPrint("Clicked on delete button");
            },)
            */
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