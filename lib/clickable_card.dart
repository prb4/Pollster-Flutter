import 'package:flutter/material.dart';

class ClickableCard extends StatelessWidget {
  final int index;
  final bool isSelected;
  final Function(int) onPressed;
  final String message;

  ClickableCard({
    required this.index,
    required this.isSelected,
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
        color: isSelected ? Colors.blue : Colors.white,
        child: ListTile(
          title: Text(message),
        ),
      ),
    );
  }
}