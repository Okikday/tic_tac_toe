import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/common/widgets/checkmark_anim.dart';
import 'package:tic_tac_toe/data/realtime_data.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';

class DialogLogOut extends StatelessWidget {
  const DialogLogOut({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          const Color.fromARGB(255, 37, 52, 71),
      title: MyText().small(context, "Confirm Logout", color: Colors.white),
      content: MyText().small(context, "Are you sure you want to log out?",
          color: Colors.white),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: MyText().small(context, "Cancel", color: Colors.white),
        ),
        ElevatedButton(
          onPressed: () async {
            final DeviceProvider provider =
                Provider.of<DeviceProvider>(context, listen: false);
            final UserStatusService userStatusService =
                UserStatusService(provider.userId);
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
          child: MyText().small(context, "Log out",
              color: const Color.fromARGB(255, 255, 191, 186)),
        ),
      ],
    );
  }
}