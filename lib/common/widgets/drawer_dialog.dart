import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/common/widgets/circle_box1.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';
import 'package:tic_tac_toe/services/providers/game_provider_3_by_3.dart';
import 'package:tic_tac_toe/services/providers/game_provider_4_by_4.dart';
import 'package:tic_tac_toe/services/providers/game_provider_5_by_5.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class DrawerDialog extends StatefulWidget {
  const DrawerDialog({super.key});

  @override
  State<DrawerDialog> createState() => _DrawerDialogState();
}

class _DrawerDialogState extends State<DrawerDialog> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> scaleVal;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    scaleVal = Tween<double>(begin: 0, end: 1,).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    controller.forward();

    
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final double screenHeight = DeviceUtils.getScreenHeight(context);
    final double screenWidth = DeviceUtils.getScreenWidth(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        controller.reverse();
        Future.delayed(const Duration(milliseconds: 410), (){
          if(context.mounted) Navigator.of(context).pop();
        });
      },
      child: FadeTransition(
        opacity: scaleVal,
        child: Dialog(
          
          child: ScaleTransition(
            scale: scaleVal,
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 201, 164, 209).withOpacity(0.75), 
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(40),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    color: DeviceUtils.isDarkMode(context) ? Theme.of(context).colorScheme.secondary.withOpacity(0.25) : Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.6,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                          gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 201, 164, 209).withOpacity(0.25), // Lighter purple
                                  const Color.fromARGB(255, 245, 245, 220).withOpacity(0.4),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                    ),
                    child: Column(
                  
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Divider(height: 2, color: const Color.fromARGB(255, 245, 245, 220).withOpacity(0.4),),
                        //Home
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          CircleBox1(child: const Icon(Icons.home_rounded, size: 28,), onpressed: () => Navigator.pop(context),),
                          RectangularBoxIn(
                            onpressed: () => Navigator.pop(context),
                            child: Text("Home", textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: Constants.medium),),)
                        ],),
                  
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleBox1(child: const Icon(Icons.cancel_outlined, size: 28,), onpressed: () => resetElementAction(context),),
                            RectangularBoxIn(
                              onpressed: () => resetElementAction(context),
                              child: Text("Reset", textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: Constants.medium),),)
                          ],),
                  
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          const CircleBox1(child: Icon(Icons.person_rounded, size: 28,),),
                          RectangularBoxIn(child: Text("Profile", textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: Constants.medium),),)
                        ],),
                    
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          const CircleBox1(child: Icon(Icons.settings_rounded, size: 28,),),
                          RectangularBoxIn(child: Text("Settings", textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: Constants.medium),),)
                        ],),
                    
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          const CircleBox1(child: Icon(Icons.info_rounded, size: 28,),),
                          RectangularBoxIn(child: Text("About", textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: Constants.medium),),)
                        ],),
                      
                        Divider(height: 2, color: const Color.fromARGB(255, 245, 245, 220).withOpacity(0.4),),
                      ],
                    ),
                        ),
                  ),
                ),
              ),
            ),
          ),),
      ),
    );
  }

  void resetElementAction(BuildContext context) {
    if(Provider.of<DeviceProvider>(context, listen: false).gridType == 3){
     Provider.of<GameProvider3by3>(context, listen: false).resetGamePlay(context);
    }
    if(Provider.of<DeviceProvider>(context,  listen: false).gridType == 4){
     Provider.of<GameProvider4by4>(context, listen: false).resetGamePlay(context);
    }
    if(Provider.of<DeviceProvider>(context,  listen: false).gridType == 5){
     Provider.of<GameProvider5by5>(context, listen: false).resetGamePlay(context);
    }
    Navigator.of(context).pop();
  }
}


class RectangularBoxIn extends StatelessWidget {
  final EdgeInsets? padding;
  final double width;
  final double height;
  final Widget? child;
  final void Function()? onpressed;
  const RectangularBoxIn({
    super.key,
    this.width = 180,
    this.height = 48,
    this.padding,
    this.child,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        onpressed == null ? () {} : onpressed!();
      },
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        padding: padding,
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 55, 75, 56).withOpacity(0.5),
              const Color.fromARGB(255, 117, 86, 124).withOpacity(0.5), 
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // Inner border for subtle depth
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Soft dark shadow
              offset: const Offset(2, 2), // Slight offset for a smooth effect
              blurRadius: 4, // Light blur
              spreadRadius: -2, // Inner shadow effect
            ),
            BoxShadow(
              color: const Color.fromARGB(255, 147, 147, 147).withOpacity(0.1), // Light shadow on opposite side
              offset: const Offset(-2, -2), // Reverse offset for inner light
              blurRadius: 4,
              spreadRadius: -2,
            ),
          ],
        ),
        child: child ?? const SizedBox(),
      ),
    );
  }
}
