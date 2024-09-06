import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/widgets/checkmark_anim.dart';
import 'package:tic_tac_toe/data/firebase_data.dart';
import 'package:tic_tac_toe/services/device_provider.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/online_players.dart';

class VerifyEmail extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String uid;

  const VerifyEmail({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.uid,
  });

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  late Timer _timer;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _startEmailVerificationCheck();
  }

  void _startEmailVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _firebaseAuth.currentUser!.reload(); // Reload the user
      bool isVerified = _firebaseAuth.currentUser!.emailVerified;
      if (isVerified) {
        timer.cancel();
        _onEmailVerified();
      }
    });
  }

  void _onEmailVerified() async {
  final outcomeCreateUserData = await FirebaseData().createUserData(widget.uid, widget.name, widget.password, widget.email, "Firebase");
  if (outcomeCreateUserData == null) {
    if (context.mounted) {
      // ignore: use_build_context_synchronously
      Provider.of<DeviceProvider>(context, listen: false).saveUserDetails(widget.name, widget.email, widget.uid);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnlinePlayers()));
      if(context.mounted){
        // ignore: use_build_context_synchronously
        showDialog(context: context, builder: (context) => const CheckmarkAnim(text: "You successfully logged out", duration: 1500,));
      }
    }
  } else {
    FirebaseAuth.instance.currentUser!.delete();
    Fluttertoast.showToast(msg: "Failed to create user data: $outcomeCreateUserData");
  }
}


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "A verification email has been sent to your email address. Please verify your email to continue.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                _firebaseAuth.currentUser!.sendEmailVerification();
                Fluttertoast.showToast(msg: "Verification email resent.");
              },
              child: const Text("Resend Verification Email"),
            ),
          ],
        ),
      ),
    );
  }
}
