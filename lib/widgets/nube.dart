import 'package:desafio_ui/utils/inherited_animacion.dart';
import 'package:flutter/material.dart';

class Nube extends StatelessWidget {
  final double size;
  const Nube({
    super.key,
    required double containerSize,
  }) : size = 3 * containerSize / 5;

  AlignmentTween get alignmentTween => AlignmentTween(
        // "Fuera de camara" para este tamaño de widget
        begin: const Alignment(-3.2, 7),
        end: Alignment.bottomLeft,
      );

  @override
  Widget build(BuildContext context) {
    return AlignTransition(
      alignment: alignmentTween.animate(Animacion.of(context)),
      child: SizedBox(
        height: size,
        child: const AspectRatio(
          aspectRatio: 1.2,
          child: CustomPaint(painter: CloudPainter()),
        ),
      ),
    );
  }
}

class CloudPainter extends CustomPainter {
  const CloudPainter() : super();

  @override
  void paint(Canvas canvas, Size size) {
    final dx = size.width / 6;
    final dy = size.height / 3;

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Large circle
    canvas.drawCircle(Offset(1.5 * dx, 1.5 * dy), 1.5 * dy, paint);

    // Medium circle
    canvas.drawCircle(Offset(5 * dx, 2 * dy), dy, paint);

    // Small circle
    canvas.drawCircle(Offset(7 * dx, 2.5 * dy), 0.5 * dy, paint);

    // Fillers
    canvas.drawRect(
        Rect.fromPoints(Offset(1.5 * dx, 2.5 * dy), Offset(7 * dx, 3 * dy)),
        paint);
    canvas.drawRect(
        Rect.fromPoints(Offset(1.5 * dx, 1.5 * dy), Offset(5 * dx, 3 * dy)),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
