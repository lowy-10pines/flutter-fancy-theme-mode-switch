import 'package:desafio_ui/utils/inherited_animacion.dart';
import 'package:desafio_ui/widgets/moon_border.dart';
import 'package:flutter/material.dart';

class SolYLuna extends StatelessWidget {
  final double padding;
  const SolYLuna({
    super.key,
    required double containerSize,
  }) : padding = containerSize / 14;

  DecorationTween get decorationsTween => DecorationTween(
        begin: const ShapeDecoration(
          color: Colors.white,
          shape: MoonBorder(),
          shadows: <BoxShadow>[
            BoxShadow(color: Colors.grey, blurRadius: 10.0, spreadRadius: 3.0),
          ],
        ),
        end: const ShapeDecoration(
          color: Colors.yellow,
          shape: CircleBorder(),
          shadows: <BoxShadow>[
            BoxShadow(
                color: Colors.orange, blurRadius: 10.0, spreadRadius: 3.0),
          ],
        ),
      );

  AlignmentTween get alignmentTween => AlignmentTween(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: AlignTransition(
        alignment: alignmentTween.animate(Animacion.of(context)),
        child: DecoratedBoxTransition(
          decoration: decorationsTween.animate(Animacion.of(context)),
          child: const AspectRatio(aspectRatio: 1),
        ),
      ),
    );
  }
}
