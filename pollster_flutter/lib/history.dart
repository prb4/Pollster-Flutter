import 'package:flutter/material.dart';
import 'package:pollster_flutter/clickable_card.dart';
import 'models/poll.dart';
import 'http.dart';

class History extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
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
      future: fetchReceieved(),
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

class ReceivedPollItemDetailedView extends StatelessWidget {
  final PollMetadata receivedPollItem;
  const ReceivedPollItemDetailedView({super.key,required, required this.receivedPollItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(receivedPollItem.poll_id.toString()),
            Text(receivedPollItem.title),
          ],
        ),
      ),
    );
  }
}

class CreatedPollItemDetailedView extends StatelessWidget {
  final PollMetadata createdPollItem;
  late Future<Poll> poll;

  CreatedPollItemDetailedView({super.key,required, required this.createdPollItem}){
    debugPrint("[-] in CreatedPollItemDetailedView");
    poll = fetchPoll(createdPollItem.poll_id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Poll>(
      future: poll,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CreatedPollItemDisplay(pollDisplay: snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

class OpenPollItemDetailedView extends StatelessWidget {
  final PollMetadata pollItem;
  late Future<Poll> poll;

  OpenPollItemDetailedView({super.key,required, required this.pollItem}){
    debugPrint("[-] in CreatedPollItemDetailedView");
    poll = fetchPoll(pollItem.poll_id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Poll>(
      future: poll,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CreatedPollItemDisplay(pollDisplay: snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

class CreatedPollItemDisplay extends StatelessWidget {
  final Poll pollDisplay;

  const CreatedPollItemDisplay({super.key,required, required this.pollDisplay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column (
            children: [
              Text(pollDisplay.questions[0].toString())
            ],
          )),
    );
  }
}