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
class FieldController<T extends Object> extends ChangeNotifier {
  /// Creates an instance of [FieldController].
  FieldController._({
    required this.tag,
    required this.parent,
    this.initialValue,
    this.autoValidate = false,
  }) {
    parent._fields[tag] = this;

    _value = initialValue;
    _validators = parent._validators;
  }

  /// Creates an instance of [FieldController] if not attached to the [parent].
  factory FieldController.create(
    FormController parent, {
    required Object tag,
    T? initialValue,
    bool autoValidate = false,
  }) {
    return parent._fields[tag] as FieldController<T>? ??
        FieldController._(
          tag: tag,
          parent: parent,
          initialValue: initialValue,
          autoValidate: autoValidate,
        );
  }

  /// The tag of this field.
  ///
  /// This must be unique within the parent [FormController].
  final Object tag;

  /// The parent [FormController] of this field.
  final FormController parent;

  /// The initial value of this field.
  final T? initialValue;

  /// Whether this field should be automatically validated.
  final bool autoValidate;

  late Set<InputFieldValidator> _validators;

  T? _value;
  T? _lastErrorValue;
  bool _isSubmitted = false;
  InputFieldError _error = InputFieldError.none();

  T? get value => _value;

  /// The current error of this field.
  InputFieldError get error => _error;

  /// Returns true if the field has been modified.
  bool get isDirty => _value != initialValue;

  /// Returns true if the field has been submitted with [setSubmitted].
  bool get isSubmitted => _isSubmitted;

  /// Sets the [validators] for the field.
  void setValidators(Set<InputFieldValidator> validators) {
    _validators = parent._validators.union(validators);
  }

  /// Sets the [value] of the field.
  ///
  /// This should be used while programmatically setting the value of the field.
  /// If [notify] is true, this will notify listeners.
  ///
  /// For setting the value using field components, use [onChanged].
  void setValue(T? value, {bool notify = true}) {
    parent._setDirty();
    _value = value;

    if (_value != null && autoValidate) validate();
    if (_lastErrorValue != _value) setError(InputFieldError.none());
    if (notify) notifyListeners();
  }

  /// Sets the [error] of the field.
  ///
  /// If [notify] is true, this will notify listeners.
  void setError(InputFieldError error, {bool notify = true}) {
    _error = error;
    _lastErrorValue = _value;

    if (notify) notifyListeners();
  }

  /// Sets the [value] for [isSubmitted] of the field.
  // ignore: avoid_positional_boolean_parameters
  void setSubmitted(bool value) {
    _isSubmitted = value;
    notifyListeners();
  }

  /// Sets the [value] of the field.
  ///
  /// This should be used while changing the value using field components.
  /// If [notify] is true, this will notify listeners.
  ///
  /// For setting the value programmatically, use [setValue].
  void onChanged(T? value, {bool notify = true}) {
    parent._setTouched();
    setValue(value, notify: notify);
  }

  /// Validates the field.
  ///
  /// If [notify] is true, this will notify listeners.
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
    super.initialValue,
    super.autoValidate,
  }) : super._();

  factory TextFieldController.create(
    FormController parent, {
    required Object tag,
    String? initialValue,
    bool autoValidate = false,
  }) {
    return parent._fields[tag] as TextFieldController? ??
        TextFieldController._(
          tag: tag,
          parent: parent,
          initialValue: initialValue,
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
