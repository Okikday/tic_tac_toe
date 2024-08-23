import 'package:flutter/material.dart';

class BackButton1 extends StatelessWidget {
  final Color color;
  const BackButton1({super.key, this.color = const Color.fromARGB(205, 221, 221, 221)});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(CircleBorder()),
        backgroundColor: WidgetStatePropertyAll(color),
      ),
      icon: const Icon(
        Icons.arrow_back_rounded,
        size: 24,
        color: Colors.black,
      ),
      padding: EdgeInsets.all(6),
    );
  }
}
