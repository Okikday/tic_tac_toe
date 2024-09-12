import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/app.dart';
import 'package:tic_tac_toe/common/styles/colors.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/services/online_play.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';

class WaitingListsToPlayOnline extends StatelessWidget {
  final Map<dynamic, dynamic> sentRequests;
  const WaitingListsToPlayOnline({
    super.key,
    required this.sentRequests,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> requestsList = sentRequests.keys.toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Player requests"),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      ),
      body: ListView.builder(
        itemCount: requestsList.length,
        itemBuilder: (context, index) {
          String requestKey = requestsList[index];

          return StreamBuilder(
            stream: FirebaseDatabase.instance.ref('gameSessions/$requestKey/player2').onValue,
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data!.snapshot.exists) {
                Map<dynamic, dynamic>? player2Data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

                if (player2Data != null) {
                  return PlayerWaitingForAcceptanceOfGameplay(
                    userName: player2Data["userName"],
                    photoURL: player2Data["photoURL"],
                    gameplayID: requestKey,
                    status: player2Data["status"],
                    otherPlayerID: player2Data["uid"],
                  );
                } else {
                  return const ListTile(
                    title: Text("Data not available"),
                  );
                }
              } else {
                return const ListTile(
                  title: Text("No data found"),
                );
              }
            },
          );
        },
      ),
    );
  }
}



class PlayerWaitingForAcceptanceOfGameplay extends StatefulWidget {
  final String userName;
  final String photoURL;
  final String gameplayID;
  final String status;
  final String otherPlayerID;

  const PlayerWaitingForAcceptanceOfGameplay({
    super.key,
    required this.userName,
    required this.photoURL,
    required this.gameplayID,
    required this.status,
    required this.otherPlayerID,
  });

  @override
  State<PlayerWaitingForAcceptanceOfGameplay> createState() => _PlayerWaitingForAcceptanceOfGameplayState();
}

class _PlayerWaitingForAcceptanceOfGameplayState extends State<PlayerWaitingForAcceptanceOfGameplay> with SingleTickerProviderStateMixin {
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
              child: MyText().small(context, "Waiting for ${widget.userName} to accept request", adjust: -2),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    //On rejection
                    final String uid = Provider.of<DeviceProvider>(context, listen: false).userId;
                    OnlinePlay().cancelRequestGameplay(uid, widget.otherPlayerID, widget.gameplayID);
                  },
                  icon: const Icon(
                    Icons.cancel_rounded,
                    size: 32,
                    color: Color.fromARGB(255, 193, 50, 40),
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
