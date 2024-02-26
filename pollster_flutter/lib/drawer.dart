import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    debugPrint("Building out drawer menu");
    return Drawer( 
        child: ListView(
          children: const [
            DrawerHeader(
              child: Text("Drawer Header 1.0")
            ),
            ListTile(
              title: Text("TODO - Feedback")
            ),
            ListTile(
              title: Text("TODO - Logout")
            )
          ]
        )
    );
  }
}