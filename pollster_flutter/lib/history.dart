import 'package:flutter/material.dart';
import 'package:pollster_flutter/clickable_card.dart';
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
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Handle back button press here
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

class ReceivedPollItemDetailedView extends StatelessWidget {
  final PollMetadata receivedPollMetadata;

  const ReceivedPollItemDetailedView({super.key,required, required this.receivedPollMetadata});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AnsweredPoll> (
      future: fetchAnsweredPoll(receivedPollMetadata.poll_id),
      builder: (context, snapshot) {
        
        if (snapshot.hasData) {
          debugPrint("snapshot has data");
          return AnsweredPollDisplayList(answeredPoll: snapshot.data!);

        } else if (snapshot.hasError) {
          return const Text("Snapshot error in CreatedPollLayout"); // TODO - improve
        }
        return const CircularProgressIndicator();
      }
    );
  }
}

class AnsweredPollDisplayList extends StatelessWidget {
  final AnsweredPoll answeredPoll;
  AnsweredPollDisplayList({super.key, required this.answeredPoll});

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

class PromptDisplay extends StatelessWidget {
  final String msg;
  const PromptDisplay({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Text(msg);
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
          )),
    );
  }
}