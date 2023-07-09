// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'form_controller.dart';

/// A controller for a single field in a [FormController].
///
/// See also:
///
///  * [TextFieldController], which is similar to [FieldController]
///  but can be used to handle text input more gracefully.
class FieldController<T extends Object> extends _FieldControllerBase<T> {
  /// Creates an instance of [FieldController].
  FieldController._({
    required super.tag,
    required super.parent,
    super.autoValidate = false,
  }) : super._();

  /// Creates an instance of [FieldController] if not attached to the [parent].
  factory FieldController.create(
    FormController parent, {
    required Object tag,
    bool autoValidate = false,
  }) {
    final field = parent._fields[tag] as FieldController<T>?;
    return field ??
        FieldController._(
          tag: tag,
          parent: parent,
          autoValidate: autoValidate,
        );
  }

  @override
  void setValidators(Set<InputFieldValidator> validators) {
    _validators = parent._validators.union(validators);
  }

  @override
  void setInitialValue(T? value, {bool notify = false}) {
    _initialValue = value;
    setValue(value, notify: notify);
  }

  @override
  void setValue(T? value, {bool notify = true}) {
    parent._setDirty();
    _value = value;

    if (_value != null && autoValidate) validate();
    if (_lastErrorValue != _value) setError(InputFieldError.none());
    if (notify) notifyListeners();
  }

  @override
  void setError(InputFieldError error, {bool notify = true}) {
    _error = error;
    _lastErrorValue = _value;

    if (notify) notifyListeners();
  }

  @override
  void setSubmitted(bool value) {
    _isSubmitted = value;
    notifyListeners();
  }

  @override
  void onChanged(T? value, {bool notify = true}) {
    parent._setTouched();
    setValue(value, notify: notify);
  }

  @override
  bool validate({bool notify = true}) {
    for (final validator in _validators) {
      final error = validator.resolve(_value).._tag = tag;
      setError(error, notify: notify);
      parent._setError(error);

      if (error is! _NoInputFieldError) return false;
    }

    return true;
  }

  @override
  void onUpdate(void Function(T? value) listener) {
    addListener(() => listener(value));
  }

  @override
  void reset() {
    _value = _initialValue;
    _lastErrorValue = null;
    _isSubmitted = false;
    _error = InputFieldError.none();
  }

  @override
  String toString() => 'FieldController[$tag]: $value';
}

/// A controller for a single [String] field in a [FormController].
///
/// See also:
///
///  * [FieldController], which is generic controller that support any type.
class TextFieldController extends FieldController<String> {
  TextFieldController._({
    required super.tag,
    required super.parent,
    super.autoValidate,
  }) : super._();

  factory TextFieldController.create(
    FormController parent, {
    required Object tag,
    bool autoValidate = false,
  }) {
    return parent._fields[tag] as TextFieldController? ??
        TextFieldController._(
          tag: tag,
          parent: parent,
          autoValidate: autoValidate,
        );
  }

  bool _isIMEInput = false;

  /// Returns true if the field has been modified by an Input Method.
  bool get isIMEInput => _isIMEInput;

  @override
  void setValue(String? value, {bool notify = true}) {
    _isIMEInput = false;
    super.setValue(value, notify: notify);
  }

  @override
  void onChanged(String? value, {bool notify = false}) {
    _isIMEInput = true;
    super.onChanged(value, notify: notify);
  }
}
