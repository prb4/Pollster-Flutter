import 'package:flutter/material.dart';
import 'models/poll.dart';
import 'http.dart';

class History extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center (
        child: FutureReceivedPollMetadataBuilder()
        //child: FutureCreatedPollMetadataBuilder()
      )
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

          //return ChoosePoll(receivedPolls: snapshot.data!);

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

          //return ChoosePoll(receivedPolls: snapshot.data!);

        } else if (snapshot.hasError) {
          return const Text("Snapshot error"); // TODO - improve
        }
        return const CircularProgressIndicator();
      }
    );
  }
}