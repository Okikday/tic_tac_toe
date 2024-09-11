import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText().medium(context, "Leaderboards"),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
       
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Leaderboards", style: TextStyle(fontSize: Constants.big),),
            Constants.whiteSpaceVertical(36),
            LeaderboardBox()
            
          ],
        ),
      )
    );
  }
}


class LeaderboardBox extends StatelessWidget {
  const LeaderboardBox({super.key});

  @override
  Widget build(BuildContext context) {
   final double screenWidth = DeviceUtils.getScreenWidth(context);
    return Container(
      width: 320,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(

        children: [
          Container(
            alignment: Alignment.center,
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 56, color: Color(0xFFDDDDDD), ),
          ),
          SizedBox(width: 120, height: 64, child: MyText().big(context, "Name"),),
          const Text("Score",),
        ],
      ),
      
    );
  }
}