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
    duration: const Duration(milliseconds: 500),
  );

  Animation<double> get curvedAnimation => CurvedAnimation(
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
  void didUpdateWidget(covariant FancySwitch oldWidget) {
    if (widget.value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    const double height = 40 * 5;
    const double width = 70 * 5;
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: GestureDetector(
          onTap: () {
            widget.onChanged?.call(!widget.value);
          },
          onPanUpdate: (details) {
            final recorrido = details.delta.dx;
            const espacio = width - height;
            _controller.value += recorrido / espacio;
          },
          onPanEnd: (details) {
            if (_controller.value < 0.5) {
              _controller.reverse(from: _controller.value);
              widget.onChanged?.call(false);
            } else {
              _controller.forward(from: _controller.value);
              widget.onChanged?.call(true);
            }
          },
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
