// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:uniform/src/core/form_controller.dart';
import 'package:uniform/src/widgets/input_form.dart';

typedef UniformWidgetBuilder<T extends Object> = Widget Function(
  BuildContext,
  T,
  Widget?,
);

class UniformBuilder extends StatelessWidget {
  const UniformBuilder({
    required this.builder,
    this.child,
    super.key,
  });

  final UniformWidgetBuilder<FormController> builder;
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

@Deprecated('Use UniformBuilder instead.')
typedef InputActionBuilder = UniformBuilder;
