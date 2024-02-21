import 'package:flutter/material.dart';
import 'package:pollster_flutter/clickable_card.dart';
import 'package:pollster_flutter/common.dart';
import 'package:pollster_flutter/responder.dart';
import 'models/poll.dart';
import 'http.dart';

class History extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Scaffold (
      body: Center (
        child: HistoricTab()
      )
    );
  }
}

class HistoricTab extends StatelessWidget {
  const HistoricTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: "Created Polls"),
                Tab(text: "Received Polls"),
              ],
            ),
            title: const Text('Historic Polls'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Handle back button press here
                debugPrint("Popping from Historic Polls");
                Navigator.pop(context);
              },
            ),
          ),
          body: TabBarView(
            children: [
              FutureCreatedPollMetadataBuilder(),
              FutureReceivedPollMetadataBuilder(),
            ],
          ),
        ),
      ),
    );
  }
}

class FutureReceivedPollMetadataBuilder extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PollMetadata>> (
      future: fetchHistoricalReceived(),
      builder: (context, snapshot) {
        
        if (snapshot.hasData) {
          debugPrint("snapshot has data");
          return ReceivedPollMetadataCardLayout(receivedPollMetadata: snapshot.data!);

        } else if (snapshot.hasError) {
          return const Text("Snapshot error"); // TODO - improve
        }
        return const CircularProgressIndicator();
      }
    );
  }
}

class ReceivedPollMetadataCardLayout extends StatelessWidget {
  final List<PollMetadata> receivedPollMetadata;

  const ReceivedPollMetadataCardLayout({required this.receivedPollMetadata});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: receivedPollMetadata.length,
        itemBuilder: (context, i) {
          return ClickablePollCard(
            pollMetadata: receivedPollMetadata[i], 
            pollMetadataType: "receivedPollMetadata");
        }
    );
  }
}

class ReceivedPollFutureBuilder extends StatelessWidget {
  final PollMetadata receivedPollMetadata;

  const ReceivedPollFutureBuilder({super.key,required, required this.receivedPollMetadata});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(msg: "Back to View Polls"), 
      body: FutureBuilder<AnsweredPoll> (
        future: fetchAnsweredPoll(receivedPollMetadata.poll_id),
        builder: (context, snapshot) {
          
          if (snapshot.hasData) {
            debugPrint("snapshot has data");
            return AnsweredPollLayout(answeredPoll: snapshot.data!);

          } else if (snapshot.hasError) {
            return const Text("Snapshot error in CreatedPollLayout"); // TODO - improve
          }
          return const CircularProgressIndicator();
        }
      ),
    );
  }
}

class AnsweredPollLayout extends StatelessWidget {
  final AnsweredPoll answeredPoll;
  AnsweredPollLayout({super.key, required this.answeredPoll});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView.separated(
                  itemCount: answeredPoll.answeredQuestions.length,
                  itemBuilder: (context, i) {
                    return AnsweredQuestionDisplay(answeredQuestion: answeredPoll.answeredQuestions[i]);
                  },
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 32.0),
                )
              ),
            ),
          ]
        )
      );
  }
}

class AnsweredQuestionDisplay extends StatelessWidget {
  final AnsweredQuestion answeredQuestion;
  const AnsweredQuestionDisplay({super.key, required this.answeredQuestion});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.blue,
      //padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
        border: Border.all(width: 8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
              PromptTextBox(answeredQuestion.prompt),
              ChoicesDisplay(choices: answeredQuestion.choices, answer: answeredQuestion.answer,),
        ],
      ),
    );
  }
}

class ChoicesDisplay extends StatelessWidget {
  final List<String> choices;
  final String answer;
  const ChoicesDisplay({super.key, required this.choices, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true, //TODO - this may not be the best solution, but it works
      itemCount: choices.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: choices[index] == answer ? Colors.yellow : Colors.white,
          child: Text(
            choices[index],
            textAlign: TextAlign.center,
          ),
        );
      }
    );
  }
}



class FutureCreatedPollMetadataBuilder extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PollMetadata>> (
      future: fetchCreated(),
      builder: (context, snapshot) {
        
        if (snapshot.hasData) {
          debugPrint("snapshot has data!");

          return CreatedPollMetadataCardLayout(createdPollMetadata: snapshot.data!);

        } else if (snapshot.hasError) {
          return const Text("Snapshot error"); // TODO - improve
        }
        return const CircularProgressIndicator();
      }
    );
  }
}

class CreatedPollMetadataCardLayout extends StatelessWidget {
  final List<PollMetadata> createdPollMetadata;

  const CreatedPollMetadataCardLayout({required this.createdPollMetadata});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: createdPollMetadata.length,
        itemBuilder: (context, i) {
          return ClickablePollCard(
            pollMetadata: createdPollMetadata[i], 
            pollMetadataType: "createdPollMetadata");
        }
    );
  }
}

class CreatedPollFutureBuilder extends StatelessWidget {
  final PollMetadata pollItem;

  const CreatedPollFutureBuilder({super.key, required this.pollItem});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(msg: "Back to View Polls"),
      body:FutureBuilder<HistoricCreatedPoll> (
        future: fetchCreatedPoll(pollItem.poll_id),
        builder: (context, snapshot) {
          
          if (snapshot.hasData) {
            debugPrint("snapshot has data");
            return CreatedPollDisplay(createdPoll: snapshot.data!);

          } else if (snapshot.hasError) {
            return const Text("Snapshot error in CreatedPollLayout"); // TODO - improve
          }
          return const CircularProgressIndicator();
        }
      ),
    );
  }
}

class CreatedPollDisplay extends StatelessWidget {
  final HistoricCreatedPoll createdPoll;
  const CreatedPollDisplay({super.key, required this.createdPoll});

  @override
  Widget build(BuildContext context) {
    return CommonScrollableList( 
      child: ListView.separated(
        //physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true, //TODO - this may not be the best solution, but it works
        itemCount: createdPoll.historicCreatedQuestions.length,
        itemBuilder: (BuildContext context, int index) {
          return CreatedPollItem(historicCreatedQuestion: createdPoll.historicCreatedQuestions[index], historicCreatedRecipients: createdPoll.historicCreatedRecipients);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}

class CreatedPollItem extends StatelessWidget {
  final HistoricCreatedQuestion historicCreatedQuestion;
  final List<HistoricCreatedRecipient> historicCreatedRecipients;
  const CreatedPollItem({super.key, required this.historicCreatedQuestion, required this.historicCreatedRecipients});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.blue,
      //padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
        border: Border.all(width: 8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
            PromptTextBox(historicCreatedQuestion.prompt),
            CreatedChoicesDisplay(choices: historicCreatedQuestion.choices, historicCreatedRecipients: historicCreatedRecipients, questionId: historicCreatedQuestion.questionId),
        ],
      ),
    );
  }
}

class CreatedChoicesDisplay extends StatelessWidget {
  final List<String> choices;
  final List<HistoricCreatedRecipient> historicCreatedRecipients;
  final String questionId;

  const CreatedChoicesDisplay({super.key, required this.choices, required this.historicCreatedRecipients, required this.questionId});

  double getPercentage(String choice, List<HistoricCreatedRecipient> recipients, String questionId) {
    int total = recipients.length;
    int selected = 0;

    for (HistoricCreatedRecipient hcr in recipients) {
      if (hcr.answers == []) {
        continue;
      } else {
        for (ReturnedAnswer answer in hcr.answers){
          if (answer.questionId.toString() == questionId) { //TODO - Once questionId type gets stabilized this can remove the toString() call
            if (answer.answer == choice) {
              selected = selected + 1;
            }
          }
        }
      }
    }
    debugPrint("Choice $choice is returning ${selected / total}");  

    return selected / total;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true, //TODO - this may not be the best solution, but it works
      itemCount: choices.length,  
      itemBuilder: (BuildContext context, int index) {
        return Center(
          //PercentageHighlightedCard(
          child: PercentageHighlightedCard(
            percentage: getPercentage(choices[index], historicCreatedRecipients, questionId),
            child: Card(
              child: SizedBox(
                //TODO - fix these hard coded numbers, if nothing else, fix with MediaQuery...
                width: 350,
                height: 20,
                  child: Center(child: Text(choices[index])),
    
              //child: Text(
              //  choices[index],
              //  textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }
    );
  }
}

class PercentageHighlightedCard extends StatelessWidget {
  final double percentage;
  final Widget child;
  
  const PercentageHighlightedCard({super.key, required this.percentage, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              //padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.5),
                borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(40), // Adjust the radius value as needed
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}





class CreatedQuestionDisplay extends StatelessWidget {
  const CreatedQuestionDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();

  }
}










class CreatedPollLayout extends StatelessWidget {
  final Poll poll;

  const CreatedPollLayout({super.key,required, required this.poll});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column (
            children: [
              Text(poll.questions[0].prompt)
            ],
          ),
        ),
    );
  }
}





class PollItemDetailedView extends StatelessWidget {
  final PollMetadata pollItem;
  final bool isOpenPoll;
  late Future<Poll> poll;

  PollItemDetailedView({super.key,required, required this.pollItem, required this.isOpenPoll}){
    debugPrint("[-] in OpenPollItemDetailedView");
    poll = fetchPoll(pollItem.poll_id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Poll>(
      future: poll,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //return OpenPollItemDisplay(poll: snapshot.data!);
          if (isOpenPoll == true){
            return PollLayout(poll: snapshot.data!);
          } else {
            return CreatedPollLayout(poll: snapshot.data!);
          }
          
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}