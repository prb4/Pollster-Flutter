import 'package:flutter/material.dart';
import 'package:pollster_flutter/history.dart';
import 'package:pollster_flutter/models/poll.dart';

class ClickablePollCard extends StatelessWidget {
  final PollMetadata pollMetadata;
  final String pollMetadataType;
  late MaterialPageRoute materialPageRoute;

  ClickablePollCard({
    required this.pollMetadata,
    required this.pollMetadataType
  }){
    if (pollMetadataType == 'createdPollMetadata'){
      materialPageRoute = MaterialPageRoute(
            builder: (context) => PollItemDetailedView(pollItem: pollMetadata, isOpenPoll: false,)
          );
    } else if (pollMetadataType == 'receivedPollMetadata') {
      materialPageRoute = MaterialPageRoute(
            builder: (context) => ReceivedPollItemDetailedView(receivedPollMetadata: pollMetadata)
          );
    } else if (pollMetadataType == 'openPollMetadata') {
      materialPageRoute = MaterialPageRoute(
            builder: (context) => PollItemDetailedView(pollItem: pollMetadata, isOpenPoll: true,)
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //onPressed(index);
        debugPrint("[-] Card ");
        Navigator.push(
          context,
          materialPageRoute,
        );
      },
      child: Card(
        child: ListTile(
          title: Text(pollMetadata.title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}