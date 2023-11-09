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
  List<Widget> textFields = [];
  List<PollItem> pollItemList = [];
  List<String> answers = [];
  String question = "";
  List<Poll> polls = [];
  final _textController = TextEditingController();

  void clearTextField() {
    _textController.clear();
  }

  void saveAnswer(String input) {
    debugPrint("Saving answer: $input");
    answers.add(input);
  }

  void saveQuestion(String input) {
    debugPrint("Saving question: $input");
    question = input;
  }

  void savePoll(Poll poll) {
    debugPrint("Saving poll: ${poll.question}");

    int i = 0;
    bool flag = false;
    for (i = 0; i < polls.length; i++){
      if (polls[i].question == question){ //TODO - probably need to do this by some created ID value
        flag = true;
      }
    }
    if (!flag){
      debugPrint("Poll is being saved");
      polls.add(poll);
    }
  }

  void clearPollItemList() {
    pollItemList = [];
  }

  Poll createPoll(String pollQuestion, List<String> pollAnswers) {
    debugPrint("Creating poll with $pollQuestion, ${pollAnswers.toString()}");
    Poll tmpPoll = Poll(question: pollQuestion, answers: pollAnswers);
    return tmpPoll;
  }

  @override
  Widget build(BuildContext context) {
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
                          setState(() {
                            debugPrint("Adding pollItem");
                            pollItemList.add(PollItem(input: "Add optional answer", isQuestion: false, isOptional: true,
                              onSubmitted: (String value) {
                                saveAnswer(value);
                              },
                              textController: _textController
                              ));
                          });
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
                PollItem(input: "Add question", isQuestion: true, isOptional: false, 
                  onSubmitted: (String value) {
                    debugPrint("Saving question");
                    saveQuestion(value);
                  },
                  textController: _textController),
                PollItem(input: "Add answer", isQuestion: false, isOptional: false, 
                  onSubmitted: (String value) {
                    debugPrint("Saving answer: $value");
                    answers.add(value);
                  },
                  textController: _textController,),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
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
                        Poll newPoll = createPoll(question, answers);
                        savePoll(newPoll);

                        //Go back to 1 question and 1 answer format - clear _pollItemList
                        clearPollItemList();

                        //Clear all text

                      },
                    ),

                    ElevatedButton(
                      child: const Text('Next'),
                      onPressed: () {
                        debugPrint("Creator - question: $question, answers: ${answers.toString()}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ContactsWidget(question: question, answers: answers)),
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
          color: const Color(0xff000000),
          height: 1.5384615384615385,
          fontWeight: FontWeight.w600),
      textHeightBehavior:
          TextHeightBehavior(applyHeightToFirstAscent: false),
      textAlign: TextAlign.left,
    );
  }
}

