import 'package:flutter/material.dart';
import 'http.dart';
import 'clickable_card.dart';
import 'package:pollster_flutter/models/poll.dart';

class Responder extends StatefulWidget {
  const Responder({super.key});

    @override
  State<Responder> createState() => _ResponderState();
}

class _ResponderState extends State<Responder> {
  //Class that actually fetches the data
  late Future<List<Poll>> futurePolls;

  @override
  void initState() {
    super.initState();
    
    futurePolls = fetchPolls();
    Poll poll = Poll(question: "Test question", answers: ["Answer1"]);
    debugPrint("Have futureQuestion");

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center (
          child: FutureBuilder<List<Poll>> (
            future: futurePolls,
            builder: (context, snapshot) {
              
              if (snapshot.hasData) {
                debugPrint("snapshot has data");

                List<Poll> polls = [];
                for (var item in snapshot.data!){
                  debugPrint(item.toString());
                  Poll poll = Poll(question: item.question, answers: item.answers);
                  polls.add(poll);
                }

                return QuestionAnswerLayout(
                  question: polls[0].question!, 
                  answers: polls[0].answers!);

              } else if (snapshot.hasError) {
                return const Text("Snapshot error"); // TODO - improve
              }
              return const CircularProgressIndicator();
            }
          )
        )
      )
    );
  }
}

class QuestionAnswerLayout extends StatelessWidget {

  final String question;
  final List<String> answers;

  const QuestionAnswerLayout({
    required this.question,
    required this.answers,
  });
  
  @override
  Widget build(BuildContext context) {
    debugPrint("QuestionAnswerLayout");  
    return Align(
      alignment: Alignment.bottomCenter,
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                  QuestionTextBox(question),
                  AnswerList(answers),
            ],
        ),
      )
    );
  }
}

class AnswerList extends StatefulWidget {
  final List<String> answers;

  const AnswerList(this.answers);

  State <AnswerList> createState() => _AnswerListState(this.answers);

}

class _AnswerListState extends State<AnswerList> {
  final List<String> answers;
  int selectedCardIndex = -1;
  _AnswerListState(this.answers);

  void selectCard(int index) {
    setState(() {
      selectedCardIndex = index;
    });
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
          shrinkWrap: true, //TODO - this may not be the best solution, but it works
          itemCount: answers.length,
          itemBuilder: (BuildContext context, int index) {
            return ClickableCard(
              index: index,
              isSelected: selectedCardIndex == index,
              onPressed: selectCard,
              message: answers[index],
            );
          }
        ),
        SizedBox(
          width: 300.0, 
          height: 50,
          child: OutlinedButton(
            onPressed:() {
              debugPrint("Submit click: ${getSelectedCard()}");
              Map<String, dynamic> data = {
                "answer": answers[getSelectedCard()]
              };
              sendPostRequest(data, "submit/answer");
            },
            child: const Text("Submit"),
          )
        )
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

class OutlinedButtonExample extends StatelessWidget {
  //const OutlinedButtonExample({super.key});
  final String message;
  const OutlinedButtonExample(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
      width: 300.0, 
      height: 50,
      child: OutlinedButton(
      onPressed:() {
        debugPrint("Received click");
      },
      child: Text(message),
      )
    )
    );
  }
}