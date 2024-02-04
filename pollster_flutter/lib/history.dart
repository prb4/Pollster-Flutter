import 'package:flutter/material.dart';
import 'package:pollster_flutter/clickable_card.dart';
import 'models/poll.dart';
import 'http.dart';
import 'selectable_card.dart';

class History extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center (
        child: HistoricTab()
        //child: FutureReceivedPollMetadataBuilder()
        //child: FutureCreatedPollMetadataBuilder()
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
    return FutureBuilder<List<CreatedPollMetadata>> (
      future: fetchHistoricCreated(),
      builder: (context, snapshot) {
        
        if (snapshot.hasData) {
          debugPrint("snapshot has data");

          return CreatedPollMetadataExpansionTiles(createdPollMetadata: snapshot.data!);

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
    return FutureBuilder<List<ReceivedPollMetadata>> (
      future: fetchHistoricReceieved(),
      builder: (context, snapshot) {
        
        if (snapshot.hasData) {
          debugPrint("snapshot has data");
          return ReceivedPollMetadataExpansionTiles(receivedPollMetadata: snapshot.data!);

        } else if (snapshot.hasError) {
          return const Text("Snapshot error"); // TODO - improve
        }
        return const CircularProgressIndicator();
      }
    );
  }
}


class CreatedPollMetadataExpansionTiles extends StatelessWidget {
  final List<CreatedPollMetadata> createdPollMetadata;

  const CreatedPollMetadataExpansionTiles({required this.createdPollMetadata});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: createdPollMetadata.length,
        itemBuilder: (context, i) {
          return ClickableCreatedPollCard(
            createdPollMetadata: createdPollMetadata[i]
          );
        }
    );
  }
}



class ReceivedPollMetadataExpansionTiles extends StatelessWidget {
  final List<ReceivedPollMetadata> receivedPollMetadata;

  const ReceivedPollMetadataExpansionTiles({required this.receivedPollMetadata});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: receivedPollMetadata.length,
        itemBuilder: (context, i) {
          return ClickableReceivedPollCard(
            receivedPollMetadata: receivedPollMetadata[i]
          );
        }
    );
  }
}

class ReceivedPollItemDetailedView extends StatelessWidget {
  final ReceivedPollMetadata receivedPollItem;
  const ReceivedPollItemDetailedView({super.key,required, required this.receivedPollItem});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(receivedPollItem.poll_id),
          Text(receivedPollItem.title),
        ],
      ),
    );
  }
}

class CreatedPollItemDetailedView extends StatelessWidget {
  final CreatedPollMetadata createdPollItem;
  const CreatedPollItemDetailedView({super.key,required, required this.createdPollItem});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(createdPollItem.poll_id),
          Text(createdPollItem.title),
          Text(createdPollItem.created),
        ],
      ),
    );
  }
}