import 'package:flutter/material.dart';
import 'package:uniform/uniform.dart';

class FormButton extends StatelessWidget {
  const FormButton({required this.onPressed, required this.child, super.key});

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InputActionBuilder(
      builder: (context, controller, _) {
        final isEnabled = controller.contains({InputFormState.touched}) &&
            !controller.isSubmitted;

        return FilledButton(
          onPressed: isEnabled ? onPressed : null,
          child: controller.isSubmitted ? const Text('Submitting...') : child,
        );
      },
    );
  }
}
