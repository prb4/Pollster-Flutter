import 'package:flutter/material.dart';
import 'models/poll.dart';
import 'http.dart';

class History extends StatelessWidget {
  late Future<HistoricMetadata> historicPolls;

  History(){
    historicPolls = fetchHistory();
    debugPrint("Historic Polls Created Polls Metadata: ${historicPolls.toString()}");
    
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:Text("test"),
      )
    );
  }
}