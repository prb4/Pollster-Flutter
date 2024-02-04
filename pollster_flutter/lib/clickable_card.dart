import 'package:flutter/material.dart';

class ClickableCard extends StatelessWidget {
  final int index;
  final Function(int) onPressed;
  final String message;

  const ClickableCard({
    required this.index,
    required this.onPressed,
    required this.message,

  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed(index);
        debugPrint("${index.toString()} clicked");
      },
      child: Card(
        child: ListTile(
          title: Text(message),
        ),
      ),
    );
  }
}