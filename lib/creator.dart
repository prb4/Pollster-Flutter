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
    //textFields.add(const RequiredEditText("Enter questions"));
    //textFields.add(const RequiredEditText("Enter answer"));

    return const Scaffold(
        body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          RequiredEditText("Enter question"),
          RequiredEditText("Enter answer"),
          OptionalEditText("Enter optional answer"),
        //  Expanded(
        //    child: ListView(
        //      children: textFields),
        //      ),
        //  ElevatedButton(
        //    onPressed: () {
        //      setState(() {
        //        textFields.add(const TextField());
        //      });
        //    },
        //    child: const OptionalEditText("Enter answer"),
        //    )
        ],
      )
    );
  }
}
/*
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RequiredEditText("Enter question"),
        Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16)),
        RequiredEditText("Enter answer"),
      ]
    );
  }
}
*/
class RequiredEditText extends StatelessWidget {
  final String messageHint;
  const RequiredEditText(this.messageHint);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextField(
          decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: messageHint,
          ),
        )
      )
    );
  }
}

class OptionalEditText extends StatelessWidget {
  //TODO - add the ability to delete this option
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