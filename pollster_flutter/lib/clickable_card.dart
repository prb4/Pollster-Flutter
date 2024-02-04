import 'package:flutter/material.dart';
import 'package:pollster_flutter/history.dart';
import 'package:pollster_flutter/models/poll.dart';

class ClickableCreatedPollCard extends StatelessWidget {
  final CreatedPollMetadata createdPollMetadata;

  const ClickableCreatedPollCard({
    required this.createdPollMetadata,

  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //onPressed(index);
      
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
  final ReceivedPollMetadata receivedPollMetadata;

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