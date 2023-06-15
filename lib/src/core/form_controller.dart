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
  Completer<void> _initCompleter = Completer();
  final Set<InputFormState> _states = {
    InputFormState.pristine,
    InputFormState.untouched,
  };
  final Map<Object, InputFieldError> _errors = {};

  Map<Object, InputFieldError> get errors => Map.unmodifiable(_errors);

  Iterable<Object> get tags => _fields.keys;

  Set<InputFormState> get states => Set.unmodifiable(_states);

  Map<Object, Object?> get values {
    return Map.fromEntries(
      _fields.entries.map((e) => MapEntry(e.key, e.value.value)),
    );
  }

  void _setError(InputFieldError error) {
    _errors[error.tag] = error;
  }

  Future<FieldController<T>> call<T extends Object>(Object tag) async {
    await _initCompleter.future;
    return getField(tag);
  }

  bool contains(Set<InputFormState> states) {
    return _states.intersection(states).isNotEmpty;
  }

  FieldController<T> getField<T extends Object>(Object tag) {
    assert(
      _fields.containsKey(tag),
      'Field "$tag" not bound to FormController with tags: ${tags.join(', ')}.',
    );
    return _fields[tag]! as FieldController<T>;
  }

  T? getValue<T extends Object>(Object tag) {
    return getField(tag).value as T?;
  }

  bool validate({Set<Object>? tags, bool notify = true}) {
    final fields = tags == null ? _fields.values : tags.map(getField);

    var isFormValid = true;
    for (final field in fields) {
      if (!field.validate(notify: notify)) isFormValid = false;
    }

    _setValidity(isValid: isFormValid);
    if (!isFormValid) notifyListeners();
    return isFormValid;
  }

  void remove(Object tag) => _fields.remove(tag);

  void reset() {
    _fields.clear();
    _initCompleter = Completer();
    _states.clear();
    _errors.clear();

    for (final field in _fields.values) {
      field.dispose();
    }
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }

  @internal
  void initialize(Duration timestamp) {
    if (!_initCompleter.isCompleted) _initCompleter.complete();
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
