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

class Question {
  final String prompt;
  final int questionId;
  final List<String> choices;

  const Question({
    required this.prompt,
    required this.questionId,
    required this.choices,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    debugPrint("Converting poll");
    final List<dynamic> answersList = json['choices'];
    final List<String> parsedAnswers = List<String>.from(answersList);

    debugPrint(parsedAnswers.toString());
    return Question(
      prompt: json['prompt'] as String,
      questionId: json['question_id'] as int,
      choices: parsedAnswers,
    );
  }

  Map<String, dynamic> toJson() => {
    'prompt': prompt,
    'question_id': questionId,
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
    debugPrint("Poll: $json");
    final List<dynamic> dynamicPolls = json['votes'];
    debugPrint("dynamicPolls: ${dynamicPolls.toString()}");
    

    List<Question> votesList = dynamicPolls
      .map((dynamic item) => Question(
        prompt: item['question'],
        questionId: item['question_id'],
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
  String? answerId;
  int? questionId;
  String pollId;
  String? answer;

  Answer({
    this.answerId,
    this.questionId,
    required this.pollId,
    this.answer,
  });

  // Convert the Dart object to a Map
  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'answer': answer,
      'poll_id': pollId,
      'answer_id': answerId,
    };
  }

  // Factory method to create a Person object from a Map
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      questionId: json['question_id'],
      answer: json['answer'],
      pollId: json['poll_id'],
      answerId: json['answer_id'],
    );
  }

  // Override the toString method for better display in print statements
  @override
  String toString() {
    return 'Answer(question_id: $questionId, answer: $answer, answer_id:${answerId.toString()}, poll_id: ${pollId.toString()})';
  }
}

class Poll {
  List<Question> questions;
  PollMetadata pollMetadata;
  List<Recipient> recipients;
  

  Poll({
    required this.questions,
    required this.pollMetadata,
    required this.recipients,
  });

  // Convert the Dart object to a Map
  Map<String, dynamic> toJson() {
    return {
      'recipients': recipients,
      'pollMetadata': pollMetadata,
      'questions': questions,
    };
  }



  // Factory method to create a Person object from a Map
  factory Poll.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dynamicRecipients = json['recipients'];
    List<Recipient> recipientList = dynamicRecipients
      .map((dynamic item) => Recipient(
        answered: item['answered'], 
        recipient: item['recipient'],
        creator: item['creator'],
        poll_id: item['poll_id'],
        )).toList();

    final List<dynamic> dynamicQuestions = json['questions'];

    List<Question> questions = [];
    for (var question in dynamicQuestions){
      
      final List<dynamic> choicesList = question['choices'];
      final List<String> choices = List<String>.from(choicesList);

      Question tmp = Question(
        prompt: question['prompt'], 
        questionId: question['question_id'], 
        choices: choices);
        questions.add(tmp);
    }

    return Poll(
      questions: questions,
      pollMetadata: PollMetadata.fromJson(json['pollMetadata']),
      recipients: recipientList
      );
  }

  // Override the toString method for better display in print statements
  @override
  String toString() {
    return 'Poll(recipients: ${recipients.toString()}, pollMetadata: ${pollMetadata.toString()}, questions: ${questions.toString()})';
  }
}

class AnsweredQuestion {
  String prompt;
  String answer;
  List<String> choices;
  String questionId;
  

  AnsweredQuestion({
    required this.prompt,
    required this.answer,
    required this.choices,
    required this.questionId,
  });

  // Convert the Dart object to a Map
  Map<String, dynamic> toJson() {
    return {
      'answer': prompt,
      'answer_id': answer,
      'choices': choices,
      'question_id': questionId,
    };
  }

  // Factory method to create a Person object from a Map
  factory AnsweredQuestion.fromJson(Map<String, dynamic> json) {
    return AnsweredQuestion(
      prompt: json['answer'],
      answer: json['answer_id'],
      choices: json['choices'],
      questionId: json['question_id'],
      );
  }

  // Override the toString method for better display in print statements
  @override
  String toString() {
    return 'AnsweredQuestion(answer: $prompt, anwer_id: ${answer.toString()}, choices: ${choices.toString()}, questionId: ${questionId.toString()})';
  }
}

class AnsweredPoll {
  String pollId;
  String recipient;
  List<AnsweredQuestion> answeredQuestions;
  

  AnsweredPoll({
    required this.pollId,
    required this.recipient,
    required this.answeredQuestions,
  });

  // Convert the Dart object to a Map
  Map<String, dynamic> toJson() {
    return {
      'poll_id': pollId,
      'recipient': recipient,
      'answeredQuestions': answeredQuestions
    };
  }



  // Factory method to create a Person object from a Map
  factory AnsweredPoll.fromJson(Map<String, dynamic> json) {
    return AnsweredPoll(
      pollId: json['poll_id'],
      recipient: json['recipient'],
      answeredQuestions: json['answeredQuestions']
      );
  }

  // Override the toString method for better display in print statements
  @override
  String toString() {
    return 'AnsweredPoll(recipient: ${recipient.toString()},poll_id: ${pollId.toString()}, answeredQuestions: ${answeredQuestions.toString()})';
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
      'creator': creator
    };
  }

  // Factory method to create a Person object from a Map
  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      answered: json['answered'],
      recipient: json['recipient'],
      poll_id: json['poll_id'],
      creator: json['creator']
    );
  }

  // Override the toString method for better display in print statements
  @override
  String toString() {
    return 'Recipient(answered: $answered, recipient: ${recipient.toString()}, poll_id: $poll_id, creator: ${creator.toString()})';
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
      creator: json['creator'].toString(),
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

    Question newPoll = Question(prompt: json['question'], questionId: json['question_id'], choices: parsedAnswers);

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

class HistoricCreatedQuestion {
  final String pollId;
  final String prompt;
  final String questionId;
  final List<String> choices;

  const HistoricCreatedQuestion({
    required this.pollId,
    required this.prompt,
    required this.questionId,
    required this.choices,
  });

  factory HistoricCreatedQuestion.fromJson(Map<String, dynamic> json) {
    final List<dynamic> choicesList = json['choices'];
    final List<String> choices = List<String>.from(choicesList);
    final questionId = json['question_id'].toString();
    final pollId = json['pollId'].toString();
    debugPrint("QuestionId: $questionId, pollId: $pollId");
    
    return HistoricCreatedQuestion(
      pollId: pollId,
      prompt: json['prompt'].toString(),
      questionId: questionId,
      choices: choices
    );
  }

  Map<String, dynamic> toJson() => {
    'pollId': pollId,
    'prompt': prompt,
    'questionId': questionId,
    'choices': choices
  };

  @override
  String toString() {
    return 'HistoricCreatedQuestion(questionId: $questionId, prompt: $prompt, pollId: $pollId, choices: ${choices.toList()})';
  }
}

class ReturnedAnswer {
  final int questionId;
  final String answer;

  ReturnedAnswer({
    required this.questionId,
    required this.answer,
  });

  // Convert the Dart object to a Map
  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'answer': answer,
    };
  }

  // Factory method to create a Person object from a Map
  factory ReturnedAnswer.fromJson(Map<String, dynamic> json) {
    return ReturnedAnswer(
      questionId: json['question_id'],
      answer: json['answer'],
    );
  }

  // Override the toString method for better display in print statements
  @override
  String toString() {
    return 'ReturnedAnswer(question_id: $questionId, answer: $answer)';
  }
}

class HistoricCreatedRecipient {
  final int answered;
  final String creator;
  final String pollId;
  final String recipient;
  final List<ReturnedAnswer> answers;
  //answers 

  HistoricCreatedRecipient({
    required this.answered,
    required this.creator,
    required this.pollId,
    required this.recipient,
    required this.answers,
  });

  factory HistoricCreatedRecipient.fromJson(Map<String, dynamic> json) {
    final List<dynamic> answersList = json['answers'];
    final List<ReturnedAnswer> answers = List<ReturnedAnswer>.from(answersList);

    return HistoricCreatedRecipient(
      answered: json['answered'],
      creator: json['creator'],
      pollId: json['poll_id'],
      recipient: json['recipient'],
      answers: answers,
      
    );
  }

  Map<String, dynamic> toJson() => {
    'answered': answered,
    'creator': creator,
    'pollId': pollId,
    'recipient': recipient,
    'answers': answers
  };

  @override
  String toString() {
    return 'HistoricCreatedRecipient(answered: ${answered.toString()}, creator: $creator, pollId: $pollId, recipient: $recipient, answers: ${answers.toString()})';
  }
}

class HistoricCreatedPoll {
  final List<HistoricCreatedQuestion> historicCreatedQuestions;
  final List<HistoricCreatedRecipient> historicCreatedRecipients;

  const HistoricCreatedPoll({
    required this.historicCreatedQuestions,
    required this.historicCreatedRecipients
  });

  factory HistoricCreatedPoll.fromJson(Map<String, dynamic> json) {
    //final List<dynamic> choicesList = json['choices'];
    //final List<String> choices = List<String>.from(choicesList);

    return HistoricCreatedPoll(
      historicCreatedQuestions: json['historicCreatedQuestion'],
      historicCreatedRecipients: json['historicCreatedRecipient'],
    );
  }

  Map<String, dynamic> toJson() => {
    'historicCreatedQuestion': historicCreatedQuestions,
    'historicCreatedRecipient': historicCreatedRecipients
  };

  @override
  String toString() {
    return 'HistoricCreatedPoll(historicCreatedQuestion: ${historicCreatedQuestions.toString()}, historicCreatedRecipient: ${historicCreatedRecipients.toString()})';
  }

}