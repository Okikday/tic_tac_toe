import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class UserNotOnlineDialog extends StatefulWidget {
  const UserNotOnlineDialog({super.key});

  @override
  State<UserNotOnlineDialog> createState() => _UserNotOnlineDialogState();
}

class _UserNotOnlineDialogState extends State<UserNotOnlineDialog> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> scaleVal;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    scaleVal = Tween<double>(
      begin: 0.25,
      end: 1,
    ).animate(controller);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = DeviceUtils.getScreenWidth(context);
    return ScaleTransition(
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
                
                padding: const EdgeInsets.all(24),
                width: screenWidth * 0.9,
                height: 250,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: DeviceUtils.isDarkMode(context)
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.25)
                    : Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(36),
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 201, 164, 209).withOpacity(0.25),
                      const Color.fromARGB(255, 245, 245, 220).withOpacity(0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          child: Icon(Icons.person),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(width: 150, child: MyText().small(context, "User is not available right now.",))
                      ],
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                          onPressed: () {
                            controller.reverse();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: MyText().small(context, "Ok", color: Colors.black),
                        ),
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