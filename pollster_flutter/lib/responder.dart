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
    return Scaffold(
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

  List<SelectedAnswer> updateSelectedAnswers(selectedAnswers, index, question, answer){
    debugPrint("Current selectedAnswer: ${selectedAnswers.toString()}");

    selectedAnswers[index].question = question;
    selectedAnswers[index].selectedAnswer = answer;
    
    debugPrint("Updated selectedAnswer: ${selectedAnswers.toString()}");
    return selectedAnswers;
}

Map<String, dynamic> convertSelectedAnswersListToMap(List<SelectedAnswer> selectedAnswers){
  Map<String, dynamic> result = {};
  //TODO - this breaks if not all questions are answered

  for (SelectedAnswer answer in selectedAnswers) {
    result[answer.question!] = answer.selectedAnswer;
  }

  debugPrint("Returning from convertSelectedAnswersListToMap: ${result.toString()}");
  return result;
}
  
  @override
  Widget build(BuildContext context) {
    List<SelectedAnswer> selectedAnswers = List.generate(receivedPoll.polls.length, (index) => SelectedAnswer());
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
                  return _PollLayout(
                    question: receivedPoll.polls[i].question!,
                    answers: receivedPoll.polls[i].answers!,
                    onAnswerSelected: (int index) {
                      updateSelectedAnswers(selectedAnswers, i, receivedPoll.polls[i].question, receivedPoll.polls[i].answers![index]);
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
                sendPostRequest(convertSelectedAnswersListToMap(selectedAnswers), "submit/answer");
                Navigator.pop(context); //TODO - when this is called, need to re-call the previous screen so the updated list loads (ie: without the just answered poll)
              }),
          ]
        )
      )
    );
    

  }
}

class _PollLayout extends StatelessWidget {

  final String question;
  final List<String> answers;
  final Function(int) onAnswerSelected;

  const _PollLayout({
    required this.question,
    required this.answers,
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
                answers: answers, 
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
            return ClickableCard(
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