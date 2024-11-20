// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:uniform/src/core/input_form_state.dart';

part 'field_controller.dart';
part 'field_controller_base.dart';
part 'form_controller_base.dart';
part 'input_field_error.dart';
part 'input_field_validator.dart';

/// A controller for a form.
class FormController extends _FormControllerBase with Diagnosticable {
  /// Creates an instance of [FormController].
  FormController({super.validators, super.debugLabel});

  @override
  FieldController<T>? getField<T extends Object>(Object tag) {
    return _fields[tag] as FieldController<T>?;
  }

  @override
  FieldController<T> call<T extends Object>(Object tag) {
    final field = getField<T>(tag);

    assert(
      field != null,
      'Field "$tag" not bound to FormController with tags: ${tags.join(', ')}.',
    );
    return field!;
  }

  @override
  bool contains(Set<InputFormState> states) {
    return _states.intersection(states).isNotEmpty;
  }

  @override
  T? getValue<T extends Object>(Object tag) {
    return getField(tag)?.value as T?;
  }

  @override
  bool validate({
    Set<Object>? tags,
    bool notify = true,
    bool focusOnError = true,
  }) {
    final fields = (tags ?? _activeTags).map(call);

    var isFormValid = true;
    for (final field in fields) {
      if (!field.validate(notify: notify)) {
        if (focusOnError && isFormValid) field.requestFocus();
        isFormValid = false;
      }
    }

    _setValidity(isValid: isFormValid);
    if (!isFormValid) notifyListeners();
    return isFormValid;
  }

  @override
  void activate(Object tag) => _activeTags.add(tag);

  @override
  void deactivate(Object tag) => _activeTags.remove(tag);

  @override
  void remove(Object tag) {
    final controller = _fields.remove(tag);
    _activeTags.remove(tag);
    _errors.remove(tag);

    controller?.dispose();
  }

  @override
  void reset() {
    for (final field in _fields.values) {
      field.reset();
    }

    _states
      ..clear()
      ..addAll({InputFormState.pristine, InputFormState.untouched});
    _errors.clear();
  }

  @override
  void dispose() {
    for (final field in _fields.values) {
      field.dispose();
    }
    _fields.clear();
    super.dispose();
  }

  @override
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

  @override
  void setInitialValues(
    Map<Object, Object?> initialValues, {
    bool notify = true,
  }) {
    for (final entry in initialValues.entries) {
      call(entry.key).setInitialValue(entry.value, notify: notify);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(StringProperty('name', debugLabel, defaultValue: null))
      ..add(IterableProperty<Object>('tags', tags))
      ..add(IterableProperty<Object>('activeTags', activeTags))
      ..add(IterableProperty<Object>('states', states));
    super.debugFillProperties(properties);
  }

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) {
    return DiagnosticableNode(
      name: name ?? 'controller',
      value: this,
      style: style ?? DiagnosticsTreeStyle.sparse,
    );
  }
}
