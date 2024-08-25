import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';

class GridBoard3by3 extends StatelessWidget {
  const GridBoard3by3({super.key});

  @override

  Widget build(BuildContext context) {
    final int trackCount = 0;


    return Center(
        child: ClipRRect(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 176, 216, 178).withOpacity(0.5), // Lighter green
                        const Color.fromARGB(255, 201, 164, 209).withOpacity(0.5), // Lighter purple
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
                // Using a Grid to layout the items
                GridView.builder(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3x3 grid
                    childAspectRatio: 1.0, // Aspect ratio to make cells square
                  ),// 3x3 grid
                  itemBuilder: (context,index) => GestureDetector(
                    onTap: () => {

                    },
                    child: AspectRatio(aspectRatio: 1.0, child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(0),
                      width: 100, height: 100, color: Colors.transparent, child: MyText().big(context, "X", align: TextAlign.center, adjust: 16, color: Colors.red,), ),),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

















//Painter for 3 by 3 grid
class HashShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white // Color of the line
      ..style = PaintingStyle.fill; // Fill the rectangles

    // Calculate the positions and sizes to ensure the spaces form squares
    final double thirdWidth = size.width / 3;
    final double thirdHeight = size.height / 3;
    const double lineThickness = 8.0;
    const double radius = 24.0;

    // Draw the # shape with rounded rectangles
    // Horizontal rectangles
    final RRect topRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, thirdHeight - lineThickness / 2, size.width, lineThickness),
      const Radius.circular(radius),
    );
    final RRect bottomRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 2 * thirdHeight - lineThickness / 2, size.width, lineThickness),
      const Radius.circular(radius),
    );

    // Vertical rectangles
    final RRect leftRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(thirdWidth - lineThickness / 2, 0, lineThickness, size.height),
      const Radius.circular(radius),
    );
    final RRect rightRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(2 * thirdWidth - lineThickness / 2, 0, lineThickness, size.height),
      const Radius.circular(radius),
    );

    // Draw the rectangles
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
