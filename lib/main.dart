import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Flutter code sample for [DecoratedBoxTransition].

void main() => runApp(const DecoratedBoxTransitionExampleApp());

class DecoratedBoxTransitionExampleApp extends StatefulWidget {
  const DecoratedBoxTransitionExampleApp({super.key});

  @override
  State<DecoratedBoxTransitionExampleApp> createState() =>
      _DecoratedBoxTransitionExampleAppState();
}

class _DecoratedBoxTransitionExampleAppState
    extends State<DecoratedBoxTransitionExampleApp> {
  bool value = true;
  void onTap(bool? newValue) {
    setState(() {
      value = newValue ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      home: ColoredBox(
        color: Colors.black,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FancySwitch(value: value, onChanged: onTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FancySwitch extends StatefulWidget {
  final void Function(bool?)? onChanged;
  final bool value;
  const FancySwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<FancySwitch> createState() => _FancySwitchState();
}

class _FancySwitchState extends State<FancySwitch>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3000),
  );

  late final CurvedAnimation _curvedAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    if (widget.value) {
      _controller.forward(from: 1);
    } else {
      _controller.reverse(from: 0);
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    const double height = 200;
    const double width = 350;
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: GestureDetector(
          onTap: () => widget.onChanged?.call(!widget.value),
          child: Animacion(
            _curvedAnimation,
            child: const FondoDeColor(
              child: Stack(
                children: [
                  SolYLuna(containerSize: height),
                  Estrellas(containerSize: height),
                  Nube(containerSize: height),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Animacion extends InheritedWidget {
  final Animation<double> animacion;
  const Animacion(
    this.animacion, {
    super.key,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is Animacion && oldWidget.animacion != animacion;
  }

  static Animation<double> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Animacion>()!.animacion;
  }
}

class FondoDeColor extends StatelessWidget {
  final Widget child;
  const FondoDeColor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final DecorationTween backgroundAnimationTween = DecorationTween(
      begin: BoxDecoration(
        borderRadius: BorderRadius.circular(150),
        color: const Color.fromARGB(255, 5, 3, 87),
      ),
      end: BoxDecoration(
        borderRadius: BorderRadius.circular(150),
        color: Colors.lightBlue.shade100,
      ),
    );

    return DecoratedBoxTransition(
      decoration: backgroundAnimationTween.animate(Animacion.of(context)),
      child: child,
    );
  }
}

class Nube extends StatelessWidget {
  final double detailsSize;
  const Nube({
    super.key,
    required double containerSize,
  }) : detailsSize = containerSize / 6;

  @override
  Widget build(BuildContext context) {
    final AlignmentTween alignmentTween = AlignmentTween(
      begin: const Alignment(-3.8, 0.35),
      end: const Alignment(-1.7, 0.35),
    );

    return AlignTransition(
      alignment: alignmentTween.animate(Animacion.of(context)),
      child: Padding(
        padding: EdgeInsets.only(top: detailsSize, bottom: detailsSize),
        child: AspectRatio(
          aspectRatio: 1.2,
          child: Center(
            child: CustomPaint(
              painter: CloudPainter(),
              child: Container(),
            ),
          ),
        ),
      ),
    );
  }
}

class CloudPainter extends CustomPainter {
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

class Estrellas extends StatelessWidget {
  final double size;
  const Estrellas({
    super.key,
    required double containerSize,
  }) : size = containerSize / 4;

  final List<Alignment> _estrellas = const [
    Alignment(-0.2, -0.6),
    Alignment(-0.3, 0.6),
    Alignment(0.5, -0.1),
  ];

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: -1).animate(Animacion.of(context)),
      child: Align(
        alignment: const Alignment(0.9, 0.5),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: _estrellas
                .map(
                  (alignment) => Align(
                    alignment: alignment,
                    child: RotationTransition(
                      turns: Tween<double>(begin: -1, end: 0.5)
                          .animate(Animacion.of(context)),
                      child: DecoratedBox(
                        decoration: const ShapeDecoration(
                            shape: StarBorder(), color: Colors.white),
                        child: SizedBox.square(
                          dimension: size,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class SolYLuna extends StatelessWidget {
  final double detailsSize;
  const SolYLuna({
    super.key,
    required double containerSize,
  }) : detailsSize = containerSize / 14;

  @override
  Widget build(BuildContext context) {
    final DecorationTween decorationsTween = DecorationTween(
      begin: const ShapeDecoration(
        color: Colors.white,
        shape: MoonBorder(),
        shadows: <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10.0,
            spreadRadius: 3.0,
          ),
        ],
      ),
      end: const ShapeDecoration(
        color: Colors.yellow,
        shape: CircleBorder(),
        shadows: <BoxShadow>[
          BoxShadow(
            color: Colors.orange,
            blurRadius: 10.0,
            spreadRadius: 3.0,
          ),
        ],
      ),
    );

    final AlignmentTween alignmentTween = AlignmentTween(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Padding(
      padding: EdgeInsets.all(detailsSize),
      child: AlignTransition(
        alignment: alignmentTween.animate(Animacion.of(context)),
        child: DecoratedBoxTransition(
          decoration: decorationsTween.animate(Animacion.of(context)),
          child: ClipOval(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(),
            ),
          ),
        ),
      ),
    );
  }
}

class MoonBorder extends OutlinedBorder {
  final double factorConcavidad;
  const MoonBorder({
    super.side,
    this.factorConcavidad = 0.8,
  });

  @override
  ShapeBorder scale(double t) => MoonBorder(side: side.scale(t));

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is MoonBorder) {
      return MoonBorder(
        side: BorderSide.lerp(a.side, side, t),
        factorConcavidad: lerpDouble(a.factorConcavidad, factorConcavidad, t)!,
      );
    }
    if (a is CircleBorder) {
      return MoonBorder(
        side: BorderSide.lerp(a.side, side, t),
        factorConcavidad: lerpDouble(0.8, factorConcavidad, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is MoonBorder) {
      return MoonBorder(
        side: BorderSide.lerp(side, b.side, t),
        factorConcavidad: lerpDouble(factorConcavidad, b.factorConcavidad, t)!,
      );
    }

    if (b is CircleBorder) {
      return MoonBorder(
        side: BorderSide.lerp(side, b.side, t),
        factorConcavidad: lerpDouble(factorConcavidad, -1, t)!,
      );
    }

    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final adjRect = _adjustRect(rect).deflate(side.strokeInset);

    if (factorConcavidad <= 0) {
      if (factorConcavidad <= -0.5) {
        return Path()
          ..moveTo(adjRect.centerRight.dx, adjRect.centerRight.dy)
          ..addOval(adjRect);
      }

      final delta = (adjRect.longestSide / 2) * -factorConcavidad;
      return Path()
        ..moveTo(
            adjRect.centerRight.dx - side.strokeInset, adjRect.centerRight.dy)
        ..addArc(adjRect, 0, 3 * math.pi / 2)
        ..cubicTo(
          adjRect.topCenter.dx + delta,
          adjRect.topCenter.dy,
          adjRect.centerRight.dx,
          adjRect.centerRight.dy - delta,
          adjRect.centerRight.dx,
          adjRect.centerRight.dy,
        );
    } else {
      final delta = (adjRect.longestSide / 2) * factorConcavidad;
      return Path()
        ..moveTo(
            adjRect.centerRight.dx - side.strokeInset, adjRect.centerRight.dy)
        ..addArc(adjRect, 0, 3 * math.pi / 2)
        ..cubicTo(
          adjRect.topCenter.dx - delta,
          adjRect.topCenter.dy + delta,
          adjRect.centerRight.dx - delta,
          adjRect.centerRight.dy + delta,
          adjRect.centerRight.dx,
          adjRect.centerRight.dy,
        );
    }
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final adjRect = _adjustRect(rect);

    final delta = (adjRect.longestSide / 2) * factorConcavidad;

    return Path()
      ..moveTo(
          adjRect.centerRight.dx - side.strokeInset, adjRect.centerRight.dy)
      ..addArc(adjRect, 0, 3 * math.pi / 2)
      ..cubicTo(
        adjRect.topCenter.dx - delta,
        adjRect.topCenter.dy + delta,
        adjRect.centerRight.dx - delta,
        adjRect.centerRight.dy + delta,
        adjRect.centerRight.dx,
        adjRect.centerRight.dy,
      );
  }

  @override
  void paintInterior(Canvas canvas, Rect rect, Paint paint,
      {TextDirection? textDirection}) {
    canvas.drawPath(getInnerPath(rect), paint);
  }

  @override
  bool get preferPaintInterior => true;

  @override
  MoonBorder copyWith({BorderSide? side, double? factorConcavidad}) {
    return MoonBorder(
      side: side ?? this.side,
      factorConcavidad: factorConcavidad ?? this.factorConcavidad,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    canvas.drawPath(getOuterPath(rect), side.toPaint());
  }

  Rect _adjustRect(Rect rect) {
    return Rect.fromCircle(
        center: rect.center, radius: rect.shortestSide / 2.0);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MoonBorder &&
        other.side == side &&
        other.factorConcavidad == factorConcavidad;
  }

  @override
  int get hashCode => Object.hash(side, factorConcavidad);

  @override
  String toString() {
    return 'MoonBorder($side, $factorConcavidad)';
  }
}
