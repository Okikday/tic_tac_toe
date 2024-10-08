import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class ChallengeTypeSelectDialog extends StatefulWidget {
  final double? left;
  final double? top;
  const ChallengeTypeSelectDialog({
    super.key,
    this.left,
    this.top,
  });

  @override
  State<ChallengeTypeSelectDialog> createState() => _ChallengeTypeSelectDialogState();
}

class _ChallengeTypeSelectDialogState extends State<ChallengeTypeSelectDialog> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleVal;
  late Animation<Offset> posVal;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    scaleVal = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
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
        Future.delayed(const Duration(milliseconds: 260), (){
          if(context.mounted) Navigator.pop(context);
        });
      },
      child: Dialog(
        child: FadeTransition(
          opacity: scaleVal,
          child: ScaleTransition(
            scale: scaleVal,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  width: screenWidth * 0.8,
                height: 300,
                clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: DeviceUtils.isDarkMode(context) ? Theme.of(context).colorScheme.secondary.withOpacity(0.75) : Theme.of(context).colorScheme.secondary.withOpacity(0.75)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton1(width: screenWidth * 0.7, text: "Easy", onpressed: (){
                        Provider.of<DeviceProvider>(context, listen: false).changeChallengeType(changeTo: 'E');
                        Navigator.pop(context);
                        DeviceUtils.showFlushBar(context, "Now playing in Easy Mode");
                      },),
                      CustomButton1(width: screenWidth * 0.7, text: "Medium", onpressed: (){
                        Provider.of<DeviceProvider>(context, listen: false).changeChallengeType(changeTo: 'M');
                        Navigator.pop(context);
                        DeviceUtils.showFlushBar(context, "Now playing in Medium Mode");
                      },),
                      CustomButton1(width: screenWidth * 0.7, text: "Hard", onpressed: (){
                        Provider.of<DeviceProvider>(context, listen: false).changeChallengeType(changeTo: 'H');
                        Navigator.pop(context);
                        DeviceUtils.showFlushBar(context, "Now playing in Difficult Mode");
                      },),
                
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
  const CustomButton1({
    super.key,
    required this.width,
    required this.text,
    this.onpressed
  });

  final double width;
  final String text;
  final void Function()? onpressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(onPressed: onpressed ?? (){}, minWidth: width, color: const Color.fromARGB(255, 201, 164, 209), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), height: 48, child: Text(text, style: TextStyle(color: Theme.of(context).colorScheme.primary),),);
  }
}
