import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:tic_tac_toe/services/providers/device_provider.dart';
import 'package:tic_tac_toe/services/providers/game_provider_3_by_3.dart';
import 'package:tic_tac_toe/services/providers/game_provider_4_by_4.dart';
import 'package:tic_tac_toe/services/providers/game_provider_5_by_5.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';
import 'package:tic_tac_toe/views/authentication/sign_up.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/play_with_comp_4_by_4.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/play_with_comp_5_by_5.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/online_players.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/play_with_comp_3_by_3.dart';
import 'package:tic_tac_toe/views/screens/leaderboard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int gridType = 3;
  String? playingAs = '';
  void checkChoice()async{
    if(gridType == 3){
      setState(() => playingAs = Provider.of<GameProvider3by3>(context, listen: false).userChoice);
    }else if(gridType == 4){
      setState(() => playingAs = Provider.of<GameProvider3by3>(context, listen: false).userChoice);
    }else if(gridType == 5){
      setState(() => playingAs = Provider.of<GameProvider3by3>(context, listen: false).userChoice);
    }
  }
  @override
  Widget build(BuildContext context) {
    gridType = Provider.of<DeviceProvider>(context, listen: false).gridType;
    final double screenWidth = DeviceUtils.getScreenWidth(context);
    final double screenHeight = DeviceUtils.getScreenHeight(context);
    checkChoice();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 201, 164, 209).withOpacity(0.05),
          ),
          child: Column(
            children: [
              Constants.whiteSpaceVertical(DeviceUtils.getAppBarHeight()),

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
                        onTap: toggleChoiceAction,
                        child: MyText().big(context, "Playing as ->")),
                    CircleBox1(
                          onpressed: toggleChoiceAction,
                          child: MyText().big(context, playingAs, color: playingAs == 'X' ? const Color.fromARGB(255, 156, 46, 46) : Colors.white)
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
                    OptionBox(//
                      child: Text(
                        "Play with your Computer",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: Constants.medium,
                        ),
                      ),
                      onpressed: () {
                        final int checkGridType = Provider.of<DeviceProvider>(context, listen: false).gridType;
                        if(checkGridType == 3){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const PlayWithComp3By3()));
                        }else if(checkGridType == 4){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const PlayWithComp4By4()));
                        }else if(checkGridType == 5){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const PlayWithComp5By5()));
                        }else{
                          DeviceUtils.showFlushBar(context, "Try choosing a Grid type");
                        }
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
                      onpressed: () {
                        //if(hasLoggedIn == true){}
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Provider.of<DeviceProvider>(context, listen: false).isUserLoggedIn == true ? const OnlinePlayers() : const SignUp()));
                      },
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
                    CustomRectangularBox1(
                      screenWidth: screenWidth,
                      ontap: (){},
                      isDialog: true,
                      svgPath: "assets/images/friends.svg",
                      title: "Play with a friend",
                    ),
                    Constants.whiteSpaceVertical(24),
                    CustomRectangularBox1(
                      screenWidth: screenWidth,
                      isDialog: true,
                      dialog: const GridTypeSelectDialog(),
                      svgPath: "assets/images/tic-tac-toe.svg",
                      title: "Grid type",
                    ),
                    Constants.whiteSpaceVertical(24),
                    CustomRectangularBox1(
                      screenWidth: screenWidth,
                      isDialog: true,
                      dialog: const ChallengeTypeSelectDialog(),
                      svgPath: "assets/images/Challenge_Icon.svg",
                      title: "Challenge type",
                    ),
                  ],
                ),
              ),

              Constants.whiteSpaceVertical(screenHeight * 0.04),

              //Leaderboard
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Hero(
                  tag: "leaderboard",
                  child: CustomRectangularBox1(
                      height: screenHeight * 0.1,
                      screenWidth: screenWidth,
                      isDialog: false,
                      page: const Hero(tag: "leaderboard", child: Leaderboard()),
                      svgPath: "assets/images/leaderboard-svgrepo.svg",
                      title: "Leaderboards",
                    ),
                ),
              ),
              Constants.whiteSpaceVertical(36)
            ],
          ),
        ),
      ),
    );
  }

  void toggleChoiceAction() async {
    
    
    if (gridType == 3) {
      playingAs = await Provider.of<GameProvider3by3>(context, listen: false).toggleUserChoice();
      setState(() => gridType);
    } else if (gridType == 4) {
      playingAs = await Provider.of<GameProvider4by4>(context, listen: false).toggleUserChoice();
      setState(() => gridType);
    } else if (gridType == 5) {
      playingAs = await Provider.of<GameProvider5by5>(context, listen: false).toggleUserChoice();
      setState(() => gridType);
    }
    checkChoice();
    // ignore: use_build_context_synchronously
    if(context.mounted){DeviceUtils.showFlushBar(context, "You chose $playingAs");}
  }
}


class CustomRectangularBox1 extends StatelessWidget {
  
  const CustomRectangularBox1({
    super.key,
    required this.screenWidth,
    required this.isDialog,
    this.height = 64,
    this.ontap,
    this.dialog,
    this.page,
    this.title = "title",
    this.svgPath = "assets/images/tic-tac-toe.svg",
  });

  final double screenWidth;
  final bool isDialog;
  final double height;
  final void Function()? ontap;
  final Widget? dialog;
  final Widget? page;
  final String svgPath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return RectangularBox1(
      height: height,
      width: screenWidth,
      padding: const EdgeInsets.all(12),
      onTap: (){
       if(ontap == null){
         isDialog == true ? showDialog(
            context: context,
            builder: (context) => dialog ?? const AlertDialog()
        ) : Navigator.push(context, MaterialPageRoute(builder: (context) => page ?? const SizedBox()));
       }else{
        ontap;
       }

      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            height: 36,
             child: SvgPicture.asset(
              svgPath,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary,
                  BlendMode.srcIn),
                  ), ),
          Expanded(
              child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: Constants.medium),
          ))
        ],
      ),
    );
  }
}