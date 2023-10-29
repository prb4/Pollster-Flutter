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
                MaterialPageRoute(builder: (context) => const BuildPoll()),
              );
            },
          )
        )
      )
    );
  }
}

class BuildPoll extends StatelessWidget {
  const BuildPoll({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Start building'));
  }
}