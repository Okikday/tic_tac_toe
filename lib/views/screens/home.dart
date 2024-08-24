import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/common/widgets/circle_box1.dart';
import 'package:tic_tac_toe/common/widgets/drawer_dialog.dart';
import 'package:tic_tac_toe/common/widgets/drawer_icon.dart';
import 'package:tic_tac_toe/common/widgets/home/grid_type_select_dialog.dart';
import 'package:tic_tac_toe/common/widgets/option_box.dart';
import 'package:tic_tac_toe/common/widgets/rectangular_box1.dart';
import 'package:tic_tac_toe/common/widgets/sim_popup.dart';
import 'package:tic_tac_toe/common/widgets/tic_tac_toe_text.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final double screenWidth = DeviceUtils.getScreenWidth(context);
    final double screenHeight = DeviceUtils.getScreenHeight(context);
    return Scaffold(
      key: _scaffoldKey,
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
                      onTapDown: (dx, dy){
                        showDialog(context: context, builder: (context) => SimPopup());
                      },
                      child: Text(
                        "Who's Online?",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: Constants.medium),
                      ),
                    ),
                    CircleBox1(
                      child: Text(
                        "👀",
                        style: TextStyle(fontSize: Constants.medium),
                      ),
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
                        "Play online with a friend",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: Constants
                              .medium,
                        ),
                      ),
                    ),
                    OptionBox(
                      child: Text(
                        "Play with your computer",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: Constants
                              .medium,
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
                      onTap: () {
                        showDialog(context: context, builder: (context) => const GridTypeSelectDialog());
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.grid_3x3_rounded),
                          Expanded(
                              child: Text(
                            "Challenge type",
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.grid_3x3_rounded),
                          Expanded(
                              child: Text(
                            "Ultimate Challenge",
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