import 'package:flutter/material.dart';
import 'package:pollster_flutter/creator.dart';
import 'package:pollster_flutter/history.dart';
import 'package:pollster_flutter/responder.dart';


class Home extends StatelessWidget {

  const Home();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
        children: [
          Expanded(
            flex:5,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TitlePoll()),
                );
              },
              child: const CardWidget(message: "Create new poll"),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container()
          ),
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  //MaterialPageRoute(builder: (context) => const Responder()),
                  MaterialPageRoute(builder: (context) => OpenPolls()),
                );
              },
              child: const CardWidget(message: "Answer open poll"),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container()
          ),
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => History()),
                );
              },
              child: const CardWidget(message: "View history"),
            ),
          ),
        ]
      )
    );
  }
}

class CardWidget extends StatelessWidget {
  final String message;
  const CardWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: SizedBox(
        width: 300,
        height: 100,
        child: Center(
          child: Text(
            message,
            style: Theme.of(context).textTheme.headlineMedium,
          )
        ),
      ),
      
    );
  }
}