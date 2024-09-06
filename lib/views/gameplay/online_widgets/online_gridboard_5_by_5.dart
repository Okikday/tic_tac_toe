import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';

class OnlineGridboard5By5 extends StatefulWidget {
  const OnlineGridboard5By5({
    super.key,
  });

  @override
  State<OnlineGridboard5By5> createState() => _OnlineGridboard5By5State();
}

class _OnlineGridboard5By5State extends State<OnlineGridboard5By5> {
  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        child: Container(
          width: 375, // Adjusted for 5x5 grid
          height: 375,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 176, 216, 178).withOpacity(0.5),
                const Color.fromARGB(255, 201, 164, 209).withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              CustomPaint(
                size: const Size(375, 375), // Adjusted for 5x5 grid
                painter: HashShapePainter5x5(),
              ),
              GridView.builder(
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 25, // Adjusted for 5x5 grid
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // Adjusted for 5x5 grid
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  return GridItem(
                    text: "",
                    onpressed: () {
                      debugPrint("$index clicked!");
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridItem extends StatefulWidget {
  final String text;
  final void Function()? onpressed;
  const GridItem({
    super.key,
    this.onpressed,
    this.text = "lol",
  });
  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Color?> colorVal;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    colorVal = ColorTween(
            begin: Colors.transparent, end: Colors.white.withOpacity(0.1))
        .animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        controller.forward();
        Future.delayed(const Duration(milliseconds: 260), () {
          controller.reverse();
        });
      },
      onTap: () {
        widget.onpressed == null ? () {} : widget.onpressed!();
      },
      child: AnimatedBuilder(
        animation: colorVal,
        builder: (BuildContext context, Widget? child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: colorVal.value,
            ),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                color: Colors.transparent,
                child: MyText().big(
                  context,
                  widget.text == "null" ? "" : widget.text,
                  align: TextAlign.center,
                  adjust: 16,
                  color: Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class HashShapePainter5x5 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double fifthWidth = size.width / 5;
    final double fifthHeight = size.height / 5;
    const double lineThickness = 8.0;
    const double radius = 24.0;

    for (int i = 1; i < 5; i++) {
      final RRect horizontalRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, i * fifthHeight - lineThickness / 2, size.width, lineThickness),
        const Radius.circular(radius),
      );
      final RRect verticalRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(i * fifthWidth - lineThickness / 2, 0, lineThickness, size.height),
        const Radius.circular(radius),
      );
      canvas.drawRRect(horizontalRect, paint);
      canvas.drawRRect(verticalRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
