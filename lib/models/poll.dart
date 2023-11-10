import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PollItem extends StatelessWidget{
  final String input;
  final bool isQuestion;
  final bool isOptional;
  final Function onChanged;
  final TextEditingController textController;
  final Function? onClickedSuffixIcon;

  const PollItem({required this.input, required this.isQuestion, required this.isOptional, required this.onChanged, required this.textController, this.onClickedSuffixIcon});

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
            //suffixIcon: isOptional ? const Icon(Icons.remove_circle_outline) : null,

            suffixIcon: isOptional ? IconButton( 
                icon: const Icon(Icons.remove_circle_outline), 
                onPressed: () {
                  onClickedSuffixIcon!();
                }, 
              ) : null, 

            hintText: input,
          ),
          onChanged: (String input){
            onChanged(input);
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