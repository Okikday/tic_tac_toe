import 'package:flutter/material.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class SimPopup extends StatefulWidget {
  final double? left;
  final double? top;
  const SimPopup({
    super.key,
    this.left,
    this.top,
  });

  @override
  State<SimPopup> createState() => _SimPopupState();
}

class _SimPopupState extends State<SimPopup> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleVal;
  late Animation<Offset> posVal;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    scaleVal = Tween<double>(begin: 0.1, end: 1).animate(controller);
    controller.forward();
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = DeviceUtils.getScreenWidth(context);
    final double screenHeight = DeviceUtils.getScreenHeight(context);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        controller.reverse();
      },
      child: Dialog(
        child: ScaleTransition(
          scale: scaleVal,
          child: ClipRRect(
            child: Container(
              width: screenWidth * 0.8,
              height: screenHeight * 0.6,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: Colors.blue),
              child: Column(
                children: [
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
