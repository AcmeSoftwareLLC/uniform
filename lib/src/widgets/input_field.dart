import 'package:flutter/widgets.dart';
import 'package:uniform/src/core/form_controller.dart';
import 'package:uniform/src/widgets/input_form.dart';

class InputField<T extends Object> extends StatefulWidget {
  const InputField({
    required this.tag,
    required this.builder,
    this.child,
    super.key,
  });

  final Object tag;
  final Widget Function(BuildContext, FieldController<T>, Widget?) builder;
  final Widget? child;

  @override
  State<InputField<T>> createState() => _InputFieldState<T>();
}

class _InputFieldState<T extends Object> extends State<InputField<T>> {
  FieldController<T>? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= FieldController(
      tag: widget.tag,
      parent: InputForm.controllerOf(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller!,
      builder: (context, child) => widget.builder(context, _controller!, child),
      child: widget.child,
    );
  }
}
