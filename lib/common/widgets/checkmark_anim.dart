import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';

class CheckmarkAnim extends StatefulWidget {
  final String text;
  final int duration;
  const CheckmarkAnim({super.key, this.text = '', this.duration = 750});

  @override
  State<CheckmarkAnim> createState() => _CheckmarkAnimState();
}
class _CheckmarkAnimState extends State<CheckmarkAnim>  with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late bool canPop;


  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration));
    controller.addListener(listener);
    canPop = false;
    controller.forward();
  }

  listener() {
    if (!controller.isAnimating && controller.isCompleted) {
      setState(()=> canPop = true);
     Navigator.of(context).pop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: Dialog(
        child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/anims/checkmark.json',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                    controller: controller,
                    animate: true,
                  ),
                  MyText().medium(context, widget.text, color: Colors.white)
                ],
              ),
            ),
      ),
    );
  }
}