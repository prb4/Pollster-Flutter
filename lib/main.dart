import 'package:flutter/material.dart';
import 'package:pollster_flutter/creator.dart';
import 'package:pollster_flutter/login.dart';
import 'creator.dart';
//import 'responder.dart';

//void main() => runApp(const Creator());
void main() => runApp(LoginPage());


/*
class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        body:Center(
          child: ElevatedButton(
            child: const Text('Creator'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Creator()),
              );
            },
          )
        )
      )
    );
  }
}
*/
/*
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButtonExample(message: "Creator",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Creator())
                );              
              }),
            OutlinedButtonExample(message: "Responder", 
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Responder())
                );
              }),
          ]
        )
      )
    );
  }
}

class OutlinedButtonExample extends StatelessWidget {
  //const OutlinedButtonExample({super.key});
  final String message;
  final Function onTap;
  const OutlinedButtonExample({required this.message, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
      width: 300.0, 
      height: 50,
      child: GestureDetector(
      onTap: () {
        onTap();
      },
      child: Text(message),
      )
    )
    );
  }
}
*/