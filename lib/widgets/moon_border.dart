import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class MoonBorder extends OutlinedBorder {
  static const _concavidadMinima = -0.55;
  static const _concavidadMaxima = 0.8;

  final double factorConcavidad;
  const MoonBorder({
    super.side,
    this.factorConcavidad = _concavidadMaxima,
  });

// ===========================================================================
  // Paths: getInnerPath y getOuterPath definen la forma, tanto externa como interna (sin borde)

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getMoonPath(
      _ajustarRect(rect).deflate(side.strokeInset),
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getMoonPath(
      _ajustarRect(rect),
    );
  }

  Path _getMoonPath(Rect rect) {
    if (factorConcavidad <= _concavidadMinima) {
      // Mas allá de la concavidad minima, la luna se degenera en un circulo
      return Path()..addOval(rect);
    }

    final path = Path()
      // Dibujamos la parte redonda de la luna, de los radianes 0 al 3π/2
      ..moveTo(rect.centerRight.dx, rect.centerRight.dy)
      ..addArc(rect, 0, 3 * pi / 2);

    // Para la parte "concava" de la luna, usamos una curva de Bezier con dos puntos de control.
    Offset controlPoint1;
    Offset controlPoint2;

    // La curva va a ir desde el centro del borde superior al centro del borde derecho
    Offset start = rect.topCenter;
    Offset end = rect.centerRight;
    double radio = rect.shortestSide / 2;

    if (factorConcavidad <= 0) {
      // Para dibujar una concavidad negativa,
      // los puntos de control están alineados a los bordes superior y derecho del cuadrado
      final delta = radio * -factorConcavidad;

      controlPoint1 = Offset(start.dx + delta, start.dy);
      controlPoint2 = Offset(end.dx, end.dy - delta);
    } else {
      // Para una concavidad positiva,
      // los puntos de control están alineados a 45º de los puntos de inicio y llegada
      final delta = radio * factorConcavidad;

      controlPoint1 = Offset(start.dx - delta, start.dy + delta);
      controlPoint2 = Offset(end.dx - delta, end.dy + delta);
    }

    return path
      ..cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
          controlPoint2.dy, end.dx, end.dy);
  }

  /// Se asegura que el rect sea un cuadrado, o lo crea basandose en el lado más corto.
  Rect _ajustarRect(Rect rect) {
    return Rect.fromCircle(
      center: rect.center,
      radius: rect.shortestSide / 2.0,
    );
  }

// ===========================================================================

  // Paint: paint y paintInterior se ocupan de pintar la forma en un canvas, dibujando los bordes y el contenido respectivamente
  // podrían estar optimizados usando las apis de canvas (por ejemplo usando drawCircle en lugar de drawPath y pasandole el path de un circulo), pero no es nuestro caso

  @override
  bool get preferPaintInterior => true;

  @override
  void paintInterior(Canvas canvas, Rect rect, Paint paint,
      {TextDirection? textDirection}) {
    canvas.drawPath(getInnerPath(rect), paint);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    canvas.drawPath(getOuterPath(rect), side.toPaint());
  }

// ===========================================================================
// copyWith y scale son parte de la interfaz requerida por OutlinedShape. Son los ultimos override requeridos

  @override
  MoonBorder copyWith({BorderSide? side, double? factorConcavidad}) {
    return MoonBorder(
      side: side ?? this.side,
      factorConcavidad: factorConcavidad ?? this.factorConcavidad,
    );
  }

  @override
  ShapeBorder scale(double t) =>
      MoonBorder(side: side.scale(t), factorConcavidad: factorConcavidad);

// ===========================================================================
  // Opcionalmente, podemos definir la interpolación, para permitir transiciones de forma.
  // Por lo pronto, la luna solo se interpola desde/hacia un circulo, representado con CircleBorder.
  // Podríamos pasar por otras formas intermedias de ser necesario
  // x ej si queremos interpolar la luna desde un cuadrado, podemos pasar de cuadrado a circulo y luego de circulo a la luna

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is CircleBorder) {
      return MoonBorder(
        side: BorderSide.lerp(a.side, side, t),
        factorConcavidad: lerpDouble(_concavidadMinima, factorConcavidad, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is CircleBorder) {
      return MoonBorder(
        side: BorderSide.lerp(side, b.side, t),
        factorConcavidad: lerpDouble(factorConcavidad, _concavidadMinima, t)!,
      );
    }
    return super.lerpTo(b, t);
  }
}
