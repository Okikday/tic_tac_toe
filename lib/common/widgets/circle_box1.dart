import 'package:flutter/material.dart';

class CircleBox1 extends StatelessWidget {
  final Widget? child;
  final void Function()? onpressed;
  const CircleBox1({
    super.key,
    this.child,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onpressed ?? (){},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
      padding: EdgeInsets.all(0),
      minWidth: 48,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color.fromARGB(255, 55, 75, 56).withOpacity(0.5), // Lighter green
        ),
        child: child,
      ),
    );
  }
}