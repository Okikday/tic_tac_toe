import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/colors.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';

class Scoreboard extends StatelessWidget {
  final String playingWith;
  final int score1;
  final int score2;
  const Scoreboard({
    super.key,
    this.playingWith = "person",
    this.score1 = 0,
    this.score2 = 0,
    
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 90,
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: MyColors.bitterSweet,
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 176, 216, 178)
                .withOpacity(0.5), // Lighter green
            const Color.fromARGB(255, 201, 164, 209)
                .withOpacity(0.5), // Lighter purple
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  Constants.whiteSpaceHorizontal(12),
                  MyText().big(context, score1.toString()),
                ],
              ),
              Constants.whiteSpaceVertical(8),
              MyText().small(context, "You", adjust: -2),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  MyText().big(context, score2.toString()),
                  Constants.whiteSpaceHorizontal(24),
                  const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ],
              ),
              Constants.whiteSpaceVertical(8),
              MyText().small(context, playingWith, adjust: -2),
            ],
          ),
        ],
      ),
    );
  }
}
