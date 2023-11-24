// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:uniform/src/core/form_controller.dart';
import 'package:uniform/src/widgets/input_form.dart';

/// A widget builder that receives a [FormController].
typedef UniformWidgetBuilder<T extends Object> = Widget Function(
  BuildContext,
  T,
  Widget?,
);

/// A widget for building a widget subtree when a [FormController] changes.
class UniformBuilder extends StatelessWidget {
  const UniformBuilder({
    required this.builder,
    this.child,
    super.key,
  });

  /// The widget builder.
  final UniformWidgetBuilder<FormController> builder;

  /// The widget below this widget in the tree.
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
