import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';
import 'package:tic_tac_toe/services/providers/game_provider_3_by_3.dart';
import 'package:tic_tac_toe/services/providers/game_provider_4_by_4.dart';
import 'package:tic_tac_toe/services/providers/game_provider_5_by_5.dart';
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

class _GridTypeSelectDialogState extends State<GridTypeSelectDialog>
    with SingleTickerProviderStateMixin {
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

    scaleVal = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: controller, curve: Curves.decelerate));
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        controller.reverse();
        Future.delayed(const Duration(milliseconds: 360), (){
          if(context.mounted) Navigator.pop(context);
        });
      },
      child: Dialog(
        child: ScaleTransition(
          scale: scaleVal,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              border: Border.all(
                color:
                    const Color.fromARGB(255, 201, 164, 209).withOpacity(0.75),
                width: 2,
              ),
            ),
            child: Container(
              width: screenWidth * 0.8,
              height: 300,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: DeviceUtils.isDarkMode(context)
                      ? Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.5)
                      : Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton1(
                          width: screenWidth * 0.7,
                          text: "3 x 3 Grid",
                          onpressed: () {
                            Provider.of<DeviceProvider>(context, listen: false)
                                .changeGridType(toGrid: 3);
                            Provider.of<GameProvider3by3>(context,
                                    listen: false)
                                .resetGameSession(context);
                            Navigator.pop(context);
                            DeviceUtils.showFlushBar(
                                context, "Changed Grid type to 3 x 3");
                          }),
                      CustomButton1(
                          width: screenWidth * 0.7,
                          text: "4 x 4 Grid",
                          onpressed: () {
                            Provider.of<DeviceProvider>(context, listen: false)
                                .changeGridType(toGrid: 4);
                            Provider.of<GameProvider4by4>(context,
                                    listen: false)
                                .resetGameSession(context);
                            Navigator.pop(context);
                            DeviceUtils.showFlushBar(
                                context, "Changed Grid type to 4 x 4");
                          }),
                      CustomButton1(
                          width: screenWidth * 0.7,
                          text: "5 x 5 Grid",
                          onpressed: () {
                            Provider.of<DeviceProvider>(context, listen: false)
                                .changeGridType(toGrid: 5);
                            Provider.of<GameProvider5by5>(context,
                                    listen: false)
                                .resetGameSession(context);
                            Navigator.pop(context);
                            DeviceUtils.showFlushBar(
                                context, "Changed Grid type to 5 x 5");
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton1 extends StatelessWidget {
  const CustomButton1(
      {super.key, required this.width, required this.text, this.onpressed});

  final double width;
  final String text;
  final void Function()? onpressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onpressed ?? () {},
      minWidth: width,
      color: const Color.fromARGB(255, 201, 164, 209),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      height: 48,
      elevation: 8,
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
