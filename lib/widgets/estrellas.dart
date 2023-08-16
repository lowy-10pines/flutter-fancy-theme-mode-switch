import 'package:desafio_ui/utils/inherited_animacion.dart';
import 'package:flutter/material.dart';

class Estrellas extends StatelessWidget {
  final double size;
  const Estrellas({
    super.key,
    required double containerSize,
  }) : size = containerSize / 4;

  final List<Alignment> _alignEstrellas = const [
    Alignment(-0.2, -0.6),
    Alignment(-0.3, 0.6),
    Alignment(0.5, -0.1),
  ];

  Tween<double> get fadeTween => Tween<double>(begin: 1, end: -1);
  Tween<double> get rotationTween => Tween<double>(begin: -1, end: 0.5);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeTween.animate(Animacion.of(context)),
      child: Align(
        alignment: const Alignment(0.9, 0.5),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: _alignEstrellas
                .map((alignment) => Align(
                      alignment: alignment,
                      child: RotationTransition(
                        turns: rotationTween.animate(Animacion.of(context)),
                        child: SizedBox.square(
                          dimension: size,
                          child: const DecoratedBox(
                            decoration: ShapeDecoration(
                                shape: StarBorder(), color: Colors.white),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
