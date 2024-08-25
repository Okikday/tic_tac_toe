import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/models/grid_provider.dart';

class GridBoard extends StatelessWidget {
  GridBoard({super.key});

  GridProvider example = GridProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          child: Container(
            width: 300,
            height: 300,
            color: Colors.amber, // Background color of the grid
            child: Stack(
              children: [
                CustomPaint(
                  size: const Size(300, 300),
                  painter: HashShapePainter(),
                ),
                // Using a Grid to layout the items
                GridView(
                  padding: EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3x3 grid
                    childAspectRatio: 1.0, // Aspect ratio to make cells square
                  ),// 3x3 grid
                  children: [
                    GestureDetector(child: Text("1"), onTap: (){example.sayHello();},),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HashShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue // Color of the line
      ..style = PaintingStyle.fill; // Fill the rectangles

    // Calculate the positions and sizes to ensure the spaces form squares
    final double thirdWidth = size.width / 3;
    final double thirdHeight = size.height / 3;
    final double lineThickness = 8.0;
    final double radius = 24.0;

    // Draw the # shape with rounded rectangles
    // Horizontal rectangles
    final RRect topRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, thirdHeight - lineThickness / 2, size.width, lineThickness),
      Radius.circular(radius),
    );
    final RRect bottomRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 2 * thirdHeight - lineThickness / 2, size.width, lineThickness),
      Radius.circular(radius),
    );

    // Vertical rectangles
    final RRect leftRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(thirdWidth - lineThickness / 2, 0, lineThickness, size.height),
      Radius.circular(radius),
    );
    final RRect rightRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(2 * thirdWidth - lineThickness / 2, 0, lineThickness, size.height),
      Radius.circular(radius),
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
