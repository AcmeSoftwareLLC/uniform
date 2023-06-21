// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:uniform/src/core/form_controller.dart';

class InputForm extends StatefulWidget {
  const InputForm({
    required this.controller,
    required this.child,
    this.onError,
    super.key,
  });

  final FormController controller;
  final Widget child;
  final ValueChanged<Map<Object, InputFieldError>>? onError;

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
  void dispose() {
    _controller.reset();
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
