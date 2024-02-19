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
            style: Theme.of(context).textTheme.headlineLarge
          ),
          leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            debugPrint("Popping off: $msg");
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

class CommonScrollableList extends StatelessWidget {
  final Widget child;
  const CommonScrollableList({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: child
          ),
        ]
      ),
    );
  }
}

class CommonUnscrollableList extends StatelessWidget {
  const CommonUnscrollableList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}