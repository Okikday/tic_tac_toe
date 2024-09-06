import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/services/device_provider.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/play_online.dart';

class DialogGameRequestReady extends StatefulWidget {
  const DialogGameRequestReady({
    super.key,
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
      onPopInvokedWithResult:(didPop, result){

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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const CircleAvatar(
                              radius: 28,
                              child: Icon(Icons.person),
                            ),
                            const SizedBox(width: 16),
                           SizedBox(width: 150, child:  MyText().small(context, "___ is ready to play",))
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterialButton(onPressed: (){
                              controller.reverse();
                              Navigator.pop(context);
                              }, child: MyText().small(context, "Cancel", adjust: -1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),), color: Colors.red,),
                            MaterialButton(onPressed: () async{
                              final String gameplayID = Provider.of<DeviceProvider>(context, listen: false).currentOnlineGameplayID;
                              final DataSnapshot snapshot = await FirebaseDatabase.instance.ref("gameSessions/$gameplayID/gridType").get();

                             if(context.mounted)  Navigator.push(context, MaterialPageRoute(builder: (context) => PlayOnline(playAs: "player1", gridType: int.parse(snapshot.value.toString()), gameplayID: gameplayID,)));
                            }, child: MyText().small(context, "Join player", adjust: -1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),), color: Colors.green,)
                          ],
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
