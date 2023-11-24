// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:uniform/src/core/form_controller.dart';

/// A widget that provides a [FormController] to its descendants.
class InputForm extends StatefulWidget {
  /// Creates an instance of [InputForm].
  const InputForm({
    required this.controller,
    required this.child,
    this.onError,
    this.autoReset = true,
    super.key,
  });

  /// The [FormController] to provide to descendants.
  final FormController controller;

  /// The widget below this widget in the tree.
  final Widget child;

  /// A callback that is called when the form has errors.
  final ValueChanged<Map<Object, InputFieldError>>? onError;

  /// Whether to automatically reset the form when it is disposed.
  final bool autoReset;

  /// Returns the [FormController] provided by the nearest ancestor [InputForm].
  static FormController controllerOf(
    BuildContext context,
  ) {
    final scope = context.getInheritedWidgetOfExactType<_InputFormScope>();
    assert(scope != null, 'No InputForm found in context');
    return scope!.controller;
  }

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  late final FormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;

    if (widget.onError != null) {
      _controller.addListener(() => widget.onError!(_controller.errors));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InputFormScope(
      controller: _controller,
      child: widget.child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(_controller.toDiagnosticsNode());
    super.debugFillProperties(properties);
  }

  @override
  void dispose() {
    if (widget.autoReset) _controller.reset();
    super.dispose();
  }
}

class _InputFormScope extends InheritedWidget {
  const _InputFormScope({
    required this.controller,
    required super.child,
  });

  final FormController controller;

  @override
  bool updateShouldNotify(_InputFormScope old) => false;
}
