import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/common/widgets/circle_box1.dart';
import 'package:tic_tac_toe/common/widgets/drawer_dialog.dart';
import 'package:tic_tac_toe/common/widgets/drawer_icon.dart';
import 'package:tic_tac_toe/common/widgets/home/challenge_type_select.dart';
import 'package:tic_tac_toe/common/widgets/home/grid_type_select_dialog.dart';
import 'package:tic_tac_toe/common/widgets/option_box.dart';
import 'package:tic_tac_toe/common/widgets/rectangular_box1.dart';
import 'package:tic_tac_toe/common/widgets/tic_tac_toe_text.dart';
import 'package:tic_tac_toe/data/shared_prefs_data_1.dart';
import 'package:tic_tac_toe/services/device_provider.dart';
import 'package:tic_tac_toe/services/game_provider.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';
import 'package:tic_tac_toe/views/gameplay/play_with_comp.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = DeviceUtils.getScreenWidth(context);
    final double screenHeight = DeviceUtils.getScreenHeight(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 201, 164, 209).withOpacity(0.05),
          ),
          child: Column(
            children: [
              Constants.whiteSpaceVertical(48),

              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DrawerIcon(
                      onpressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const DrawerDialog(),
                        );
                      },
                    ),
                    const TicTacToeText(),
                  ],
                ),
              ),

              Constants.whiteSpaceVertical(screenHeight * 0.04),

              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RectangularBox1(
                        onTap: () {
                          Fluttertoast.showToast(
                              msg: "Just damn choose what you playing as:}");
                        },
                        child: MyText().big(context, "Playing as")),
                    Consumer<GameProvider>(
                      builder: (context, value, child) {
                        return CircleBox1(
                          onpressed: (){
                            value.toggleUserChoice(context);
                          },
                          child: MyText().big(context, value.userChoice),
                        );
                      },
                    )
                  ],
                ),
              ),

              //Gridview
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 24.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 1,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    OptionBox(
                      child: Text(
                        "Play with your Computer",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: Constants.medium,
                        ),
                      ),
                      onpressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const PlayWithComp()));
                      },
                    ),
                    OptionBox(
                      child: Text(
                        "Play online with a friend",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: Constants.medium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Constants.whiteSpaceVertical(32),

              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                ),
                child: Column(
                  children: [
                    //Grid type
                    RectangularBox1(
                      height: 64,
                      width: screenWidth,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.grid_3x3_rounded),
                          Expanded(
                              child: Text(
                            "Play with a friend right here",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: Constants.medium),
                          ))
                        ],
                      ),
                    ),
                    Constants.whiteSpaceVertical(24),
                    RectangularBox1(
                      height: 64,
                      width: screenWidth,
                      padding: const EdgeInsets.all(12),
                      onTap: () async{
                        showDialog(
                            context: context,
                            builder: (context) => const GridTypeSelectDialog());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.grid_3x3_rounded),
                          Expanded(
                              child: Text(
                            "Grid type",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: Constants.medium),
                          ))
                        ],
                      ),
                    ),
                    Constants.whiteSpaceVertical(24),
                    RectangularBox1(
                      height: 64,
                      width: screenWidth,
                      padding: const EdgeInsets.all(12),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => const ChallengeTypeSelectDialog()
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.grid_3x3_rounded),
                          Expanded(
                              child: Text(
                            "Challenge Type",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: Constants.medium),
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Constants.whiteSpaceVertical(screenHeight * 0.04),

              //Leaderboard
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: RectangularBox1(
                  padding: const EdgeInsets.all(16),
                  width: screenWidth,
                  height: 96,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: SvgPicture.asset(
                          "assets/images/leaderboard-svgrepo.svg",
                          width: 64,
                          height: 64,
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.primary,
                              BlendMode.srcIn),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        "Leaderboards",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: Constants.extraMedium),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Grid type
//Challenge type
//5 Games