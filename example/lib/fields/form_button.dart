// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:uniform/uniform.dart';

class FormButton extends StatelessWidget {
  const FormButton({required this.onPressed, required this.child, super.key});

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return UniformBuilder(
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
