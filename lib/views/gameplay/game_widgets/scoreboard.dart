import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/colors.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';

class Scoreboard extends StatefulWidget {
  final String playingWith;
  final int score1;
  final int score2;
  const Scoreboard({
    super.key,
    this.playingWith = "person",
    this.score1 = 0,
    this.score2 = 0,
    
  });

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> with SingleTickerProviderStateMixin{
   late AnimationController controller;
  late Animation<double> val;
  @override
  void initState() {
    
    
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    val = Tween<double>(begin: 1.1, end: 1).animate(controller);
    WidgetsBinding.instance.addPostFrameCallback((_){
     
    Future.delayed(const Duration(milliseconds: 25), () => controller.forward());
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: val,
      child: Container(
        width: 300,
        height: 120,
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: MyColors.bitterSweet,
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 176, 216, 178)
                  .withOpacity(0.5), // Lighter green
              const Color.fromARGB(255, 201, 164, 209)
                  .withOpacity(0.5), // Lighter purple
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    ProfilePhotoAvatar(photoURL: Provider.of<DeviceProvider>(context, listen: false).photoURL),
                    Constants.whiteSpaceHorizontal(12),
                    MyText().big(context, widget.score1.toString(), adjust: 8),
                  ],
                ),
                Constants.whiteSpaceVertical(8),
                MyText().small(context, "You", ),
              ],
            ),
            Expanded(child: Padding(padding: EdgeInsets.only(bottom: 18), child: MyText().small(context, "vs", align: TextAlign.center,),),),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    MyText().big(context, widget.score2.toString(), adjust: 8),
                    Constants.whiteSpaceHorizontal(24),
                    ProfilePhotoAvatar(photoURL: "assets/images/robot.png")
                  ],
                ),
                Constants.whiteSpaceVertical(8),
                MyText().small(context, widget.playingWith,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



class ProfilePhotoAvatar extends StatelessWidget {
  final String photoURL;
  const ProfilePhotoAvatar({super.key, required this.photoURL});

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
          child: photoURL.isEmpty || photoURL == "not-set"
              ? Image.asset("assets/images/no_profile_photo_user_2.png")
              : (photoURL == "assets/images/robot.png" ? Image.asset(photoURL) : Image.network(photoURL)),
        ),
      ),
    );
  }
}
