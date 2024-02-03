import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

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

class CreatedPoll {
  String title;
  String poll_id;
  List<Vote> votes;
  int user_id;
  String username;
  List<Contact>? contacts;

  CreatedPoll({
    required this.title,
    required this.poll_id,
    required this.votes,
    required this.user_id,
    required this.username,
    required this.contacts,
  });

  // Convert the Dart object to a Map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'contacts': contacts,
      'poll_id': poll_id,
      'user_id': user_id,
      'username': username,
      'votes': votes
    };
  }

  // Factory method to create a Person object from a Map
  factory CreatedPoll.fromJson(Map<String, dynamic> json) {
    return CreatedPoll(
      title: json['title'],
      contacts: json['contacts'],
      poll_id: json['poll_id'],
      user_id: json['user_id'],
      username: json['username'],
      votes: json['votes']
    );
  }

  // Override the toString method for better display in print statements
  @override
  String toString() {
    return 'CreatedPoll(title: $title, contacts: $contacts, poll_id: $poll_id, user_id: $user_id, username: $username, votes: ${votes.toString})';
  }
}

class Recipient {
  int answered; //TODO - this should be a bool
  int recipient;

  Recipient({
    required this.answered,
    required this.recipient
  });

    // Convert the Dart object to a Map
  Map<String, dynamic> toJson() {
    return {
      'answered': answered,
      'recipient': recipient
    };
  }

  // Factory method to create a Person object from a Map
  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      answered: json['answered'],
      recipient: json['recipient']
    );
  }

  // Override the toString method for better display in print statements
  @override
  String toString() {
    return 'Recipient(answered: $answered, recipient: ${recipient.toString()})';
  }
}

class CreatedPollMetadata {
  String created;
  String poll_id;
  String title;
  List<Recipient> recipients;

  CreatedPollMetadata({
    required this.created,
    required this.title,
    required this.poll_id,
    required this.recipients
  });

    // Convert the Dart object to a Map
  Map<String, dynamic> toJson() {
    return {
      'created': created,
      'title': title,
      'poll_id': poll_id,
      'recipients': recipients
    };
  }

  // Factory method to create a Person object from a Map
  factory CreatedPollMetadata.fromJson(Map<String, dynamic> json) {
    return CreatedPollMetadata(
      created: json['created'],
      title: json['title'],
      poll_id: json['poll_id'],
      recipients: json['recipients'] as List<Recipient>
    );
  }

  // Override the toString method for better display in print statements
  @override
  String toString() {
    return 'CreatedPollMetadata(created: $created, title: $title, poll_id: $poll_id, recipients: ${recipients.toString()})';
  }
}

class ReceivedPollMetadata {
  String title;
  String poll_id;

  ReceivedPollMetadata({
    required this.title,
    required this.poll_id,
  
  });

    // Convert the Dart object to a Map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'poll_id': poll_id,
    };
  }

  // Factory method to create a Person object from a Map
  factory ReceivedPollMetadata.fromJson(Map<String, dynamic> json) {
    return ReceivedPollMetadata(
      title: json['title'],
      poll_id: json['poll_id'],
    );
  }

  // Override the toString method for better display in print statements
  @override
  String toString() {
    return 'ReceivedPollMetadata(title: $title, poll_id: $poll_id)';
  }
}

class HistoricMetadata {
  List<CreatedPollMetadata> createdPollMetadata;
  List<ReceivedPollMetadata> receivedPollMetadata;

  HistoricMetadata({
    required this.createdPollMetadata,
    required this.receivedPollMetadata,
  });

  @override
  String toString() {
    return 'HistoricMetadata(createdPollMetadata: ${createdPollMetadata.toString()}, recivedPollMetadata: ${receivedPollMetadata.toString()})';
  }

}
class CreatingQuestion {
  final Vote poll;
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

    Vote newPoll = Vote(question: json['question'], question_id: json['question_id'], answers: parsedAnswers);

    debugPrint(parsedAnswers.toString());
    return CreatingQuestion(
      //TODO - this rework may break
      poll: newPoll,
      contacts: parsedContacts,
    );
  }

  Map<String, dynamic> toJson() => {
    'question': poll.question,
    'answers': poll.answers,
    'contacts': contacts,
  };
}