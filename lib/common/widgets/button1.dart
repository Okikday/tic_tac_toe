import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';

class Button1 extends StatelessWidget {
  const Button1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 201, 164, 209).withOpacity(0.5), // Lighter purple
                const Color.fromARGB(255, 245, 245, 220).withOpacity(0.5), // Cream
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
        onPressed: (){}, child: Text("Continue", textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: Constants.medium,

            ),),),
    );
  }
}