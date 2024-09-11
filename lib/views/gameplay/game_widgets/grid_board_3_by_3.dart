import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/services/providers/game_provider_3_by_3.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class GridBoard3by3 extends StatefulWidget {
  final void Function(int index) onpressed;
  final List<String?> boardTexts;
  
  const GridBoard3by3({
    super.key,
    required this.boardTexts,
    required this.onpressed,
  });

  @override
  State<GridBoard3by3> createState() => _GridBoard3by3State();
}

class _GridBoard3by3State extends State<GridBoard3by3> {
 

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
              const SizedBox(width: 300, height: 300,child: AnimatedHashShape(),),
              GridView.builder(
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  return Consumer<GameProvider3by3>(
                    builder: (context, provider, child) {
                      return GridItem(
                        text: widget.boardTexts[index] ?? '',
                        onpressed: () {
                          debugPrint("$index clicked!");
                          widget.onpressed(index);
                        },
                      );
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
    this.text = "",
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
      duration: const Duration(milliseconds: 200),
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
                  color: widget.text == "X" ? Colors.red : DeviceUtils.isDarkMode(context) ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}



//Hash Shape 3 by 3
class AnimatedHashShape extends StatefulWidget {
  const AnimatedHashShape({super.key});

  @override
  State<AnimatedHashShape> createState() => _AnimatedHashShapeState();
}

class _AnimatedHashShapeState extends State<AnimatedHashShape>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate
      ),
      
    );
   
    // Start the animation
    Future.delayed(const Duration(milliseconds: 200), () => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: CustomPaint(
        size: const Size(300, 300),
        painter: HashShapePainter(
          Paint()
            ..color = const Color.fromARGB(255, 201, 164, 209).withOpacity(0.5)
            ..style = PaintingStyle.fill,
        ),
      ),
    );
  }
}

// Painter for 3 by 3 grid
class HashShapePainter extends CustomPainter {
  final Paint paintStyle;

  HashShapePainter(this.paintStyle);

  @override
  void paint(Canvas canvas, Size size) {
    final double thirdWidth = size.width / 3;
    final double thirdHeight = size.height / 3;
    const double lineThickness = 8.0;
    const double radius = 0.0;

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

    canvas.drawRRect(topRect, paintStyle);
    canvas.drawRRect(bottomRect, paintStyle);
    canvas.drawRRect(leftRect, paintStyle);
    canvas.drawRRect(rightRect, paintStyle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

