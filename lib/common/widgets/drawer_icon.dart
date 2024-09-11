import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/colors.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class DrawerIcon extends StatelessWidget {
  final void Function()? onpressed;
  const DrawerIcon({
    super.key,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
        colors: [
            const Color.fromARGB(255, 55, 75, 56).withOpacity(0.5),
              const Color.fromARGB(255, 117, 86, 124).withOpacity(0.5), 
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,), shape: BoxShape.circle, ),
      child: IconButton(onPressed: onpressed ?? (){}, icon: Icon(Icons.menu_rounded, size: 32, color: DeviceUtils.isDarkMode(context) ? Colors.white : MyColors.dark),));
  }
}