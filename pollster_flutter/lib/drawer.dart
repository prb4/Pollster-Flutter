import 'package:flutter/material.dart';
import 'package:pollster_flutter/http.dart';
import 'package:pollster_flutter/user_session.dart';

class DrawerMenu extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    debugPrint("Building out drawer menu");
    return Drawer( 
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text("Drawer Header 1.0")
            ),
            ListTile(
              title: const Text("TODO - Feedback"),
              onTap: () {
                debugPrint("Moving to feedback view");
              },
                
            ),
            ListTile(
              title: const Text("Logout"),
              onTap: () async {
                debugPrint("Logging out of ${UserSession().username}");
                Map<String, dynamic> data = {'user_id' : UserSession().userId.toString()};
                final respone = await sendPostRequest(data, "/logout");
                if (respone['message'] == "OK") {
                  //Navigate back to the login screen
                  //Navigator.popUntil(context, ModalRoute.withName('/login'));
                  //Navigator.pushNamed(context, '/login');
                  Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                } else {
                  debugPrint("[!] Error logging out of user session: userId: ${UserSession().userId.toString()}");
                }
              },
            )
          ]
        )
    );
  }
}