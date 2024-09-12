import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/app.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/services/online_play.dart';
import 'package:tic_tac_toe/services/online_task_scheduler.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/dialog_log_out.dart';
import 'package:tic_tac_toe/data/realtime_data.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/online_user_list_tile.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/requests_list_tile.dart';

class OnlinePlayers extends StatefulWidget {
  const OnlinePlayers({super.key});

  @override
  State<OnlinePlayers> createState() => _OnlinePlayersState();
}

class _OnlinePlayersState extends State<OnlinePlayers> with SingleTickerProviderStateMixin {
  final DatabaseReference query = FirebaseDatabase.instance.ref("onlinePlayers");
  final bool showLoadingWidget = false;
  late AnimationController controller;
  late Animation<double> scaleVal;
  late bool hasAnimEnded;
  bool hasShownDialog = false;

  Future<DataSnapshot> _fetchOnlinePlayers() async {
    return await query.get();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    scaleVal = Tween<double>(
      begin: 1,
      end: 0.9,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.decelerate));
    controller.addListener(listener);
    hasAnimEnded = false;
    controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        debugPrint("Running online task function");
        OnlineTaskScheduler().runOnlineTask(context, () {
          if (context.mounted) {
            OnlinePlay().checkWaitingAccepted(myUID: Provider.of<DeviceProvider>(context, listen: false).userId);
          }
        });
      }
    });
    
  }

  listener() {
    if (!controller.isAnimating && hasAnimEnded == false) {
      hasAnimEnded = true;
      controller.reverse();
    } else if (!controller.isAnimating && hasAnimEnded == true) {
      hasAnimEnded = false;
      controller.forward();
    }
    
  }

  @override
  void dispose() {
    controller.dispose();
    OnlineTaskScheduler().endOnlineTask();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    UserStatusService(Provider.of<DeviceProvider>(context, listen: false).userId).trackUserStatus();
   
    return Scaffold(
      appBar: AppBar(
        title: MyText().medium(context, "Online players"),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
                onPressed: logoutButtonAction,
                icon: Icon(
                  Icons.logout_rounded,
                  color: Theme.of(context).colorScheme.primary,
                )),
          )
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: RequestsListTile(),
          ),
          Expanded(
            child: FutureBuilder<DataSnapshot>(
              future: _fetchOnlinePlayers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show loading indicator while waiting
                  return Center(
                    child: Lottie.asset(
                      DeviceUtils.isDarkMode(context) == true ? 'assets/anims/loading-carga.json' : 'assets/anims/tic_tac_toe.json',
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                      controller: controller,
                      animate: true,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.value == null) {
                  return const Center(child: Text('No online players found'));
                } else {
                  // Build the list
                  // Note: Handle the snapshot data appropriately here
                  return FirebaseAnimatedList(
                    query: query,
                    itemBuilder: (context, snapshot, animation, index) {
                      return OnlineUserListTile(
                        snapshot: snapshot,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  logoutButtonAction() async {
    showDialog(
        context: context,
        builder: (context) {
          return const DialogLogOut();
        });
  }
}
