// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uniform/src/core/input_form_state.dart';

part 'field_controller.dart';
part 'input_field_error.dart';
part 'input_field_validator.dart';

/// A controller for a form.
class FormController extends ChangeNotifier {
  /// Creates an instance of [FormController].
  FormController({
    Set<InputFieldValidator> validators = const {},
  }) : _validators = validators;

  final Map<Object, FieldController> _fields = {};
  final Set<InputFieldValidator> _validators;
  final Set<InputFormState> _states = {
    InputFormState.pristine,
    InputFormState.untouched,
  };
  final Map<Object, InputFieldError> _errors = {};
  final Map<Object, Completer<void>> _fieldCompleter = {};

  /// The current [errors] of this form.
  Map<Object, InputFieldError> get errors => Map.unmodifiable(_errors);

  /// All the field [tags] bound to this form.
  Iterable<Object> get tags => _fields.keys;

  /// The current [states] of this form.
  Set<InputFormState> get states => Set.unmodifiable(_states);

  /// The current [values] of this form.
  Map<Object, Object?> get values {
    return Map.fromEntries(
      _fields.entries.map((e) => MapEntry(e.key, e.value.value)),
    );
  }

  /// Returns true if the form has been submitted.
  bool get isSubmitted => states.contains(InputFormState.submitted);

  void _setError(InputFieldError error) {
    _errors[error.tag] = error;
  }

  /// Gets the [FieldController] bound with the [tag].
  ///
  /// Waits for the form to be initialized if it hasn't been initialized yet.
  Future<FieldController<T>> call<T extends Object>(Object tag) async {
    if (!_fields.containsKey(tag)) {
      await _fieldCompleter.putIfAbsent(tag, Completer.new).future;
    }
    return getField(tag);
  }

  /// Returns true if the form states contains any of the [states].
  bool contains(Set<InputFormState> states) {
    return _states.intersection(states).isNotEmpty;
  }

  /// Gets the [FieldController] bound with the [tag].
  FieldController<T> getField<T extends Object>(Object tag) {
    assert(
      _fields.containsKey(tag),
      'Field "$tag" not bound to FormController with tags: ${tags.join(', ')}.',
    );
    return _fields[tag]! as FieldController<T>;
  }

  /// Gets the value of the field bound with the [tag].
  T? getValue<T extends Object>(Object tag) {
    return getField(tag).value as T?;
  }

  /// Validates the form.
  ///
  /// If [tags] is not null,
  /// only the fields with the given [tags] will be validated.
  /// If [notify] is true,
  /// the form will notify its listeners if the form is invalid.
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

  /// Removes the field bound with the [tag].
  void remove(Object tag) => _fields.remove(tag);

  /// Resets the form to initial state.
  void reset() {
    _fields.clear();
    _states
      ..clear()
      ..addAll({InputFormState.pristine, InputFormState.untouched});
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

  /// Sets the value for [isSubmitted] of the form and each field.
  // ignore: avoid_positional_boolean_parameters
  void setSubmitted(bool isSubmitted) {
    if (isSubmitted) {
      _states.add(InputFormState.submitted);
    } else {
      _states.remove(InputFormState.submitted);
    }

    for (final field in _fields.values) {
      field.setSubmitted(isSubmitted);
    }

    notifyListeners();
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
