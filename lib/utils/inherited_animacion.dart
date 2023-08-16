import 'package:flutter/material.dart';

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
