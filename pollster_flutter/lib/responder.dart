import 'package:flutter/material.dart';
import 'package:pollster_flutter/contacts_widget.dart';
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
  late Future<List<ReceivedPolls>> futurePolls;

  @override
  void initState() {
    super.initState();
    
    futurePolls = fetchPolls();
    debugPrint("Have futureQuestion");

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Open polls",
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: Center (
          child: FutureBuilder<List<ReceivedPolls>> (
            future: futurePolls,
            builder: (context, snapshot) {
              
              if (snapshot.hasData) {
                debugPrint("snapshot has data");

                return ChoosePoll(receivedPolls: snapshot.data!);

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

class ChoosePoll extends StatelessWidget {
  final List<ReceivedPolls> receivedPolls;

  const ChoosePoll({required this.receivedPolls});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: receivedPolls.length,
        itemBuilder: (context, i) {
          return MyClickableChip(
            
            label: receivedPolls[i].title,
            onTap: () {
              debugPrint("Clicked poll: ${receivedPolls[i].title}");
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => PollLayout(receivedPoll: receivedPolls[i]))
              );
              
            });
        }
      
    );
  }
}

class PollLayout extends StatelessWidget {

  final ReceivedPolls receivedPoll;

  const PollLayout({
    required this.receivedPoll,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            receivedPoll.title,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
              itemCount: receivedPoll.polls.length,
              itemBuilder: (context, i) {
                return _PollLayout(question: receivedPoll.polls[i].question!, answers: receivedPoll.polls[i].answers!);
              })
            )
          ]
        )
      )
    );
    

  }
}

class _PollLayout extends StatelessWidget {

  final String question;
  final List<String> answers;

  const _PollLayout({
    required this.question,
    required this.answers,
  });
  
  @override
  Widget build(BuildContext context) {
    debugPrint("PollLayout");  
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