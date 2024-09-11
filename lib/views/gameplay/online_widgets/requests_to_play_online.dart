import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/colors.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/launch_game_online_play.dart';

class RequestsToPlayOnline extends StatelessWidget {
  const RequestsToPlayOnline({super.key});

  @override
  Widget build(BuildContext context) {
    final Query query = FirebaseDatabase.instance.ref('gameSessions');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyText().medium(context, "Player requests"),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: query,
              defaultChild: const Center(
                child: CircularProgressIndicator(),
              ), // Show CircularProgressIndicator while data is loading
              itemBuilder: (context, snapshot, animation, index) {

                // Check if snapshot has data before accessing it
                if (!snapshot.exists) {
                  return const Center(
                    child: CircularProgressIndicator(), // Show a circular loader if data hasn't loaded yet
                  );
                }

                // Access the specific child path
                Map<dynamic, dynamic>? userInfo = snapshot.child("player1").value as Map<dynamic, dynamic>?;

                if (userInfo != null) {
                  return PlayerRequestsListTile(
                    userName: userInfo['userName'] ?? "not-available",
                    photoURL: userInfo['photoURL'] ?? "not-available",
                    gameplayID: "",
                    status: userInfo['status'],
                  );
                } else {
                  return const SizedBox(); // Return an empty widget if no data is available
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}




















class PlayerRequestsListTile extends StatefulWidget {
  final String userName;
  final String photoURL;
  final String gameplayID;
  final String status;

  const PlayerRequestsListTile({
    super.key,
    required this.userName,
    required this.photoURL,
    required this.gameplayID,
    required this.status
  });

  @override
  State<PlayerRequestsListTile> createState() => _PlayerRequestsListTileState();
}

class _PlayerRequestsListTileState extends State<PlayerRequestsListTile> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleVal;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    scaleVal = Tween<double>(begin: 1, end: 0.5).animate(controller);
    controller.reverse();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: MyColors.gray.withOpacity(0.65),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // The Image
            ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(32),
              child: CircleAvatar(
                radius: 32,
                child: widget.photoURL.isEmpty || widget.photoURL == "not-set"
                    ? Image.asset("assets/images/no_profile_photo_user_2.png")
                    : Image.network(widget.photoURL),
              ),
            ),
            SizedBox(
              width: 120,
              child: MyText().small(context, "${widget.userName} requested a gameplay", adjust: -2),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    //On rejection
                    String uid = Provider.of<DeviceProvider>(context, listen: false).userId;
                    // await FirebaseDatabase.instance.ref("gameSessions/$gameplayID").remove();
                    // await FirebaseDatabase.instance.ref("onlinePlayers/$uid/requests/$gameplayID").remove();
                    if (context.mounted) {
                      DeviceUtils.showFlushBar(context, "You rejected a gameplay with ${widget.userName}");
                    }
                  },
                  icon: const Icon(
                    Icons.cancel_rounded,
                    size: 32,
                    color: Color.fromARGB(255, 193, 50, 40),
                  ),
                ),
                IconButton(
                  onPressed: () async{
                    //On acceptance
                    String uid = Provider.of<DeviceProvider>(context, listen: false).userId;
                    DataSnapshot currentGameplayID = await FirebaseDatabase.instance.ref("onlinePlayers/$uid/requests").get();
                    Map<dynamic, dynamic>? requests = currentGameplayID.value as Map<dynamic, dynamic>?;
                    String gameplayID = requests!.keys.first.toString();
                    await FirebaseDatabase.instance.ref("gameSessions/$gameplayID").update({
                      'hasOtherUserAccepted': true
                    });
                    if(context.mounted){
                    Navigator.pop(context);
                    
                    }
                  },
                  icon: const Icon(
                    Icons.check_circle_outlined,
                    size: 32,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
