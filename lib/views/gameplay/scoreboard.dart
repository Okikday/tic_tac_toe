import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 64,
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MyText().big(context, "S2"),
          VerticalDivider(width: 8,),
          MyText().big(context, "S2")
        ],
      ),
    );
  }
}