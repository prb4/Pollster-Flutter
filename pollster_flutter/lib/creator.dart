import 'package:flutter/material.dart';
import 'package:pollster_flutter/common.dart';
import 'package:pollster_flutter/contacts_widget.dart';
import 'package:pollster_flutter/crypto.dart';
import 'package:pollster_flutter/models/poll.dart';


class Creator extends StatelessWidget {
  const Creator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Center(
          child: ElevatedButton(
            child: const Text('Create new poll'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TitlePoll()),
              );
            },
          )
        )
      )
    );
  }
}

class TitlePoll extends StatelessWidget {
  String title = "";

  TitlePoll();

  void saveTitle(String input){
    debugPrint("saving title: $input");
    title = input;
  }

  @override
  Widget build(BuildContext context) {
  return Material(
    child: Scaffold (
      appBar: CommonAppBar(msg: "Create Poll"),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Title",
                ),
                onChanged: (String input){
                  saveTitle(input);
                },
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: OutlinedButton(
                onPressed: () {
                  debugPrint("On to questions button");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BuildPoll(title: title)),
                );
                },
                child: const Text("On to questions..."),
              )
            )
          ]
        )
      )
    )
  );
  }
}

class BuildPoll extends StatefulWidget {
  final String title;
  const BuildPoll({required this.title});
  @override
  _BuildPollState createState() => _BuildPollState(title: title);
}

class _BuildPollState extends State<BuildPoll> {
  List<PollItem> pollItemList = [];
  String answer = "";
  List<String> additioanlAnswers = [];
  String question = "";
  int question_id = -1;
  List<Question> polls = [];
  String title = "";
  List<TextEditingController> textControllers = [];

  _BuildPollState({required this.title}) {
    debugPrint("Title is $title");
  }

  void saveAnswer(String input) {
    debugPrint("Saving answer: $input");
    answer = input;
  }

  void saveAdditionalAnswer(String input, int index){
    debugPrint("Saving additional answer: $input");
    if (index == additioanlAnswers.length){
      //Need to add an answer onto the list
      additioanlAnswers.add(input);
    }else {
      //Interacting with an answer that's already accounted for
      additioanlAnswers[index] = input;
    }
  }

  void saveQuestion(String input) {
    debugPrint("Saving question: $input");
    question = input;
  }

  void savePoll() {
    debugPrint("Saving poll");

    //Save and join the answers that are currently on the screen and convert them into a poll
    List<String> currentAnswers = joinAnswers();
    Question poll = createVote(question, question_id, currentAnswers);


    //Check if the poll has been added to the on-going list yet. 
    //TODO - def needs work.
    int i = 0;
    bool flag = false;
    for (i = 0; i < polls.length; i++){
      if (polls[i].prompt == question){ //TODO - probably need to do this by some created ID value
        flag = true;
      }
    }

    //Add the current / new poll to the existing list
    if (!flag){
      debugPrint("Poll is being saved");
      polls.add(poll);
    }
  }

  void resetList() {
    debugPrint("Clearing poll item list");
    pollItemList = [];
    for (var textController in textControllers){
      textController.clear();
    }
  }

  List<String> joinAnswers() {
    debugPrint("join Answers");
    List<String> allAnswers = [];
    allAnswers.add(answer);

    debugPrint("Length of additional answers: ${additioanlAnswers.length}");
    debugPrint("Additional answers: ${additioanlAnswers.toString()}");
    debugPrint("Length of allAnswersanswers: ${allAnswers.length}");
    debugPrint("AllAnswers: ${allAnswers.toString()}");

    int i = 0;
    if (additioanlAnswers.isNotEmpty){
      int max = additioanlAnswers.length;
      for (i = 0; i < max; i++){
        if (additioanlAnswers[i].isNotEmpty){
          String item = additioanlAnswers[i];
          debugPrint("Adding $item");
          allAnswers.add(item);
        }
      }
    }

    return allAnswers;
  }

  Question createVote(String question, int question_id, List<String> answers) {
    debugPrint("Creating vote with $question, ${answers.toString()}");
    Question vote = Question(prompt: question, question_id: question_id, choices: answers);
    return vote;
  }

  void initiateList() {
    debugPrint("Initiating list");
    setState(() {
      TextEditingController questionTextController = TextEditingController();
      pollItemList.add(PollItem(input: "Add question", isQuestion: true, isOptional: false, 
        onChanged: (String value) {
          saveQuestion(value);
        },
        textController: questionTextController,
        ));
        textControllers.add(questionTextController);


      TextEditingController answerTextController = TextEditingController();
      pollItemList.add(PollItem(input: "Add answer", isQuestion: false, isOptional: false, 
        onChanged: (String value) {
          saveAnswer(value);
        },
        textController: answerTextController,
        ));
        textControllers.add(answerTextController);
    });
  }

  void removeItem(int index) {
    debugPrint("Removing answer at ${index.toString()}");
    setState(() {
      pollItemList.removeAt(index);  
    });
  }

  void appendAnswerBox() {
    debugPrint("Appending answer box");
    setState(() {
      TextEditingController textController = TextEditingController();
      //This value isnt used in the additional answers, but its kept for easy of operability with the data structure given the question and first answer require a textController
      int index = additioanlAnswers.length;
      pollItemList.add(PollItem(input: "Add answer", isQuestion: false, isOptional: true, 
        onChanged: (String value) {
          saveAdditionalAnswer(value, index);
        },
        textController: textController,
        onClickedSuffixIcon: () {
          int index = pollItemList.length - 1;
          debugPrint("Clicked on remove button: $index");
          removeItem(index);
        },
        ));

        textControllers.add(textController);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pollItemList.isEmpty){
      debugPrint("pollItemList is empty");
      //TODO - had to add this if statement as this function seemed to be called after the 'add answer' button was clicked
      initiateList();
    }

    return Scaffold(
      appBar: const CommonAppBar(msg: "Create Poll"),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  MaterialButton(
                      onPressed: () {
                          appendAnswerBox();
                      },
                      color: const Color(0xffd4d411),
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(3),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.add,
                        size: 32,
                      ),
                    ),
                ],
              ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  primary: false,
                  itemCount: pollItemList.length,
                  itemBuilder: (BuildContext context, int index) {
                    PollItem _pollItem = pollItemList[index];
                    debugPrint("pollItem - ${index} - ${pollItemList.length}");
                    debugPrint("pollItemList: ${pollItemList.toString()}");
                    return _pollItem;
                  },
                  separatorBuilder: (_, __) => const Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: const Text('New Question'),
                      onPressed: () {
                        debugPrint("New Question clicked");

                        //save what we currently have
                        savePoll();

                        //Go back to 1 question and 1 answer format - clear _pollItemList
                        resetList();

                        //Initiate list like a new screen
                        answer = "";
                        additioanlAnswers = [];
                        initiateList();

                      },
                    ),

                    ElevatedButton(
                      child: const Text('Next'),
                      onPressed: () {
                        debugPrint("Creator - question: $question, answers: $answer");

                        savePoll();

                        //final CreatedPoll createdPoll = CreatedPoll(title: title, poll_id: getUUID(), votes: polls);

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ContactsWidget(title: title, votes: polls))
                        );
                      },
                    )
                  ]
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class OutlinedButtonExample extends StatelessWidget {
  //const OutlinedButtonExample({super.key});
  final String message;
  const OutlinedButtonExample(this.message);

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20,
          color: Color(0xff000000),
          height: 1.5384615384615385,
          fontWeight: FontWeight.w600),
      textHeightBehavior:
          const TextHeightBehavior(applyHeightToFirstAscent: false),
      textAlign: TextAlign.left,
    );
  }
}

