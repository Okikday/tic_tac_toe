import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/common/widgets/checkmark_anim.dart';
import 'package:tic_tac_toe/common/widgets/custom_textfield.dart';
import 'package:tic_tac_toe/data/firebase_data.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';
import 'package:tic_tac_toe/services/user_auth.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/online_players.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  IconData iconPassword = Icons.remove_red_eye_rounded;
  bool obscureText = false;
  late String email;
  late String password;
  String? errorText;
  final UserAuth _userAuth = UserAuth();
  late bool isLoadingVisible;

  @override
  void initState() {
    super.initState();
    email = '';
    password = '';
    isLoadingVisible = false;
  }

  @override
  void dispose() {
    email = '';
    password = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyText().medium(context, "Sign in"),
        iconTheme: Theme.of(context)
            .iconTheme
            .copyWith(color: Theme.of(context).colorScheme.primary),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: [
            Constants.whiteSpaceVertical(24),
            MyText().big(context, "Login to an existing account."),
            Constants.whiteSpaceVertical(48),
            CustomTextfield(
              width: 90,
              label: "Email",
              hint: "Enter your E-mail",
              keyboardType: TextInputType.emailAddress,
              onchanged: (text) {
                email = text;
                setState(() => errorText = null);
              },
            ),
            Constants.whiteSpaceVertical(24),
            CustomTextfield(
              width: 90,
              label: "Password",
              hint: "Enter a Password",
              obscureText: obscureText,
              onchanged: (text) {
                password = text;
                setState(() => errorText = null);
              },
              suffixIcon: IconButton(
                icon: Icon(
                  iconPassword,
                  color: Colors.grey,
                ),
                onPressed: () {
                  if (iconPassword == Icons.remove_red_eye_rounded) {
                    setState(() {
                      obscureText = true;
                      iconPassword = Icons.lock_rounded;
                    });
                  } else {
                    setState(() {
                      obscureText = false;
                      iconPassword = Icons.remove_red_eye_rounded;
                    });
                  }
                },
              ),
              alwaysShowSuffixIcon: true,
            ),
            Constants.whiteSpaceVertical(36),
            MaterialButton(
              onPressed: () => loginButtonAction(context),
              minWidth: 320,
              height: 48,
              color: const Color.fromARGB(255, 201, 164, 209).withOpacity(0.75),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Visibility(
                  visible: isLoadingVisible,
                  child: Transform.scale(
                      scale: 2.5,
                      child: LottieBuilder.asset(
                        "assets/anims/loading_lottie.json",
                        width: 48,
                        height: 32,
                      )),
                ),
                MyText().small(context, "Login"),
              ]),
            ),

          ],
        ),
      ),
    );
  }

  void loginButtonAction(BuildContext context) async{
    if (email.length < 8 || password.length < 4) {
      Fluttertoast.showToast(msg: "Properly fill up the details!");
    }else{
      setState(()=>isLoadingVisible = true);
      final FirebaseData firebaseData = FirebaseData();
      final dynamic outcomeLogin = await _userAuth.signInWithEmailAndPassword(email, password);
      
      if(outcomeLogin is! String){
         String? uid = outcomeLogin[0];
         if(uid != null){
          final dynamic outcomeGetUserData = await firebaseData.getUserData(uid);
          if(context.mounted){
            if(outcomeGetUserData is! String){
            
            Provider.of<DeviceProvider>(context, listen: false).saveUserDetails(outcomeGetUserData['name'], email, outcomeGetUserData['id'], outcomeGetUserData['photoURL']);
            setState(()=>isLoadingVisible = false);
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnlinePlayers()));
            Fluttertoast.showToast(msg: "Successfully Logged in!");
            if(context.mounted) showDialog(context: context, builder: (context) => const CheckmarkAnim(text: "You successfully logged in", duration: 1500,));
            
        }else{
          Fluttertoast.showToast(msg: outcomeGetUserData);
        }
          }
         }
      }else{
        setState(()=>isLoadingVisible = false);
        Fluttertoast.showToast(msg: outcomeLogin);
      }
    }
  }
}
