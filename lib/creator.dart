import 'package:flutter/material.dart';
import 'package:pollster_flutter/contacts_widget.dart';
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
                MaterialPageRoute(builder: (context) => BuildPoll()),
              );
            },
          )
        )
      )
    );
  }
}

class BuildPoll extends StatefulWidget {
  @override
  _BuildPollState createState() => _BuildPollState();
}

class _BuildPollState extends State<BuildPoll> {
  List<PollItem> pollItemList = [];
  List<TextEditingController> textControllers = [];
  String answer = "";
  List<String> additioanlAnswers = [];
  String question = "";
  List<Poll> polls = [];
  

  void clearTextFields() {
    for (var controller in textControllers){
      controller.clear();
    }
  }

  void saveAnswer(String input) {
    debugPrint("Saving answer: $input");
    answer = input;
  }

  void saveAdditionalAnswer(String input, int index){
    debugPrint("Saving additional answer: $input[$index]");
    if (index == additioanlAnswers.length){
      //Need to add an answer onto the list
      debugPrint("New additional answer: $input");
      additioanlAnswers.add(input);
    }else {
      //Interacting with an answer that's already accounted for
      debugPrint("Existing additional answer: $input");
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
    Poll poll = createPoll(question, currentAnswers);


    //Check if the poll has been added to the on-going list yet. 
    //TODO - def needs work.
    int i = 0;
    bool flag = false;
    for (i = 0; i < polls.length; i++){
      if (polls[i].question == question){ //TODO - probably need to do this by some created ID value
        flag = true;
      }
    }

    //Add the current / new poll to the existing list
    if (!flag){
      debugPrint("Poll is being saved");
      polls.add(poll);
    }
  }

  void clearPollItemList() {
    pollItemList = [];
    //debugPrint("Resizing textControllers: ${textControllers.length}");
    //textControllers = textControllers.sublist(0,2);
    //debugPrint("Resized textControllers: ${textControllers.length}");
  }

  List<String> joinAnswers() {
    debugPrint("join Answers");
    List<String> allAnswers = [];
    allAnswers.add(answer);

    debugPrint("Length of additional answers: ${additioanlAnswers.length}");
    debugPrint("Length of allAnswersanswers: ${allAnswers.length}");

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

  Poll createPoll(String pollQuestion, List<String> pollAnswers) {
    debugPrint("Creating poll with $pollQuestion, ${pollAnswers.toString()}");
    Poll tmpPoll = Poll(question: pollQuestion, answers: pollAnswers);
    return tmpPoll;
  }

  void initiateList() {
    debugPrint("Initiating list");
    setState(() {
      TextEditingController questionTextController = TextEditingController();
      pollItemList.add(PollItem(input: "Add question", isQuestion: true, isOptional: false, 
        onChanged: (String value) {
          debugPrint("Saving question");
          saveQuestion(value);
        },
        textController: questionTextController
        ));
        textControllers.add(questionTextController);

      TextEditingController answerTextController = TextEditingController();
      pollItemList.add(PollItem(input: "Add answer", isQuestion: false, isOptional: false, 
        onChanged: (String value) {
          debugPrint("Saving answer: $value");
          saveAnswer(value);
        },
        textController: answerTextController
        ));
        textControllers.add(answerTextController);
    });

  }

  void appendAnswerBox() {
    debugPrint("Appending answer box");
    setState(() {
      //This value isnt used in the additional answers, but its kept for easy of operability with the data structure given the question and first answer require a textController
      TextEditingController textController = TextEditingController();
      int index = additioanlAnswers.length;
      pollItemList.add(PollItem(input: "Add answer", isQuestion: false, isOptional: true, 
        onChanged: (String value) {
          debugPrint("Saving answer: $value");
          saveAdditionalAnswer(value, index);
        },
        textController: textController
        ));
        textControllers.add(textController);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pollItemList.isEmpty){
      //TODO - had to add this if statement as this function seemed to be called after the 'add answer' button was clicked
      initiateList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create poll",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            debugPrint("Implement go back"); //TODO
          }
        ),
      ),
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
                        clearPollItemList();

                        //Clear all text
                        //clearTextFields();

                        textControllers = [];

                        initiateList();

                      },
                    ),

                    ElevatedButton(
                      child: const Text('Next'),
                      onPressed: () {
                        debugPrint("Creator - question: $question, answers: $answer");

                        savePoll();

                        //Navigator.push(
                        //  context,
                        //  MaterialPageRoute(builder: (context) => ContactsWidget(question: question, answers: allAnswers)),
                        //);
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
          color: const Color(0xff000000),
          height: 1.5384615384615385,
          fontWeight: FontWeight.w600),
      textHeightBehavior:
          TextHeightBehavior(applyHeightToFirstAscent: false),
      textAlign: TextAlign.left,
    );
  }
}

