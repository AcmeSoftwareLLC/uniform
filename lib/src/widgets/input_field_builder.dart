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
  late final FormController _form;

  @override
  void initState() {
    super.initState();
    _form = InputForm.controllerOf(context)..activate(widget.tag);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _form.getField<T>(widget.tag);

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) => widget.builder(context, controller, child),
      child: widget.child,
    );
  }

  @override
  void deactivate() {
    _form.deactivate(widget.tag);
    super.deactivate();
  }
}
