import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class GridBoard5by5 extends StatefulWidget {
  final void Function(int index) onpressed;
  final List<String?> boardTexts;
  const GridBoard5by5({
    super.key,
    required this.boardTexts,
    required this.onpressed,
  });

  @override
  State<GridBoard5by5> createState() => _GridBoard5by5State();
}

class _GridBoard5by5State extends State<GridBoard5by5> {
  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        child: Container(
          width: 320, // Adjusted for 5x5 grid
          height: 320,
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
              const SizedBox(width: 320, height: 320, child: AnimatedHashShape5x5(),),
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


// Animated Hash Shape for 5x5 grid
class AnimatedHashShape5x5 extends StatefulWidget {
  const AnimatedHashShape5x5({super.key});

  @override
  State<AnimatedHashShape5x5> createState() => _AnimatedHashShape5x5State();
}

class _AnimatedHashShape5x5State extends State<AnimatedHashShape5x5>
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

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
      ),
    );

    // Start the animation after a short delay
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
      child: FadeTransition(
        opacity: _animation,
        child: CustomPaint(
          size: const Size(300, 300), // Adjust size as needed
          painter: HashShapePainter5x5(
            Paint()
              ..color = const Color.fromARGB(255, 156, 121, 133).withOpacity(0.5)
              ..style = PaintingStyle.fill,
          ),
        ),
      ),
    );
  }
}

// Painter for 5x5 grid
class HashShapePainter5x5 extends CustomPainter {
  final Paint paintStyle;

  HashShapePainter5x5(this.paintStyle);

  @override
  void paint(Canvas canvas, Size size) {
    final double fifthWidth = size.width / 5;
    final double fifthHeight = size.height / 5;
    const double lineThickness = 8.0;
    const double radius = 24.0;

    // Drawing the grid lines
    for (int i = 1; i < 5; i++) {
      final RRect horizontalRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          0, i * fifthHeight - lineThickness / 2, size.width, lineThickness,
        ),
        const Radius.circular(radius),
      );
      final RRect verticalRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          i * fifthWidth - lineThickness / 2, 0, lineThickness, size.height,
        ),
        const Radius.circular(radius),
      );
      canvas.drawRRect(horizontalRect, paintStyle);
      canvas.drawRRect(verticalRect, paintStyle);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}