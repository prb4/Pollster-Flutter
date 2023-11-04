//import 'dart:ffi';
//import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:pollster_flutter/contacts.dart';
//import 'contacts.dart';
import 'package:pollster_flutter/state_contacts.dart';


class Creator extends StatelessWidget {
  const Creator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Center(
          child: ElevatedButton(
            child: const Text('Create new poll'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BuildPoll()),
              );
            },
          )
        )
      )
    );
  }
}

class BuildPoll extends StatefulWidget {
  @override
  _BuildPollState createState() => _BuildPollState();
}

class _BuildPollState extends State<BuildPoll> {
  List<Widget> textFields = [];
  List<PollItem> pollItemList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create poll",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            debugPrint("Implement go back");
          }
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  MaterialButton(
                      onPressed: () {
                          setState(() {
                            debugPrint("Adding pollItem");
                            pollItemList.add(PollItem(input: "Add optional answer", isQuestion: false, isOptional: true));
                          });
                      },
                      color: const Color(0xffd4d411),
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(3),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.add,
                        size: 32,
                      ),

                    ),
                    
                ],
              ),
                PollItem(input: "Add question", isQuestion: true, isOptional: false),
                PollItem(input: "Add answer", isQuestion: false, isOptional: false),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  primary: false,
                  itemCount: pollItemList.length,
                  itemBuilder: (BuildContext context, int index) {
                    PollItem _pollItem = pollItemList[index];
                    debugPrint("pollItem - ${index} - ${pollItemList.length}");
                    return _pollItem;
                  },
                  separatorBuilder: (_, __) => const Divider(),
                ),
                ElevatedButton(
                  child: const Text('Next'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      //MaterialPageRoute(builder: (context) => FlutterContactsExample()),
                      MaterialPageRoute(builder: (context) => stateContacts()),
                    );
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}

class OutlinedButtonExample extends StatelessWidget {
  //const OutlinedButtonExample({super.key});
  final String message;
  const OutlinedButtonExample(this.message);

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20,
          color: const Color(0xff000000),
          height: 1.5384615384615385,
          fontWeight: FontWeight.w600),
      textHeightBehavior:
          TextHeightBehavior(applyHeightToFirstAscent: false),
      textAlign: TextAlign.left,
    );
  }
}

class PollItem extends StatelessWidget{
  final String input;
  final bool isQuestion;
  final bool isOptional;

  PollItem({required this.input, required this.isQuestion, required this.isOptional});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextField(
          decoration: InputDecoration(
          border: const OutlineInputBorder(),
          prefixIcon: isQuestion ? const Icon(Icons.question_mark_sharp) : null,
          suffixIcon: isOptional ? const Icon(Icons.remove_circle_outline) : null,
          hintText: input,
          ),
        )
      )
    );
  }
}