import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/colors.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class UserNotOnlineDialog extends StatefulWidget {
  final String photoURL;
  final String userName;
  const UserNotOnlineDialog({
    super.key,
    required this.photoURL,
    required this.userName,
  });

  @override
  State<UserNotOnlineDialog> createState() => _UserNotOnlineDialogState();
}

class _UserNotOnlineDialogState extends State<UserNotOnlineDialog> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> scaleVal;
  bool canPop = false;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    scaleVal = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.decelerate),);
    WidgetsBinding.instance.addPostFrameCallback((_){
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
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        controller.reverse();
        canPop = true;
        Future.delayed(const Duration(milliseconds: 260), (){if(context.mounted)Navigator.pop(context);});
        
      },
      child: ScaleTransition(
        scale: scaleVal,
        child: Dialog(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            blendMode: BlendMode.srcIn,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 201, 164, 209).withOpacity(0.75),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Container(
                
                padding: const EdgeInsets.all(24),
                width: screenWidth * 0.9,
                height: 250,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(36),
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 144, 202, 249)
                          .withOpacity(0.4), // Light Blue
                      const Color.fromARGB(255, 186, 104, 200)
                          .withOpacity(0.4), // Light Lavender
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 201, 164, 209)
                                    .withOpacity(0.75),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(60)
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(56),
                              clipBehavior: Clip.hardEdge,
                              child: CircleAvatar(
                                radius: 28,
                                child:  widget.photoURL.isEmpty || widget.photoURL == "not-set" || widget.photoURL == "null"
                                    ? Image.asset(
                                        "assets/images/no_profile_photo_user.png")
                                    : Image.network(widget.photoURL),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(width: 150, child: MyText().small(context, "${widget.userName} is not available right now.", color: Colors.white))
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    MaterialButton(
                      minWidth: 240,
                      color: const Color.fromARGB(255, 201, 164, 209),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
                      onPressed: () {
                        controller.reverseDuration;
                            controller.reverse();
                            
                            // ignore: use_build_context_synchronously
                            if(context.mounted) Future.delayed(const Duration(milliseconds: 120), () => Navigator.pop(context));
                          },
                          child: MyText().medium(context, "Ok",),)
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