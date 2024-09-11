import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/common/widgets/user_not_online_dialog.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/send_request_popup.dart';

class OnlineUserListTile extends StatefulWidget {
  const OnlineUserListTile({
    super.key,
    required this.snapshot,
  });

  final DataSnapshot snapshot;

  @override
  State<OnlineUserListTile> createState() => _OnlineUserListTileState();
}

class _OnlineUserListTileState extends State<OnlineUserListTile> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleVal;
  String? photo;
  String otherPlayerID = '';
  String otherPlayerName = "name";
  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    scaleVal = Tween<double>(
      begin: 0.88,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.decelerate));
    controller.addListener(listener);
    controller.forward();
  }

  listener() {
    //(controller.isCompleted || !controller.isAnimating) ? controller.reverse() : (){};
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    photo = widget.snapshot.child('photoURL').value.toString();
    otherPlayerID = widget.snapshot.key.toString();
    otherPlayerName = widget.snapshot.child('name').value.toString();
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => ScaleTransition(
        scale: scaleVal,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
          ),
          child: GestureDetector(
            onTapDown: (details) {
              controller.forward(from: 0);
              Future.delayed(const Duration(milliseconds: 50), () {
                if (context.mounted) {
                  String uid = Provider.of<DeviceProvider>(context, listen: false).userId;
                  if (widget.snapshot.child("status").value.toString() == "online" && widget.snapshot.key.toString() != uid) {
                    if (context.mounted) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SendRequestPopUp(
                              otherPlayerID: otherPlayerID,
                              otherPlayerName: widget.snapshot.child('name').value.toString(),
                              otherPlayerPhotoURL: photo,
                            );
                          });
                    }
                  }
                  if (widget.snapshot.child("status").value.toString() == "offline") {
                    if (context.mounted) {
                      showDialog(
                          context: context,
                          builder: (context) => UserNotOnlineDialog(
                                userName: widget.snapshot.child('name').value.toString(),
                                photoURL: photo ?? "not-set",
                              ));
                    }
                  }
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color.fromARGB(255, 201, 164, 209).withOpacity(0.75),
                  width: 2,
                ),
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 144, 202, 249).withOpacity(0.25), // Light Blue
                    const Color.fromARGB(255, 186, 104, 200).withOpacity(0.25), // Light Lavender
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
                          child: Container(
                            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(56)),
                            child: photo == null || photo == "not-set" || photo == "null"
                                ? Image.asset("assets/images/no_profile_photo_user_2.png")
                                : Image.network(photo!),
                          ),
                        ),
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
                                  backgroundColor: widget.snapshot.child('status').value == "online" ? Colors.green : Colors.blue,
                                )),
                          )),
                    ],
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.play_arrow_rounded, color: Theme.of(context).colorScheme.primary),
                  padding: const EdgeInsets.all(6),
                  style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(CircleBorder()),
                    backgroundColor: WidgetStatePropertyAll(const Color.fromARGB(255, 201, 164, 209)),
                  ),
                ),
                title: MyText().medium(
                  context,
                  "${widget.snapshot.child('name').value}",
                ),
                subtitle: MyText().small(context, "${widget.snapshot.child('status').value}",
                    color: widget.snapshot.child('status').value == "offline" ? Colors.grey : Colors.green),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
