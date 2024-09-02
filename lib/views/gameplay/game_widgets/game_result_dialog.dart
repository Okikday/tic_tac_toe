import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/services/device_provider.dart';
import 'package:tic_tac_toe/services/game_provider_3_by_3.dart';
import 'package:tic_tac_toe/services/game_provider_4_by_4.dart';
import 'package:tic_tac_toe/services/game_provider_5_by_5.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class GameResultDialog extends StatefulWidget {
  final String result;
  const GameResultDialog({
    super.key,
    required this.result,
  });

  @override
  State<GameResultDialog> createState() => _GameResultDialogState();
}

class _GameResultDialogState extends State<GameResultDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleVal;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    scaleVal = Tween<double>(
      begin: 0.25,
      end: 1,
    ).animate(controller);
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
                          radius: 40,
                          child: Icon(Icons.person),
                        ),
                        const SizedBox(width: 16),
                        MyText().medium(context, widget.result, invertColor: true)
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if(Provider.of<DeviceProvider>(context, listen: false).gridType == 3){
                              Provider.of<GameProvider3by3>(context, listen: false).resetGamePlay(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                            if(Provider.of<DeviceProvider>(context, listen: false).gridType == 4){
                              Provider.of<GameProvider4by4>(context, listen: false).resetGamePlay(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                            if(Provider.of<DeviceProvider>(context, listen: false).gridType == 5){
                              Provider.of<GameProvider5by5>(context, listen: false).resetGamePlay(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: MyText().small(context, "Reset game", invertColor: true),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if(Provider.of<DeviceProvider>(context, listen: false).gridType == 3){
                            Provider.of<GameProvider3by3>(context, listen: false).resetGameSession(context);
                            Navigator.pop(context);
                            Provider.of<GameProvider3by3>(context, listen: false).playGame(context);
                            }
                            if(Provider.of<DeviceProvider>(context, listen: false).gridType == 4){
                            Provider.of<GameProvider4by4>(context, listen: false).resetGameSession(context);
                            Navigator.pop(context);
                            Provider.of<GameProvider4by4>(context, listen: false).playGame(context);
                            }
                            if(Provider.of<DeviceProvider>(context, listen: false).gridType == 5){
                            Provider.of<GameProvider5by5>(context, listen: false).resetGameSession(context);
                            Navigator.pop(context);
                            Provider.of<GameProvider5by5>(context, listen: false).playGame(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: MyText().small(context, "Continue", invertColor: true),
                        ),
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
