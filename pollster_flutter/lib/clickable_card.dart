import 'package:flutter/material.dart';
import 'package:pollster_flutter/history.dart';
import 'package:pollster_flutter/models/poll.dart';

class ClickableCreatedPollCard extends StatelessWidget {
  final PollMetadata createdPollMetadata;

  const ClickableCreatedPollCard({
    required this.createdPollMetadata,

  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //onPressed(index);
        debugPrint("[-] Card ");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatedPollItemDetailedView(createdPollItem: createdPollMetadata)
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(createdPollMetadata.title),
        ),
      ),
    );
  }
}

class ClickableReceivedPollCard extends StatelessWidget {
  final PollMetadata receivedPollMetadata;

  const ClickableReceivedPollCard({
    required this.receivedPollMetadata,

  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //onPressed(index);
      
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReceivedPollItemDetailedView(
              receivedPollItem: receivedPollMetadata
            )
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(receivedPollMetadata.title),
        ),
      ),
    );
  }
}

class ClickableOpenPollCard extends StatelessWidget {
  final PollMetadata openPollMetadata;

  const ClickableOpenPollCard({
    required this.openPollMetadata,

  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //onPressed(index);
        debugPrint("[-] Card ");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatedPollItemDetailedView(createdPollItem: openPollMetadata)
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(openPollMetadata.title),
        ),
      ),
    );
  }
}