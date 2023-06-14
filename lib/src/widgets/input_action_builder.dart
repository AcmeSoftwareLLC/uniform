import 'package:flutter/material.dart';
import 'package:uniform/src/core/form_controller.dart';
import 'package:uniform/src/widgets/input_form.dart';

class InputActionBuilder extends StatelessWidget {
  const InputActionBuilder({required this.builder, this.child, super.key});

  final Widget Function(BuildContext, FormController, Widget?) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final controller = InputForm.controllerOf(context);

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) => builder(context, controller, child),
      child: child,
    );
  }
}
