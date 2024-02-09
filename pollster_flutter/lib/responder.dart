import 'package:flutter/material.dart';
import 'package:pollster_flutter/common.dart';
import 'package:pollster_flutter/contacts_widget.dart';
import 'package:pollster_flutter/user_session.dart';
import 'http.dart';
import 'selectable_card.dart';
import 'package:pollster_flutter/models/poll.dart';
import 'crypto.dart';
import 'package:pollster_flutter/clickable_card.dart';
class Responder extends StatefulWidget {
  const Responder({super.key});

    @override
  State<Responder> createState() => _ResponderState();
}

class OpenPolls extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: const CommonAppBar(msg: "Create Poll"),
      body: FutureBuilder<List<PollMetadata>> (
        future: fetchOpen(),
        builder: (context, snapshot) {
          
          if (snapshot.hasData) {
            debugPrint("snapshot has data!");

            return OpenPollMetadataCardLayout(openPollMetadata: snapshot.data!);

          } else if (snapshot.hasError) {
            return const Text("Snapshot error"); // TODO - improve
          }
          return const CircularProgressIndicator();
        }
      )
    );
  }
}

class OpenPollMetadataCardLayout extends StatelessWidget {
  final List<PollMetadata> openPollMetadata;

  const OpenPollMetadataCardLayout({required this.openPollMetadata});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: openPollMetadata.length,
        itemBuilder: (context, i) {
          return ClickablePollCard(
            pollMetadata: openPollMetadata[i], 
            pollMetadataType: "openPollMetadata"
          );
        }
    );
  }
}

class _ResponderState extends State<Responder> {
  //Class that actually fetches the data
  late Future<List<ReceivedVotes>> futurePolls;


  @override
  void initState() {
    super.initState();
    
    futurePolls = fetchPolls();
    debugPrint("Have futureQuestion");

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(msg: "Open Polls"),
      body: Center (
        child: FutureBuilder<List<ReceivedVotes>> (
          future: futurePolls,
          builder: (context, snapshot) {
            
            if (snapshot.hasData) {
              debugPrint("snapshot has data");

              //return ChoosePoll(receivedPolls: snapshot.data!);

            } else if (snapshot.hasError) {
              return const Text("Snapshot error"); // TODO - improve
            }
            return const CircularProgressIndicator();
          }
        )
      )
    );
  }
}

class PollLayout extends StatelessWidget {
  final Poll poll;
  //late List<Answer> selectedAnswers;

  const PollLayout ({
    required this.poll,
  });

  List<Answer> updateSelectedAnswers(selectedAnswers, index, question_id, answer){
    debugPrint("Current selectedAnswer: ${selectedAnswers.toString()}");
    debugPrint("index: ${index.toString()}, question_id: ${question_id.toString()}, answer: ${answer.toString()}");

    selectedAnswers[index].question_id = question_id;
    selectedAnswers[index].answer = answer;
    
    debugPrint("Updated selectedAnswer: ${selectedAnswers.toString()}");
    return selectedAnswers;
}

List<Map<String, dynamic>> convertSelectedAnswersListToMap(List<Answer> selectedAnswers){
  
  List<Map<String, dynamic>> data = [];
  
  //TODO - this breaks if not all questions are answered

  for (Answer answer in selectedAnswers) {
    Map<String, dynamic> result = {};
    result['question_id'] = answer.question_id;
    result['answer'] = answer.answer;

    data.add(result);
  }

  debugPrint("Returning from convertSelectedAnswersListToMap: ${data.toString()}");
  return data;
}

Map<String, dynamic> prepAnswerSubmit(List<Answer> selectedAnswer) {
  Map<String, dynamic> data = {};

  data['answers'] = convertSelectedAnswersListToMap(selectedAnswer);  
  data['username'] = UserSession().username;
  data['user_id'] = UserSession().userId;
  data['poll_id'] = poll.pollMetadata.poll_id;

  debugPrint("[-] Sending ${data.toString()}");

  return data;
}
  
  @override
  Widget build(BuildContext context) {
    List<Answer> selectedAnswers = List.generate(poll.questions.length, (index) => Answer(poll_id: poll.pollMetadata.poll_id));
    return Scaffold(
      appBar: CommonAppBar(msg: poll.pollMetadata.title),
      body: Center(
        child: Column(
          children: [
            Expanded(
              
              child: ListView.builder(
                itemCount: poll.questions.length,
                itemBuilder: (context, i) {
                  return _PollLayout(
                    question: poll.questions[i].prompt,
                    choices: poll.questions[i].choices,
                    onAnswerSelected: (int index) {
                      updateSelectedAnswers(selectedAnswers, i, poll.questions[i].question_id, poll.questions[i].choices[index]);
                      //selectedAnswers[i] = index;
                      //debugPrint("Current selected answers: ${selectedAnswers.toString()}");
                    });
              })
            ),
            SubmitButton(message: "Submit", onPressed: () {
                debugPrint("Submit click, final answers: ${selectedAnswers.toString()}");
                //Map<String, dynamic> data = {
                //  "answer": answers[getSelectedCard()]
                //};

                sendPostRequest(prepAnswerSubmit(selectedAnswers), "/answer");
                
                //Navigator.pop(context); //TODO - when this is called, need to re-call the previous screen so the updated list loads (ie: without the just answered poll)
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              }),
          ]
        )
      )
    );
  }
}

class _PollLayout extends StatelessWidget {

  final String question;
  final List<String> choices;
  final Function(int) onAnswerSelected;

  const _PollLayout({
    required this.question,
    required this.choices,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("PollLayout");
    return Container(
      //color: Colors.blue,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
        border: Border.all(width: 8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
              QuestionTextBox(question),
              AnswerList(
                answers: choices, 
                onAnswerSelected: (index) => onAnswerSelected(index)),
        ],
      ),
    );
  }
}

class AnswerList extends StatefulWidget {
  final List<String> answers;
  final Function(int) onAnswerSelected;

  //const AnswerList(this.answers);
  const AnswerList({
    required this.answers,
    required this.onAnswerSelected});

  State <AnswerList> createState() => _AnswerListState(answers: answers, onAnswerSelected: onAnswerSelected);

}

class _AnswerListState extends State<AnswerList> {
  final List<String> answers;
  final Function(int) onAnswerSelected;
  int selectedCardIndex = -1;
  //_AnswerListState(this.answers);
  _AnswerListState({
    required this.answers,
    required this.onAnswerSelected});

  void selectCard(int index) {
    setState(() {
      selectedCardIndex = index;
    });
    onAnswerSelected(index);
  }

  int getSelectedCard() {
    return selectedCardIndex;
  }

  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    debugPrint("in _AnswerListState");

    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true, //TODO - this may not be the best solution, but it works
          itemCount: answers.length,
          itemBuilder: (BuildContext context, int index) {
            return SelectableCard(
              index: index,
              isSelected: selectedCardIndex == index,
              onPressed: selectCard,
              message: answers[index],
            );
          }
        ),
      ]
    );
  }
}

class QuestionTextBox extends StatelessWidget {
  final String msg;
  const QuestionTextBox(this.msg);

  @override
  Widget build(BuildContext context) {
    return Text(msg,
      style: const TextStyle(fontSize: 20)
    );
  }
}

class SubmitButton extends StatelessWidget {
  //const OutlinedButtonExample({super.key});
  final String message;
  final Function onPressed;
  const SubmitButton({required this.message, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0, 
      height: 50,
      child: OutlinedButton(
      onPressed:() {
        debugPrint("Received click");
        onPressed();
      },
      child: Text(message),
      )
    );
  }
}