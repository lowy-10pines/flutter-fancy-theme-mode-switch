import 'package:desafio_ui/utils/inherited_animacion.dart';
import 'package:desafio_ui/widgets/estrellas.dart';
import 'package:desafio_ui/widgets/nube.dart';
import 'package:desafio_ui/widgets/sol_y_luna.dart';
import 'package:flutter/material.dart';

class FancySwitch extends StatefulWidget {
  final void Function(bool)? onChanged;
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
    duration: const Duration(milliseconds: 1000),
  );

  Animation<double> get curvedAnimation => CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuint,
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
            curvedAnimation,
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

class FondoDeColor extends StatelessWidget {
  final Widget child;
  const FondoDeColor({super.key, required this.child});

  DecorationTween get backgroundAnimationTween => DecorationTween(
        begin: const BoxDecoration(color: Color(0xFF050357)),
        end: const BoxDecoration(color: Color(0xFFB3E5FC)),
      );

  @override
  Widget build(BuildContext context) {
    return DecoratedBoxTransition(
      decoration: backgroundAnimationTween.animate(Animacion.of(context)),
      child: child,
    );
  }
}
