import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/colors.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class TicTacToeText extends StatelessWidget {
  const TicTacToeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 4, 8,4),
      decoration: BoxDecoration(
        
         borderRadius: BorderRadius.circular(48),),
      child: Text("Tic Tac Toe", style: TextStyle(color: DeviceUtils.isDarkMode(context) ? Colors.white : MyColors.dark, fontSize: Constants.extraMedium, fontWeight: FontWeight.bold),)
      );
  }
}