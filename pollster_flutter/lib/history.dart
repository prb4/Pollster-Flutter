import 'package:flutter/material.dart';
import 'models/poll.dart';
import 'http.dart';

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
              FutureReceivedPollMetadataBuilder(),
              FutureCreatedPollMetadataBuilder(),
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
          return ExpansionTileHeader(
            message: createdPollMetadata[i].title,
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
          return ExpansionTileHeader(
            message: receivedPollMetadata[i].title,
            );
        }
      
    );
  }
}
class ExpansionTileHeader extends StatelessWidget {
  final String message;
  const ExpansionTileHeader({super.key,required, required this.message});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('$message', style: const TextStyle(fontWeight: FontWeight.bold),),
      //subtitle: Text('Ch: ${accessPoint.channel}  |  ${accessPoint.last_update}'),
      //textColor: Colors.red,
      //leading: accessPoint.has_handshake ? const Icon(Icons.handshake, color: Colors.green,) : null,
      //children: <Widget>[
      //  ExpandedView(accessPoint: accessPoint),
      //],
    );
  }
}
