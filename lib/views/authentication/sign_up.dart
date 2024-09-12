import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/common/widgets/checkmark_anim.dart';
import 'package:tic_tac_toe/common/widgets/custom_textfield.dart';
import 'package:tic_tac_toe/common/widgets/loading_dialog.dart';
import 'package:tic_tac_toe/services/user_auth.dart';
import 'package:tic_tac_toe/views/authentication/sign_in.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/online_players.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  IconData iconPassword = Icons.remove_red_eye_rounded;
  bool obscureText = false;
  late String nameText;
  late String email;
  late String password;
  final UserAuth _userAuth = UserAuth();
  late bool isLoadingVisible;
  late bool canPop;

  @override
  void initState() {
    super.initState();
    nameText = '';
    email = '';
    password = '';
    isLoadingVisible = false;
    canPop = false;
  }

  @override
  void dispose() {
    nameText = '';
    email = '';
    password = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyText().medium(context, "Get Started"),
        iconTheme: Theme.of(context)
            .iconTheme
            .copyWith(color: Theme.of(context).colorScheme.primary),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Column(
            children: [
              Constants.whiteSpaceVertical(24),
              MyText().big(context, "Enter your details to get started"),
              Constants.whiteSpaceVertical(36),
              CustomTextfield(
                width: 90,
                label: "Username",
                hint: "Enter your Username",
                keyboardType: TextInputType.name,
                onchanged: (text) {
                  nameText = text;
                },
              ),
              Constants.whiteSpaceVertical(16),
              CustomTextfield(
                width: 90,
                label: "Email",
                hint: "Enter your E-mail",
                keyboardType: TextInputType.emailAddress,
                onchanged: (text) {
                  email = text.trim();
                },
              ),
              Constants.whiteSpaceVertical(24),
              CustomTextfield(
                width: 90,
                label: "Password",
                hint: "Enter a Password",
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscureText,
                onchanged: (text) {
                  password = text;
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
                onPressed: () => signUpButtonAction(context),
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
                MyText().small(context, "Sign up"),
              ]),
              ),
              Constants.whiteSpaceVertical(36),
              GestureDetector(
                  onTap: () => signInWithGoogleButtonAction(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withOpacity(0.2),
                            
                            shape: BoxShape.circle),
                        child: Image.asset("assets/images/google_logo.png"),
                      ),
                      TextButton(
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const SignIn()));},
                          child: MyText().small(context, "Sign in")),
                    ],
                  )),
                 Constants.whiteSpaceVertical(36),
                 MyText().small(context, "Don't bother forgetting your password, lol"),
            ],
          ),
        ),
      ),
    );
  }

  void signUpButtonAction(context) async {
  if (nameText.length < 3 || email.length < 8 || password.length < 4) {
    Fluttertoast.showToast(msg: "Properly fill in the details!");
  } else {

    setState(() => isLoadingVisible = true);
    await _userAuth.signUpWithEmailAndPassword(context, email, password, nameText);
    setState(() => isLoadingVisible = false);
  }
}

void signInWithGoogleButtonAction(context)async{
  showDialog(context: context, builder: (context) => LoadingDialog(canPop: canPop,));
  String? outcomeSignInGoogle = await _userAuth.signInWithGoogle(context);
  if(outcomeSignInGoogle == null){
    Fluttertoast.showToast(msg: "Successfully signed up");
    canPop = true;
    Navigator.of(context).pop();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnlinePlayers()));
    if(context.mounted) showDialog(context: context, builder: (context) => const CheckmarkAnim(text: "You successfully logged in with Google", duration: 1500,));
  }else{
    canPop = true;
    Navigator.of(context).pop();
    Fluttertoast.showToast(msg: outcomeSignInGoogle);
  }

}

}


