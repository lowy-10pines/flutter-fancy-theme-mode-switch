import 'dart:math';

import 'package:flutter/material.dart';

/// Flutter code sample for [DecoratedBoxTransition].

void main() => runApp(const DecoratedBoxTransitionExampleApp());

class DecoratedBoxTransitionExampleApp extends StatelessWidget {
  const DecoratedBoxTransitionExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ColoredBox(
          color: Colors.white,
          child: Center(child: DecoratedBoxTransitionExample())),
    );
  }
}

class DecoratedBoxTransitionExample extends StatefulWidget {
  const DecoratedBoxTransitionExample({super.key});

  @override
  State<DecoratedBoxTransitionExample> createState() =>
      _DecoratedBoxTransitionExampleState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _DecoratedBoxTransitionExampleState
    extends State<DecoratedBoxTransitionExample> with TickerProviderStateMixin {
  final DecorationTween _decorationsTween = DecorationTween(
    begin: const ShapeDecoration(
      color: Colors.white,
      shape: CircleBorder(),
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

  final AlignmentTween _alignmentTween = AlignmentTween(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  final DecorationTween _backgroundAnimationTween = DecorationTween(
    begin: BoxDecoration(
      borderRadius: BorderRadius.circular(150),
      color: Colors.black,
    ),
    end: BoxDecoration(
      borderRadius: BorderRadius.circular(150),
      color: Colors.lightBlue.shade100,
    ),
  );

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  late final CurvedAnimation _curvedAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  late final CurvedAnimation _expoCurvedAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 300,
      child: DecoratedBoxTransition(
        decoration: _backgroundAnimationTween.animate(_curvedAnimation),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: AlignTransition(
            alignment: _alignmentTween.animate(_curvedAnimation),
            child: DecoratedBoxTransition(
              decoration: _decorationsTween.animate(_curvedAnimation),
              child: ClipOval(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
