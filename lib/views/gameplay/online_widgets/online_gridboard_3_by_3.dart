import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';

class OnlineGridboard3By3 extends StatefulWidget {
  final List<String?> boardTexts;
  
  const OnlineGridboard3By3({
    super.key,
    required this.boardTexts

  });

  @override
  State<OnlineGridboard3By3> createState() => _OnlineGridboard3By3State();
}

class _OnlineGridboard3By3State extends State<OnlineGridboard3By3> {
 

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
                painter: HashShapePainter(),
              ),
              GridView.builder(
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  
                  return GridItem(
                    text: widget.boardTexts[index] ?? "",
                    onpressed: () async{
                      debugPrint("$index clicked!");
                      debugPrint("Plays ${widget.boardTexts[index]}");
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

// Painter for 3 by 3 grid
class HashShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double thirdWidth = size.width / 3;
    final double thirdHeight = size.height / 3;
    const double lineThickness = 8.0;
    const double radius = 24.0;

    final RRect topRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          0, thirdHeight - lineThickness / 2, size.width, lineThickness),
      const Radius.circular(radius),
    );
    final RRect bottomRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          0, 2 * thirdHeight - lineThickness / 2, size.width, lineThickness),
      const Radius.circular(radius),
    );

    final RRect leftRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          thirdWidth - lineThickness / 2, 0, lineThickness, size.height),
      const Radius.circular(radius),
    );
    final RRect rightRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          2 * thirdWidth - lineThickness / 2, 0, lineThickness, size.height),
      const Radius.circular(radius),
    );

    canvas.drawRRect(topRect, paint);
    canvas.drawRRect(bottomRect, paint);
    canvas.drawRRect(leftRect, paint);
    canvas.drawRRect(rightRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
