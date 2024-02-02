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

class Vote {
  final String question;
  final int question_id;
  final List<String> answers;

  const Vote({
    required this.question,
    required this.question_id,
    required this.answers,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    debugPrint("Converting poll");
    final List<dynamic> answersList = json['answers'];
    final List<String> parsedAnswers = List<String>.from(answersList);

    debugPrint(parsedAnswers.toString());
    return Vote(
      question: json['question'] as String,
      question_id: json['question_id'] as int,
      answers: parsedAnswers,
    );
  }

  Map<String, dynamic> toJson() => {
    'question': question,
    'question_id': question_id,
    'answers': answers,
  };
}

class TitledPoll {
  final String title;
  final List<Vote> polls;

  const TitledPoll({
    required this.title,
    required this.polls,
  });

  factory TitledPoll.fromJson(Map<String, dynamic> json) {
    debugPrint("Converting poll");
    final List<dynamic> pollsList = json['polls'];
    final List<Vote> parsedPolls = List<Vote>.from(pollsList);

    debugPrint(parsedPolls.toString());
    return TitledPoll(
      title: json['title'] as String,
      polls: parsedPolls,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'polls': polls,
  };
}

class ReceivedVotes {
  final List<Vote> votes;
  final String uuid;
  final String title;

  const ReceivedVotes({
    required this.votes,
    required this.uuid,
    required this.title,
  });

  factory ReceivedVotes.fromJson(String uuid, Map<String, dynamic> json, String title) {
    debugPrint("Converting ReceivedVotes");
    debugPrint("Poll: ${json}");
    final List<dynamic> dynamicPolls = json['votes'];
    debugPrint("dynamicPolls: ${dynamicPolls.toString()}");
    

    List<Vote> votesList = dynamicPolls
      .map((dynamic item) => Vote(
        question: item['question'],
        question_id: item['question_id'],
        answers: item['answers'],
      )).toList();

    debugPrint("pollsList: ${votesList.toString()}");
    debugPrint("Polls List type: ${votesList.runtimeType}");

    return ReceivedVotes(
      votes: votesList,
      uuid: uuid,
      title: title,
    );
  }

  Map<String, dynamic> toJson() => {
    'polls': votes,
    'uuid': uuid,
  };
}

class SelectedAnswer {
  int? question_id;
  String? selectedAnswer;

  SelectedAnswer({
    this.question_id,
    this.selectedAnswer,
  });

  // Convert the Dart object to a Map
  Map<String, dynamic> toJson() {
    return {
      'question_id': question_id,
      'selectedAnswer': selectedAnswer,
    };
  }

  // Factory method to create a Person object from a Map
  factory SelectedAnswer.fromJson(Map<String, dynamic> json) {
    return SelectedAnswer(
      question_id: json['question_id'],
      selectedAnswer: json['selectedAnswer'],
    );
  }

  // Override the toString method for better display in print statements
  @override
  String toString() {
    return 'SelectedAnswer(question_id: $question_id, selectedAnswer: $selectedAnswer)';
  }

  
}