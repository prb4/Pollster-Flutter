import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:pollster_flutter/history.dart';

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

class Question {
  final String prompt;
  final int question_id;
  final List<String> choices;

  const Question({
    required this.prompt,
    required this.question_id,
    required this.choices,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    debugPrint("Converting poll");
    final List<dynamic> answersList = json['choices'];
    final List<String> parsedAnswers = List<String>.from(answersList);

    debugPrint(parsedAnswers.toString());
    return Question(
      prompt: json['prompt'] as String,
      question_id: json['question_id'] as int,
      choices: parsedAnswers,
    );
  }

  Map<String, dynamic> toJson() => {
    'prompt': prompt,
    'question_id': question_id,
    'choices': choices,
  };
}

class ReceivedVotes {
  final List<Question> votes;
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
    

    List<Question> votesList = dynamicPolls
      .map((dynamic item) => Question(
        prompt: item['question'],
        question_id: item['question_id'],
        choices: item['answers'],
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

class Answer {
  int? question_id;
  String? answer;

  Answer({
    this.question_id,
    this.answer,
  });

  // Convert the Dart object to a Map
  Map<String, dynamic> toJson() {
    return {
      'question_id': question_id,
      'answer': answer,
    };
  }

  // Factory method to create a Person object from a Map
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      question_id: json['question_id'],
      answer: json['answer'],
    );
  }

  // Override the toString method for better display in print statements
  @override
  String toString() {
    return 'SelectedAnswer(question_id: $question_id, answer: $answer)';
  }
}

class CreatedPoll {
  String title;
  String poll_id;
  List<Question> questions;
  int user_id;
  String username;
  List<Contact>? contacts;

  CreatedPoll({
    required this.title,
    required this.poll_id,
    required this.questions,
    required this.user_id,
    required this.username,
    required this.contacts,
  });

  // Convert the Dart object to a Map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'recipients': contacts,
      'poll_id': poll_id,
      'user_id': user_id,
      'username': username,
      'questions': questions
    };
  }

  // Factory method to create a Person object from a Map
  factory CreatedPoll.fromJson(Map<String, dynamic> json) {
    return CreatedPoll(
      title: json['title'],
      contacts: json['recipients'],
      poll_id: json['poll_id'],
      user_id: json['user_id'],
      username: json['username'],
      questions: json['questions']
    );
  }

  // Override the toString method for better display in print statements
  @override
  String toString() {
    return 'CreatedPoll(title: $title, recipients: ${contacts.toString()}, poll_id: $poll_id, user_id: $user_id, username: $username, votes: ${questions.toString})';
  }
}

class Recipient {
  int answered; //TODO - this should be a bool
  int recipient;
  int creator;
  String poll_id;

  Recipient({
    required this.answered,
    required this.recipient,
    this.poll_id = "",
    this.creator = -1
  });

    // Convert the Dart object to a Map
  Map<String, dynamic> toJson() {
    return {
      'answered': answered,
      'recipient': recipient,
      'poll_id': poll_id,
      'originator': creator
    };
  }

  // Factory method to create a Person object from a Map
  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      answered: json['answered'],
      recipient: json['recipient'],
      poll_id: json['poll_id'],
      creator: json['originator']
    );
  }

  // Override the toString method for better display in print statements
  @override
  String toString() {
    return 'Recipient(answered: $answered, recipient: ${recipient.toString()}, poll_id: $poll_id, originator: ${creator.toString()})';
  }
}

class PollMetadata {
  String creator;
  String poll_id;
  String title;
  String created;

  PollMetadata({
    required this.creator,
    required this.title,
    required this.poll_id,
    required this.created,
  });

    // Convert the Dart object to a Map
  Map<String, dynamic> toJson() {
    return {
      'creator': creator,
      'title': title,
      'poll_id': poll_id,
      'created': created,
    };
  }

  // Factory method to create a Person object from a Map
  factory PollMetadata.fromJson(Map<String, dynamic> json) {
    return PollMetadata(
      creator: json['creator'],
      title: json['title'],
      poll_id: json['poll_id'],
      created: json['created'],
    );
  }

  // Override the toString method for better display in print statements
  @override
  String toString() {
    return 'PollMetadata(creator: ${creator.toString()}, title: $title, poll_id: $poll_id, created: $created)';
  }
}

class CreatedPollFull {
  PollMetadata pollMetadata;
  List<Question> questions;
  List<Contact> contacts;

  CreatedPollFull({
    required this.pollMetadata,
    required this.questions,
    required this.contacts,
  });

    // Convert the Dart object to a Map
  Map<String, dynamic> toJson() {
    return {
      'createdPollMetadata': pollMetadata,
      'votes': questions,
      'recipients': contacts,  
    };
  }

  // Factory method to create a Person object from a Map
  factory CreatedPollFull.fromJson(Map<String, dynamic> json) {
    return CreatedPollFull(
      pollMetadata: PollMetadata.fromJson(json['createdPollMetadata']),

      // Convert List<dynamic> to List<Vote>
      questions: json['votes'].map((dynamic item) {
        return Question(
          prompt: item['question'], 
          question_id: item['question_id'], 
          choices: item['answers']
        );
      }).toList(),

      contacts: json['recipeints'],
    );
  }

  // Override the toString method for better display in print statements
  @override
  String toString() {
    return 'CreatedPollFull(createdPollMetadata: ${pollMetadata.toString()}, votes: {$questions.toString()}, recipients: ${contacts.toString()}';
  }
}

class CreatingQuestion {
  final Question poll;
  final List<Contact>? contacts;

  const CreatingQuestion({
    required this.poll,
    required this.contacts,
  });

  factory CreatingQuestion.fromJson(Map<String, dynamic> json) {
    debugPrint("Converting question");
    final List<dynamic> answersList = json['answers'];
    final List<String> parsedAnswers = List<String>.from(answersList);

    final List<dynamic> contactsList = json['contacts'];
    final List<Contact> parsedContacts = List<Contact>.from(contactsList);

    Question newPoll = Question(prompt: json['question'], question_id: json['question_id'], choices: parsedAnswers);

    debugPrint(parsedAnswers.toString());
    return CreatingQuestion(
      //TODO - this rework may break
      poll: newPoll,
      contacts: parsedContacts,
    );
  }

  Map<String, dynamic> toJson() => {
    'question': poll.prompt,
    'answers': poll.choices,
    'contacts': contacts,
  };
}