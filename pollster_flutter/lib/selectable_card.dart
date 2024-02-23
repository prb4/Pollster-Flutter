import 'package:flutter/material.dart';

class SelectableCard extends StatelessWidget {
  final int index;
  final bool isSelected;
  final Function(int) onPressed;
  final String message;

  const SelectableCard({
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
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.black, //<-- SEE HERE
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: isSelected ? Colors.blue : Colors.white,
        child: ListTile(
          title: Text(message),
        ),
      ),
    );
  }
}