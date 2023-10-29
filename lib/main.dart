import 'package:flutter/material.dart';
import 'http.dart';

/*
void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: QuestionAnswerLayout(), //With no const MaterialApp
        )
      )
    );
  }
}
*/

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

    @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Class that actually fetches the data
  late Future<Question> futureQuestion;

  @override
  void initState() {
    super.initState();
    
    futureQuestion = fetchQuestion();
    debugPrint("Have futureQuestion");

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center (
          child: FutureBuilder<Question> (
            future: futureQuestion,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                debugPrint("snapshot has data");
                //return Text(snapshot.data!.question);
                return QuestionAnswerLayout(
                  question: snapshot.data!.question, 
                  answers: snapshot.data!.answers);
              } else if (snapshot.hasError) {
                return const Text("Snapshot error"); // TODO - improve
              }
              return const CircularProgressIndicator();
            }
          )
        )
      )
    );
  }
}

class QuestionAnswerLayout extends StatelessWidget {

  final String question;
  final List<String> answers;

  const QuestionAnswerLayout({
    required this.question,
    required this.answers,
  });
  
  @override
  Widget build(BuildContext context) {
    debugPrint("QuestionAnswerLayout");  
    return Align(
      alignment: Alignment.bottomCenter,
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                  QuestionTextBox(question),
                  AnswerList(answers),
            ],
        ),
      )
    );
  }
}

class AnswerList extends StatefulWidget {
  final List<String> answers;

  const AnswerList(this.answers);

  State <AnswerList> createState() => _AnswerListState(this.answers);
/*
  @override
  Widget build(BuildContext context) {
    debugPrint("in AnswerList");
    

    return Column(
      children: <Widget>[
        Card(child: ListTile(title: Text(answers[0]))),
        Card(child: ListTile(title: Text(answers[1]))),
        Card(child: ListTile(title: Text(answers[2]))),
        Card(child: ListTile(title: Text(answers[3]))),
      ]
    );
    
  }
  */
}

class _AnswerListState extends State<AnswerList> {
  final List<String> answers;
  _AnswerListState(this.answers);

  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    debugPrint("in _AnswerListState");

    return ListView.builder(
      shrinkWrap: true, //TODO - this may not be the best solution, but it works
      itemCount: answers.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {
              debugPrint('Card ${index.toString()} tapped');
            },
            child: ListTile(
              title: Text(answers[index])
            )
          ),
        );  
      }
    );
  }
}

class QuestionTextBox extends StatelessWidget {
  final String msg;
  const QuestionTextBox(this.msg);

  @override
  Widget build(BuildContext context) {
    return Text(msg,
                style: const TextStyle(fontSize: 20)
              );
  }
}

class OutlinedButtonExample extends StatelessWidget {
  //const OutlinedButtonExample({super.key});
  final String message;
  const OutlinedButtonExample(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
      width: 300.0, 
      height: 50,
      child: OutlinedButton(
      onPressed:() {
        debugPrint("Received click");
      },
      child: Text(message),
      )
    )
    );
  }
}