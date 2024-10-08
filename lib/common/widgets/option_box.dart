
import 'package:flutter/material.dart';

class OptionBox extends StatefulWidget {
  final Widget? child;
  final void Function()? onpressed;

  const OptionBox({
    super.key,
    this.child,
    this.onpressed,
  });

  @override
  State<OptionBox> createState() => _OptionBoxState();
}

class _OptionBoxState extends State<OptionBox> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> scaleVal;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    scaleVal = Tween<double>(begin: 1, end: 0.75,).animate(controller);
    controller.addListener(listener);
  }
  listener(){
    
    if(controller.isCompleted || !controller.isAnimating){
      controller.reverse();
    }
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    
    

  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleVal,
      child: GestureDetector(
        onTapDown: (details){
          controller.forward(from: 0);
        },
        onTap: () {
          Future.delayed(const Duration(milliseconds: 190), (){
            widget.onpressed != null ? widget.onpressed!() : (){};
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 201, 164, 209).withOpacity(0.75),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(32),
            ),
            child: Container(
          padding: const EdgeInsets.all(8),
          width: 150,
          height: 150,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 131, 177, 134).withOpacity(0.5), // Lighter green
                        const Color.fromARGB(255, 170, 130, 179).withOpacity(0.5), // Lighter purple
                const Color.fromARGB(255, 245, 245, 220).withOpacity(0.5), // Cream
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: widget.child ?? const SizedBox(),
            ),
          ),
        ),
      ),
    );

  }
}