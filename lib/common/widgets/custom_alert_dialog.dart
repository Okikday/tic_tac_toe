import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/colors.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  const CustomAlertDialog({super.key, required this.actions, required this.title});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: const Color.fromARGB(255, 206, 137, 137),
        title: MyText().medium(context, title),
        actions: actions,
      ),
    );
  }
}