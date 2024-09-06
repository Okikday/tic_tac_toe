import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/colors.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/common/widgets/checkmark_anim.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/dialog_game_request_ready.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/send_request_popup.dart';
import 'package:tic_tac_toe/common/widgets/user_not_online_dialog.dart';
import 'package:tic_tac_toe/data/realtime_data.dart';
import 'package:tic_tac_toe/services/device_provider.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/requests_list_tile.dart';

class OnlinePlayers extends StatefulWidget {
  const OnlinePlayers({super.key});

  @override
  State<OnlinePlayers> createState() => _OnlinePlayersState();
}

class _OnlinePlayersState extends State<OnlinePlayers>
    with SingleTickerProviderStateMixin {
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
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    scaleVal = Tween<double>(
      begin: 1,
      end: 0.9,
    ).animate(controller);
    controller.addListener(listener);
    hasAnimEnded = false;
    controller.forward();
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
    super.dispose();
  }

  void checkAcceptedGameplay(BuildContext context) async{
    if(hasShownDialog == false){
      final String myUID = Provider.of<DeviceProvider>(context, listen: false).userId;
       final DataSnapshot snapshot = await FirebaseDatabase.instance.ref("onlinePlayers/$myUID/sentRequests").get();
       if(snapshot.exists){
      final Map<dynamic, dynamic>? mapped = snapshot.value as Map<dynamic, dynamic>?;
      final String? gameplayID = mapped!.entries.first.key;
      Provider.of<DeviceProvider>(context, listen: false).setCurrentOnlineGameplayID(gameplayID ?? '');
      print("$gameplayID");
      final DataSnapshot dataSnapshot = await FirebaseDatabase.instance.ref("gameSessions/$gameplayID/hasOtherUserAccepted").get();
      if(dataSnapshot.exists && dataSnapshot.value == true){
        Future.delayed(Duration(milliseconds: 2000), ()async{
          if(context.mounted) showDialog(context: context, barrierDismissible: false, builder: (context) => const DialogGameRequestReady());
        });
      }
      hasShownDialog = false;
    }
       
    }
  }

  @override
  Widget build(BuildContext context) {
    UserStatusService(Provider.of<DeviceProvider>(context, listen: false).userId).trackUserStatus();
    checkAcceptedGameplay(context);

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
                      DeviceUtils.isDarkMode(context) == true
                          ? 'assets/anims/loading-carga.json'
                          : 'assets/anims/tic_tac_toe.json',
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
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 144, 202, 249).withOpacity(0.25),
            title: MyText().small(context, "Confirm Logout", color: Colors.white),
            content: MyText().small(context, "Are you sure you want to log out?", color: Colors.white),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: MyText().small(context, "Cancel", color: Colors.white),
              ),
              ElevatedButton(
                onPressed: () async {
                  final DeviceProvider provider = Provider.of<DeviceProvider>(context, listen: false);
                  final UserStatusService userStatusService = UserStatusService(
                      provider.userId);
                  userStatusService.setOffline();
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    provider.resetUserDetails();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Future.delayed(const Duration(milliseconds: 50), () {
                      if (context.mounted) {
                        showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (context) => const CheckmarkAnim(
                                  text: "You successfully logged out",
                                  duration: 1500,
                                ));
                      }
                    });
                  }
                },
                
                child: MyText().small(context, "Log out", color: const Color.fromARGB(255, 255, 191, 186)),
              ),
            ],
          );
        });
  }
}















class OnlineUserListTile extends StatefulWidget {
  const OnlineUserListTile({
    super.key,
    required this.snapshot,
  });

  final DataSnapshot snapshot;

  @override
  State<OnlineUserListTile> createState() => _OnlineUserListTileState();
}

class _OnlineUserListTileState extends State<OnlineUserListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleVal;
  late String photo;
  late String otherPlayerID;
  @override
  void initState() {
    super.initState();
    photo = widget.snapshot.child('photoURL').value.toString();
    otherPlayerID = widget.snapshot.key.toString();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    scaleVal = Tween<double>(
      begin: 1,
      end: 0.9,
    ).animate(controller);
    controller.addListener(listener);
    controller.forward();
  }

  listener() {
    if (controller.isCompleted || !controller.isAnimating) {
      controller.reverse();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => ScaleTransition(
        scale: scaleVal,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
          ),
          child: GestureDetector(
            onTapDown: (details) {
              controller.forward(from: 0);
              Future.delayed(const Duration(milliseconds: 50), () {
                if (context.mounted) {
                  String uid =
                      Provider.of<DeviceProvider>(context, listen: false)
                          .userId;
                  if (widget.snapshot.child("status").value.toString() ==
                          "online" &&
                      widget.snapshot.key.toString() != uid) {
                    if (context.mounted) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SendRequestPopUp(
                              otherPlayerID: otherPlayerID,
                              otherPlayerName: widget.snapshot
                                  .child('name')
                                  .value
                                  .toString(),
                              otherPlayerPhotoURL: photo,
                            );
                          });
                    }
                  }
                  if (widget.snapshot.child("status").value.toString() ==
                      "offline") {
                    if (context.mounted)
                      showDialog(
                          context: context,
                          builder: (context) => const UserNotOnlineDialog());
                  }
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color.fromARGB(255, 201, 164, 209)
                      .withOpacity(0.75),
                  width: 2,
                ),
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 144, 202, 249)
                        .withOpacity(0.25), // Light Blue
                    const Color.fromARGB(255, 186, 104, 200)
                        .withOpacity(0.25), // Light Lavender
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListTile(
                leading: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        padding: photo.isEmpty || photo == "not-set"
                            ? const EdgeInsets.all(8)
                            : const EdgeInsets.all(0),
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: MyColors.lavender,
                          shape: BoxShape.circle,
                        ),
                        child: photo.isEmpty || photo == "not-set"
                            ? FadeTransition(
                                opacity: scaleVal,
                                child: Image.asset(
                                    "assets/images/no_profile_photo_user_2.png"))
                            : FadeTransition(
                                opacity: scaleVal, child: Image.network(photo)),
                      ),
                      Positioned(
                          right: 4,
                          bottom: 4,
                          child: SizedBox(
                            width: 12,
                            height: 12,
                            child: Visibility(
                                visible: widget.snapshot.key.toString() == Provider.of<DeviceProvider>(context, listen: false).userId ? false : true,
                                child: CircleAvatar(
                                  backgroundColor: widget.snapshot.child('status').value == "online" ? Colors.green : Colors.red,
                                )),
                          )),
                    ],
                  ),
                ),
                title: MyText().medium(
                  context,
                  "${widget.snapshot.child('name').value}",
                ),
                subtitle: MyText().small(
                  context,
                  "${widget.snapshot.child('status').value}", color: widget.snapshot.child('status').value == "offline" ? Colors.grey : Colors.green
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
