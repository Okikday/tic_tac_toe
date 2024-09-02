import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';

class GridBoard4by4 extends StatefulWidget {
  final void Function(int index) onpressed;
  final List<String?> boardTexts;
  const GridBoard4by4({
    super.key,
    required this.boardTexts,
    required this.onpressed,
  });

  @override
  State<GridBoard4by4> createState() => _GridBoard4by4State();
}

class _GridBoard4by4State extends State<GridBoard4by4> {
 
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        child: Container(
          width: 300,
          height: 300,
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
                size: const Size(300, 300),
                painter: HashShapePainter4x4(),
              ),
              GridView.builder(
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 16,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  return GridItem(
                    text: widget.boardTexts[index] ?? "",
                    onpressed: () {
                      debugPrint("$index clicked!");
                      widget.onpressed(index);
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

// Painter for 4 by 4 grid
class HashShapePainter4x4 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double quarterWidth = size.width / 4;
    final double quarterHeight = size.height / 4;
    const double lineThickness = 8.0;
    const double radius = 24.0;

    for (int i = 1; i < 4; i++) {
      final RRect horizontalRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, i * quarterHeight - lineThickness / 2, size.width, lineThickness),
        const Radius.circular(radius),
      );
      final RRect verticalRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(i * quarterWidth - lineThickness / 2, 0, lineThickness, size.height),
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
