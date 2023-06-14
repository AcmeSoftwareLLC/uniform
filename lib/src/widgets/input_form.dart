import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:uniform/src/core/form_controller.dart';

class InputForm extends StatefulWidget {
  const InputForm({
    required this.child,
    this.controller,
    this.onError,
    super.key,
  });

  final Widget child;
  final FormController? controller;
  final ValueChanged<Map<Object, InputFieldError>>? onError;

  static FormController controllerOf(
    BuildContext context,
  ) {
    final result =
        context.dependOnInheritedWidgetOfExactType<_InputFormScope>();
    assert(result != null, 'No InputForm found in context');
    return result!.controller;
  }

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  late final FormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? FormController();
    SchedulerBinding.instance.addPostFrameCallback(_controller.initialize);

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
    _controller.dispose();
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
