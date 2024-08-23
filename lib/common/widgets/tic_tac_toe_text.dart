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
        gradient: LinearGradient(
        colors: [
            const Color.fromARGB(255, 176, 216, 178).withOpacity(0.5), // Lighter green
            const Color.fromARGB(255, 201, 164, 209).withOpacity(0.5), // Lighter purple
            const Color.fromARGB(255, 245, 245, 220).withOpacity(0.5), // Cream
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,), borderRadius: BorderRadius.circular(48),),
      child: Text("Tic Tac Toe", style: TextStyle(color: DeviceUtils.isDarkMode(context) ? Colors.white : MyColors.dark, fontSize: Constants.extraMedium, fontWeight: FontWeight.bold),)
      );
  }
}