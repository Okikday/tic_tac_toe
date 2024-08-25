import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';

class ProgressTrackboard extends StatelessWidget {
  const ProgressTrackboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 245, 220).withOpacity(0.5),
        borderRadius: BorderRadius.circular(48)

      ),
      child: MyText().big(context, "Player 2 is playing..."),
    );
  }
}