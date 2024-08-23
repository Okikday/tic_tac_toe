import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/colors.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class GridTypeSelectDialog extends StatefulWidget {
  final double? left;
  final double? top;
  const GridTypeSelectDialog({
    super.key,
    this.left,
    this.top,
  });

  @override
  State<GridTypeSelectDialog> createState() => _GridTypeSelectDialogState();
}

class _GridTypeSelectDialogState extends State<GridTypeSelectDialog> with SingleTickerProviderStateMixin {
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
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.3,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: DeviceUtils.isDarkMode(context) ? Theme.of(context).colorScheme.secondary.withOpacity(0.25) : Theme.of(context).colorScheme.secondary.withOpacity(0.75)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(onPressed: (){}, child: Text("3 x 3 Grid", style: TextStyle(color: Theme.of(context).colorScheme.primary),), minWidth: screenWidth * 0.7, color: const Color.fromARGB(255, 201, 164, 209), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), height: 48,),
                    MaterialButton(onPressed: (){}, child: Text("4 x 4 Grid", style: TextStyle(color: Theme.of(context).colorScheme.primary),), minWidth: screenWidth * 0.7, color: const Color.fromARGB(255, 201, 164, 209), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), height: 48,),
              
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
