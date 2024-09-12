import 'package:flutter/material.dart';

class RectangularBox1 extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final EdgeInsets padding;
  final Function(double dx, double dy)? onTapDown;
  final void Function()? onTap;
  const RectangularBox1({
    super.key,
    this.child = const SizedBox(),
    this.width = 250,
    this.height = 48,
    this.padding = EdgeInsets.zero,
    this.onTapDown,
    this.onTap
  });

  @override
  State<RectangularBox1> createState() => _RectangularBox1State();
}

class _RectangularBox1State extends State<RectangularBox1> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> scaleVal;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    scaleVal = Tween<double>(begin: 1, end: 0.9,).animate(controller);
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
      child: MaterialButton(
        onPressed: (){},
        padding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: GestureDetector(
          onTapDown: (details){
            final double dx = details.globalPosition.dx;
            final double dy = details.globalPosition.dy;
          controller.forward(from: 0);
          if(widget.onTapDown != null){
            widget.onTapDown!(dx, dy);
          }
        },
        onTap: (){
          if(widget.onTap != null){
            widget.onTap!();
          }
        },
          child: Container(
            padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 201, 164, 209).withOpacity(0.75), 
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(32),
              ),
            child: Container(
              padding: widget.padding,
              width: widget.width,
              height: widget.height,
              alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 131, 177, 134).withOpacity(0.5), // Lighter green
                        const Color.fromARGB(255, 170, 130, 179).withOpacity(0.5), // Lighter purple
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}