import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';
import 'package:tic_tac_toe/services/online_play.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class SendRequestPopUp extends StatefulWidget {
  final String? otherPlayerID;
  final String? otherPlayerName;
  final String? otherPlayerPhotoURL;
  const SendRequestPopUp({
    super.key,
    required this.otherPlayerID,
    required this.otherPlayerName,
    required this.otherPlayerPhotoURL,
  });

  @override
  State<SendRequestPopUp> createState() => _SendRequestPopUpState();
}

class _SendRequestPopUpState extends State<SendRequestPopUp> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleVal;
  bool playAsX = true;
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
                width: 300,
                height: 250,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: DeviceUtils.isDarkMode(context)
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.25)
                    : Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(36),
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 144, 202, 249).withOpacity(0.4), // Light Blue
                      const Color.fromARGB(255, 186, 104, 200).withOpacity(0.4), // Light Lavender
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 36),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                child:  widget.otherPlayerPhotoURL == null || widget.otherPlayerPhotoURL == "not-set" || widget.otherPlayerPhotoURL == "null"
                                    ? Image.asset(
                                        "assets/images/no_profile_photo_user.png")
                                    : Image.network(widget.otherPlayerPhotoURL!),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                         SizedBox(width: 150, child:  MyText().small(context, "Do you want to play with ${widget.otherPlayerName}",))
                        ],
                      ),
                    ),
                    //Middle play as
                    Row(children: [
                      MyText().small(context, "Play as X: "),
                      Switch(value: playAsX, onChanged: (value){
                        setState(() {
                          playAsX = value;
                        });
                      })
                    ],),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(onPressed: (){controller.reverse(); Navigator.pop(context);}, child: MyText().small(context, "Cancel", adjust: -1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),), color: Colors.red,),
                        MaterialButton(onPressed: (){
                          OnlinePlay(context).requestGamePlay(myUID: Provider.of<DeviceProvider>(context, listen: false).userId, otherPlayerUID: widget.otherPlayerID ?? "", choice: playAsX == true ? 'X' : 'O');
                          Navigator.pop(context);
                        }, child: MyText().small(context, "Request Gameplay", adjust: -1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),), color: Colors.green,)
                      ],
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
