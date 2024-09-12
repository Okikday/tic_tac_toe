import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/app.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/services/online_play.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class DialogGameRequestReady extends StatefulWidget {
  final String? otherPlayerName;
  final String? otherPlayerPhotoURL;
  final String gameIDToJoin;
  const DialogGameRequestReady({
    super.key,
    required this.otherPlayerName,
    required this.otherPlayerPhotoURL,
    required this.gameIDToJoin,
  });

  @override
  State<DialogGameRequestReady> createState() => _DialogGameRequestReadyState();
}

class _DialogGameRequestReadyState extends State<DialogGameRequestReady> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleVal;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
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
    return PopScope(
      canPop: false,
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
                  width: screenWidth * 0.9,
                  height: 250,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: DeviceUtils.isDarkMode(context)
                        ? Theme.of(context).colorScheme.secondary.withOpacity(0.25)
                        : Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(36),
                    
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 201, 164, 209).withOpacity(0.75),
                                    width: 1.5,
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color.fromARGB(255, 144, 202, 249).withOpacity(0.4), // Light Blue
                                      const Color.fromARGB(255, 186, 104, 200).withOpacity(0.4), // Light Lavender
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(60)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(56),
                                clipBehavior: Clip.hardEdge,
                                child: CircleAvatar(
                                  radius: 28,
                                  child: widget.otherPlayerPhotoURL == null || widget.otherPlayerPhotoURL == "not-set" || widget.otherPlayerPhotoURL == "null"
                                      ? Image.asset("assets/images/no_profile_photo_user.png")
                                      : Image.network(widget.otherPlayerPhotoURL!),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                                width: 150,
                                child: MyText().small(
                                  context,
                                  "${widget.otherPlayerName} is ready to play",
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 16),
                        child: SizedBox(
                          width: 200,
                          child: MaterialButton(
                            onPressed: (){
                              OnlinePlay().joinPlayerFromGameRequestReady(widget.gameIDToJoin);
                            },
                            child: MyText().small(context, "Join player", adjust: -1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.green,
                          ),
                        ),
                      ),
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
