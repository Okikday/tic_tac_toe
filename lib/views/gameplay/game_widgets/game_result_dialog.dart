import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';
import 'package:tic_tac_toe/services/providers/game_provider_3_by_3.dart';
import 'package:tic_tac_toe/services/providers/game_provider_4_by_4.dart';
import 'package:tic_tac_toe/services/providers/game_provider_5_by_5.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class GameResultDialog extends StatefulWidget {
  final String winner;

  const GameResultDialog({
    super.key,
    required this.winner,
  });

  @override
  State<GameResultDialog> createState() => _GameResultDialogState();
}

class _GameResultDialogState extends State<GameResultDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleVal;
  String result = "Who won?";

  @override
  void initState() {
    super.initState();
    
    if(widget.winner == "user"){
      result = "You won!";
    }else if(widget.winner == "computer"){
      result = "Computer won";
    }else if(widget.winner == "draw"){
      result = "It's a draw";
    }
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    scaleVal = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.decelerate));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget image(String photoURL){
    if(widget.winner == "user"){
      if(photoURL.isEmpty || photoURL == "not-set"){
       return Image.asset("assets/images/no_profile_photo_user_2.png");
      }else{
        return Image.network(photoURL);
      }
    }else if(widget.winner == "computer"){
      return Image.asset("assets/images/robot.png");
    }else{
      return Image.asset("assets/images/no_profile_photo_user_2.png");
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final String photoURL = Provider.of<DeviceProvider>(context, listen: false).photoURL;
    final double screenWidth = DeviceUtils.getScreenWidth(context);
    return PopScope(
      canPop: false,
      child: ScaleTransition(
        scale: scaleVal,
        child: Dialog(
          child: Container(
            width: screenWidth * 0.9,
            height: 250,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              
              borderRadius: BorderRadius.circular(36),
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 45, 156, 145).withOpacity(0.5),
                  const Color(0xFF9F7AEA).withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                // Outer shadow for 3D effect
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.2), // Slight black shadow for depth
                  offset: const Offset(4, 4), // Positioned to give a light 3D feel
                  blurRadius: 10, // Slightly blurred for soft shadow
                ),
                
              ],
            ),

            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(left: 0, right: 0, top: 0, bottom: 0, child: LottieBuilder.asset("assets/anims/tic_tac_toe.json")),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    width: screenWidth * 0.9,
                    height: 250,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: DeviceUtils.isDarkMode(context)
                          ? Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.75)
                          : Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.75),
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 36),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ProfilePhotoAvatar(image: image(photoURL)),
                              const SizedBox(width: 16),
                              MyText().big(
                                context,
                                result,
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                final int gridType = Provider.of<DeviceProvider>(context,listen: false).gridType;
                                if (gridType == 3) {
                                  Provider.of<GameProvider3by3>(context, listen: false).resetGamePlay(context);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }
                                if (gridType == 4) {
                                  Provider.of<GameProvider4by4>(context, listen: false).resetGamePlay(context);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }
                                if (gridType == 5) {
                                  Provider.of<GameProvider5by5>(context, listen: false).resetGamePlay(context);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                elevation: 8, 
                                shadowColor: Colors.black.withOpacity(0.5),
                              ),
                              child: MyText().small(
                                context,
                                "Reset game",
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final int gridType = Provider.of<DeviceProvider>(context,listen: false).gridType;
                                if (gridType == 3) {
                                  Provider.of<GameProvider3by3>(context,listen: false).resetGameSession(context);
                                  controller.reverse();
                                  Future.delayed(const Duration(milliseconds: 360,), () {
                                    if(context.mounted){
                                      Navigator.of(context).pop();
                                      Provider.of<GameProvider3by3>(context,listen: false).playGame(context);
                                    }
                                  });
                                   
                                }
                                if (gridType == 4) {
                                  Provider.of<GameProvider4by4>(context,listen: false).resetGameSession(context);
                                  controller.reverse();
                                  Future.delayed(const Duration(milliseconds: 360,), () {
                                    if(context.mounted){
                                      Navigator.of(context).pop();
                                      Provider.of<GameProvider4by4>(context,listen: false).playGame(context);
                                    }
                                  });
                                }
                                if (gridType == 5) {
                                  Provider.of<GameProvider5by5>(context,listen: false).resetGameSession(context);
                                  controller.reverse();
                                  Future.delayed(const Duration(milliseconds: 360,), () {
                                    if(context.mounted){
                                      Navigator.of(context).pop();
                                      Provider.of<GameProvider5by5>(context,listen: false).playGame(context);
                                    }
                                  });
                                }
                                
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                elevation: 8, 
                                shadowColor: Colors.black.withOpacity(0.5),
                              ),
                              child: MyText().small(
                                context,
                                "Play again",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class ProfilePhotoAvatar extends StatelessWidget {
  final Widget? image;
  const ProfilePhotoAvatar({super.key, required this.image});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 201, 164, 209).withOpacity(0.75),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(60)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(56),
        clipBehavior: Clip.hardEdge,
        child: CircleAvatar(
          radius: 28,
          child: image ?? const SizedBox(),
        ),
      ),
    );
  }
}