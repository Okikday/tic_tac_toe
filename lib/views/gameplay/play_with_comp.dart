import 'package:flutter/material.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class PlayWithComp extends StatefulWidget {
  const PlayWithComp({super.key});

  @override
  State<PlayWithComp> createState() => _PlayWithCompState();
}

class _PlayWithCompState extends State<PlayWithComp> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = DeviceUtils.getScreenWidth(context);
    final double screenHeight = DeviceUtils.getScreenWidth(context);

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: CustomPaint(
          size: const Size(300, 300),
          painter: HashShapePainter(),
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
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0 // Thickness of the line
      ..strokeCap = StrokeCap.round; // Makes the ends of the line rounded

    // Draw the # shape
    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.2)
      ..lineTo(size.width * 0.75, size.height * 0.2) // Top horizontal line
      ..moveTo(size.width * 0.25, size.height * 0.8)
      ..lineTo(size.width * 0.75, size.height * 0.8) // Bottom horizontal line
      ..moveTo(size.width * 0.35, size.height * 0.1)
      ..lineTo(size.width * 0.35, size.height * 0.9) // Left vertical line
      ..moveTo(size.width * 0.65, size.height * 0.1)
      ..lineTo(size.width * 0.65, size.height * 0.9); // Right vertical line

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}