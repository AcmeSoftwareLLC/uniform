// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:uniform/src/core/form_controller.dart';
import 'package:uniform/src/widgets/input_form.dart';

class TextInputFieldBuilder extends StatefulWidget {
  const TextInputFieldBuilder({
    required this.tag,
    required this.builder,
    super.key,
  });

  final Object tag;
  final Widget Function(
    BuildContext,
    TextFieldController,
    TextEditingController,
  ) builder;

  @override
  State<TextInputFieldBuilder> createState() => _TextInputFieldBuilderState();
}

class _TextInputFieldBuilderState extends State<TextInputFieldBuilder> {
  late TextFieldController _controller;
  late final TextEditingController _textController;
  late final FormController _form;

  @override
  void initState() {
    super.initState();
    _form = InputForm.controllerOf(context)..activate(widget.tag);

    final controller = _form<String>(widget.tag);
    assert(
      controller is TextFieldController,
      'The controller for tag '
      '"${widget.tag}" must be a TextFieldController.',
    );

    _controller = controller as TextFieldController;

    _textController = TextEditingController(text: _controller.value);
    _controller.addListener(_updateTextEditingValue);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return widget.builder(context, _controller, _textController);
      },
    );
  }

  @override
  void deactivate() {
    _form.deactivate(widget.tag);
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.removeListener(_updateTextEditingValue);
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(_controller.toDiagnosticsNode());
    super.debugFillProperties(properties);
  }

  void _updateTextEditingValue() {
    final text = _controller.value ?? '';

    if (_controller.isIMEInput) {
      _textController.value = _textController.value.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    } else {
      _textController.value = _textController.value.copyWith(text: text);
    }
  }
}
