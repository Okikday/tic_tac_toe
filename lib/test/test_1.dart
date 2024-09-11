import 'package:flutter/material.dart';
import 'package:tic_tac_toe/services/online_play.dart';

class Test1 extends StatelessWidget {
  const Test1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(onPressed: (){
          OnlinePlay(context).requestGamePlay(myUID: "myUID", otherPlayerUID: "anonymous");
        }, child: Text("Request gameplay",),
        )
      ),
    );
  }
}