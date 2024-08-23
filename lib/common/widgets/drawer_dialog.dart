import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/common/widgets/circle_box1.dart';
import 'package:tic_tac_toe/common/widgets/rectangular_box1.dart';
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
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    scaleVal = Tween<double>(begin: 0.25, end: 1,).animate(controller);
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
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        controller.reverse();
        
      },
      child: ScaleTransition(
        scale: scaleVal,
        child: Dialog(
          
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
                    padding: EdgeInsets.all(24),
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
                        CircleBox1(child: Icon(Icons.home_rounded, size: 28,),),
                        RectangularBoxIn(child: Text("Home", textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: Constants.medium),),)
                      ],),
                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        CircleBox1(child: Icon(Icons.person_rounded, size: 28,),),
                        RectangularBoxIn(child: Text("Profile", textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: Constants.medium),),)
                      ],),
                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        CircleBox1(child: Icon(Icons.settings_rounded, size: 28,),),
                        RectangularBoxIn(child: Text("Settings", textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: Constants.medium),),)
                      ],),
                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        CircleBox1(child: Icon(Icons.info_rounded, size: 28,),),
                        RectangularBoxIn(child: Text("About", textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: Constants.medium),),)
                      ],),
                    
                      Divider(height: 2, color: const Color.fromARGB(255, 245, 245, 220).withOpacity(0.4),),
                    ],
                  ),
                      ),
                ),
              ),
            ),
          ),),
      ),
    );
  }
}


class RectangularBoxIn extends StatelessWidget {
  final EdgeInsets? padding;
  final double width;
  final double height;
  final Widget? child;
  const RectangularBoxIn({
    super.key,
    this.width = 180,
    this.height = 48,
    this.padding,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: (){
        },
        padding: EdgeInsets.all(0),
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
                    const Color.fromARGB(255, 176, 216, 178).withOpacity(0.5), // Lighter green
                    const Color.fromARGB(255, 201, 164, 209).withOpacity(0.5), // Lighter purple
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            child: child ?? const SizedBox(),
        ),
      );
  }
}