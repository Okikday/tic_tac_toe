import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/colors.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class ProgressTrackboard extends StatefulWidget {
  final String textValue;
  const ProgressTrackboard({super.key, this.textValue = "Well"});

  @override
  State<ProgressTrackboard> createState() => _ProgressTrackboardState();
}

class _ProgressTrackboardState extends State<ProgressTrackboard> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> fadeVal;
  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    fadeVal = Tween<double>(begin: 0, end: 1).animate(controller);
    controller.forward();
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeVal,
      child: Container(
        width: 300,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: DeviceUtils.isDarkMode(context) ? const Color.fromARGB(255, 201, 164, 209).withOpacity(0.5) : MyColors.dark.withOpacity(0.75),
          borderRadius: BorderRadius.circular(48)

        ),
        child: MyText().medium(context, widget.textValue, invertColor: true),
      ),
    );
  }
}