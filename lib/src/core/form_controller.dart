import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:uniform/src/core/input_form_state.dart';

part 'field_controller.dart';
part 'input_field_error.dart';
part 'input_field_validator.dart';

class FormController extends ChangeNotifier {
  FormController({
    Set<InputFieldValidator> validators = const {},
  }) : _validators = validators;

  final Map<Object, FieldController> _fields = {};
  final Set<InputFieldValidator> _validators;
  final Completer<void> _initCompleter = Completer();
  final Set<InputFormState> _states = {
    InputFormState.pristine,
    InputFormState.untouched,
    InputFormState.valid,
  };

  Iterable<Object> get tags => _fields.keys;

  Set<InputFormState> get states => Set.unmodifiable(_states);

  Future<FieldController<T>> call<T extends Object>(Object tag) async {
    await _initCompleter.future;
    return _field(tag);
  }

  bool validate({Set<Object>? tags}) {
    final fields = tags == null ? _fields.values : tags.map(_field);

    var isFormValid = true;
    for (final field in fields) {
      if (!field.validate()) isFormValid = false;
    }

    _setValidity(isValid: isFormValid);
    return isFormValid;
  }

  void remove(Object tag) => _fields.remove(tag);

  @override
  void dispose() {
    for (final field in _fields.values) {
      field.dispose();
    }
    super.dispose();
  }

  @internal
  void initialize(Duration timestamp) => _initCompleter.complete();

  FieldController<T> _field<T extends Object>(Object tag) {
    assert(
      _fields.containsKey(tag),
      'Field "$tag" not bound to FormController with tags: ${tags.join(', ')}.',
    );
    return _fields[tag]! as FieldController<T>;
  }

  void _setDirty() {
    if (_states.contains(InputFormState.pristine)) {
      _states
        ..remove(InputFormState.pristine)
        ..add(InputFormState.dirty);
      notifyListeners();
    }
  }

  void _setTouched() {
    if (_states.contains(InputFormState.untouched)) {
      _states
        ..remove(InputFormState.untouched)
        ..add(InputFormState.touched);
      notifyListeners();
    }
  }

  void _setValidity({required bool isValid}) {
    if (isValid && _states.contains(InputFormState.invalid)) {
      _states
        ..remove(InputFormState.invalid)
        ..add(InputFormState.valid);
      notifyListeners();
    } else if (!isValid && _states.contains(InputFormState.valid)) {
      _states
        ..remove(InputFormState.valid)
        ..add(InputFormState.invalid);
      notifyListeners();
    }
  }
}
