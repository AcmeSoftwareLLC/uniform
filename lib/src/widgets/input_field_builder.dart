// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:uniform/src/core/form_controller.dart';
import 'package:uniform/src/widgets/input_form.dart';

class InputFieldBuilder<T extends Object> extends StatefulWidget {
  const InputFieldBuilder({
    required this.tag,
    required this.builder,
    this.child,
    this.initialValue,
    this.autoValidate = false,
    super.key,
  });

  final Object tag;
  final Widget Function(BuildContext, FieldController<T>, Widget?) builder;
  final Widget? child;
  final T? initialValue;
  final bool autoValidate;

  @override
  State<InputFieldBuilder<T>> createState() => _InputFieldBuilderState<T>();
}

class _InputFieldBuilderState<T extends Object>
    extends State<InputFieldBuilder<T>> {
  FieldController<T>? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller ??= _buildController();
  }

  @override
  void didUpdateWidget(InputFieldBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tag != widget.tag) {
      _controller!.parent.remove(oldWidget.tag);
      _controller = _buildController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller!,
      builder: (context, child) => widget.builder(context, _controller!, child),
      child: widget.child,
    );
  }

  FieldController<T> _buildController() {
    return FieldController(
      tag: widget.tag,
      parent: InputForm.controllerOf(context),
      initialValue: widget.initialValue,
      autoValidate: widget.autoValidate,
    );
  }
}
