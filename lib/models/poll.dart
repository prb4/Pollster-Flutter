import 'package:flutter/material.dart';

class PollItem extends StatelessWidget{
  final String input;
  final bool isQuestion;
  final bool isOptional;
  final Function onSubmitted;

  const PollItem({required this.input, required this.isQuestion, required this.isOptional, required this.onSubmitted});

  //TODO - maybe change to onChanged method so it doesnt require the submit button on the key pad
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
          onSubmitted: (String input){
            onSubmitted(input);
          }
        )
      )
    );
  }
}