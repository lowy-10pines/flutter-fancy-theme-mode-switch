import 'package:desafio_ui/widgets/fancy_switch.dart';
import 'package:flutter/material.dart';

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
  void onTap(bool newValue) {
    setState(() {
      value = newValue;
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
                Switch(value: value, onChanged: onTap),
                FancySwitch(value: value, onChanged: onTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
