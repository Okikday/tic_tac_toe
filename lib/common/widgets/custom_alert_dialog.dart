import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final List<Widget> actions;
  const CustomAlertDialog({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [],
    );
  }
}