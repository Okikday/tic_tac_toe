import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/data/shared_prefs_data_1.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';
import 'package:tic_tac_toe/services/providers/online_provider.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/launch_game_online_play.dart';

class OnlineGameResultDialog extends StatefulWidget {
  final String message;
  final String otherPlayerPhotoURL;
  final String otherPlayerName;


  const OnlineGameResultDialog({
    super.key,
    required this.message,
    required this.otherPlayerName,
    required this.otherPlayerPhotoURL
  });

  @override
  State<OnlineGameResultDialog> createState() => _OnlineGameResultDialogState();
}

class _OnlineGameResultDialogState extends State<OnlineGameResultDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleVal;
  String result = "Who won?";

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = DeviceUtils.getScreenWidth(context);
    return PopScope(
      canPop: false,
      child: ScaleTransition(
        scale: scaleVal,
        child: Dialog(
          child: Container(
            width: screenWidth * 0.9,
            height: 300,
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
                          ? Theme.of(context).scaffoldBackgroundColor.withOpacity(0.75)
                          : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    ProfilePhotoAvatar(photoURL: Provider.of<DeviceProvider>(context, listen: false).photoURL),
                                    Constants.whiteSpaceHorizontal(12),
                                    MyText().big(context, Provider.of<OnlineProvider>(context).score1.toString(), adjust: 8),
                                  ],
                                ),
                                Constants.whiteSpaceVertical(8),
                                MyText().small(context, "You", adjust: 4),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 18),
                                child: MyText().small(context, "vs", align: TextAlign.center, adjust: 4),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    MyText().big(context, Provider.of<OnlineProvider>(context).score2.toString().toString(), adjust: 8),
                                    Constants.whiteSpaceHorizontal(24),
                                    ProfilePhotoAvatar(photoURL: widget.otherPlayerPhotoURL)
                                  ],
                                ),
                                Constants.whiteSpaceVertical(8),
                                MyText().small(context, widget.otherPlayerName, adjust: 4),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async{
                                final String gameplayID = Provider.of<OnlineProvider>(context, listen: false).currentOnlineGameplayID;
                                final String userID = Provider.of<DeviceProvider>(context, listen: false).userId;
                                await FirebaseDatabase.instance.ref("gameSessions/$gameplayID/endedSession").set(true);
                                if(context.mounted) {
                                  Navigator.pop(context);
                                  DeviceUtils.showFlushBar(context, "You ended the session");
                                }
                                final String playingAs = Provider.of<OnlineProvider>(context, listen: false).playingAs;
                                if(playingAs == "player1"){
                                  FirebaseDatabase.instance.ref("onlinePlayers/$userID/sentRequests/$gameplayID").remove();
                                }else if(playingAs == "player2"){
                                  FirebaseDatabase.instance.ref("onlinePlayers/$userID/requests/$gameplayID").remove();
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
                                "End game",
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async{
                                final String gameplayID = Provider.of<OnlineProvider>(context, listen: false).currentOnlineGameplayID;
                               final Map<String, String> resetList = {
                                  for (int i = 0; i < SharedPrefsData1.defaultGameplayListGrid3.length; i++)
                                    i.toString(): SharedPrefsData1.defaultGameplayListGrid3[i].toString()
                                };
                                await FirebaseDatabase.instance.ref("gameSessions/$gameplayID").update({
                                  "gameplayList": resetList,
                                });
                                if(context.mounted){
                                  Navigator.pop(context);
                                  DeviceUtils.pushMaterialPage(context, LaunchGameOnlinePlay(
                                    gridType: 3,
                                    gameplayID: gameplayID,
                                    otherPlayerPhotoURL: widget.otherPlayerPhotoURL,
                                    otherPlayerName: widget.otherPlayerName)
                                );
                                await FirebaseDatabase.instance.ref("gameSessions/$gameplayID/currentWinBy").set("newSession");
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
  final String photoURL;
  const ProfilePhotoAvatar({super.key, required this.photoURL});

  Widget image(){
    if(photoURL != "null" && photoURL != "not-set" && photoURL.isNotEmpty){
      return Image.network(photoURL);
    }else{
      return Image.asset("assets/images/no_profile_photo_user.png");
    }
  }

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
          child: image(),
        ),
      ),
    );
  }
}