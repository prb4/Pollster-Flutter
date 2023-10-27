import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [

                SafeArea(child: MyTextField("This will be a question")),
                OutlinedButtonExample("Answer #1"),
                OutlinedButtonExample("Answer #2"),
                OutlinedButtonExample("Answer #3"),
                OutlinedButtonExample("Answer #4")

              ],
            )
          ),
        )
      )
    );
  }
}

class MyTextField extends StatelessWidget {
  //const MyTextField({super.key});
  final String msg;
  const MyTextField(this.msg);

  @override
  Widget build(BuildContext context) {
    return Text(msg);
  }
}

class OutlinedButtonExample extends StatelessWidget {
  //const OutlinedButtonExample({super.key});
  final String message;
  const OutlinedButtonExample(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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