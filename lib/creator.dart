//import 'dart:ffi';
//import 'dart:js_interop';

import 'package:flutter/material.dart';
//import 'contacts.dart';


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
  
  
  @override
  Widget build(BuildContext context) {

    List<PollItem> _pollItemList = [];
    _pollItemList.add(PollItem(input: "Add question", isQuestion: true, isOptional: false));
    _pollItemList.add(PollItem(input: "Add answer", isQuestion: false, isOptional: false));

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
                            debugPrint("Clicking add answer button: ${_pollItemList.length}");
                            _pollItemList.add(PollItem(input: "Add optional answer", isQuestion: false, isOptional: true));
                            debugPrint("Clicked add answer button: ${_pollItemList.length}");
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
                    const OutlinedButtonExample("Add answer"),
                  
                ],
              ),
              
              //Expanded(
                //child: ListView.separated(
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _pollItemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      PollItem _pollItem = _pollItemList[index];
                      debugPrint("pollItem - ${index} - ${_pollItemList.length}");
                      /*
                      setState(() {
                        _pollItemList.removeAt(index);
                        _pollItemList.insert(index, _pollItem);
                      });
                      */
                      return _pollItem;
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  )
              //)
              
              // _contact == null ? Container() : CaregiversList(_contact.fullName),
            ],
          ),
        ),
      ),
    );
  }
}

class RequiredEditText extends StatelessWidget {
  final String messageHint;
  final bool isQuestion;
  const RequiredEditText(this.messageHint, this.isQuestion);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextField(
          decoration: InputDecoration(
          border: const OutlineInputBorder(),
          prefixIcon: isQuestion ? const Icon(Icons.question_mark_sharp) : null,
          hintText: messageHint,
          ),
        )
      )
    );
  }
}

class OptionalEditText extends StatelessWidget {
  final String messageHint;
  const OptionalEditText(this.messageHint);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextField(
          decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: messageHint,
          suffixIcon: const Icon(Icons.remove_circle_outline),
          ),
        )
      )
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