import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String msg;
  const CommonAppBar({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
  return Material(
    child: Scaffold (
      appBar: AppBar(
          title: Text(
            msg,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.normal,
            ),
          ),
          leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          }
          ),
        ),
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
}