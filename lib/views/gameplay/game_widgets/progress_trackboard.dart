import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/colors.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class ProgressTrackboard extends StatefulWidget {
  final String textValue;
  const ProgressTrackboard({super.key, this.textValue = "Progress Trackboard"});

  @override
  State<ProgressTrackboard> createState() => _ProgressTrackboardState();
}

class _ProgressTrackboardState extends State<ProgressTrackboard>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> val;

  @override
  void initState() {
    
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    val = Tween<double>(begin: 1.05, end: 1).animate(controller);
    WidgetsBinding.instance.addPostFrameCallback((_){
      
    
    // Start initial animation
    Future.delayed(const Duration(milliseconds: 250), () => controller.forward());
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProgressTrackboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if textValue has changed
    if (widget.textValue != oldWidget.textValue) {
      controller.reverse().then((_) {
        // Update the text after reverse animation completes and play forward animation
        setState(() {});
        controller.forward();
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: val,
      child: Container(
        width: 300,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: DeviceUtils.isDarkMode(context)
              ? const Color.fromARGB(255, 201, 164, 209).withOpacity(0.5)
              : MyColors.dark.withOpacity(0.75),
          borderRadius: BorderRadius.circular(48),
        ),
        child: MyText().medium(context, widget.textValue, invertColor: true),
      ),
    );
  }
}
