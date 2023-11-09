import 'package:flutter/material.dart';

class PollItem extends StatelessWidget{
  final String input;
  final bool isQuestion;
  final bool isOptional;
  final Function onSubmitted;
  final TextEditingController textController;

  const PollItem({required this.input, required this.isQuestion, required this.isOptional, required this.onSubmitted, required this.textController});

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
          },
          controller: textController,
        )
      )
    );
  }
}

class Poll {
  final String? question;
  final List<String>? answers;

  const Poll({
    required this.question,
    required this.answers,
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    debugPrint("Converting poll");
    final List<dynamic> answersList = json['answers'];
    final List<String> parsedAnswers = List<String>.from(answersList);

    debugPrint(parsedAnswers.toString());
    return Poll(
      question: json['question'] as String,
      answers: parsedAnswers,
    );
  }

  Map<String, dynamic> toJson() => {
    'question': question,
    'answers': answers,
  };
}