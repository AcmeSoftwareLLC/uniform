part of 'form_controller.dart';

abstract class _FieldControllerBase<T extends Object> extends ChangeNotifier {
  /// Creates an instance of [FieldController].
  _FieldControllerBase._({
    required this.tag,
    required this.parent,
    this.autoValidate = false,
  }) {
    parent._fields[tag] = this;

    _validators = parent._validators;
  }

  /// The tag of this field.
  ///
  /// This must be unique within the parent [FormController].
  final Object tag;

  /// The parent [FormController] of this field.
  final FormController parent;

  /// Whether this field should be automatically validated.
  final bool autoValidate;

  late Set<InputFieldValidator> _validators;

  T? _initialValue;
  T? _value;
  T? _lastErrorValue;
  bool _isSubmitted = false;
  InputFieldError _error = InputFieldError.none();

  T? get value => _value;

  /// The current error of this field.
  InputFieldError get error => _error;

  /// Returns true if the field has been modified.
  bool get isDirty => _value != _initialValue;

  /// Returns true if the field has been submitted with [setSubmitted].
  bool get isSubmitted => _isSubmitted;

  /// Sets the [validators] for the field.
  void setValidators(Set<InputFieldValidator> validators);

  /// Sets the initial [value] of the field.
  ///
  /// Setting value does not make the field dirty.
  /// Use [setValue] to set the value and make the field dirty.
  void setInitialValue(T? value, {bool notify = false});

  /// Sets the [value] of the field.
  ///
  /// This should be used while programmatically setting the value of the field.
  /// If [notify] is true, this will notify listeners.
  ///
  /// For setting the value using field components, use [onChanged].
  /// For setting the value,
  /// without making the field dirty use [setInitialValue].
  void setValue(T? value, {bool notify = true});

  /// Sets the [error] of the field.
  ///
  /// If [notify] is true, this will notify listeners.
  void setError(InputFieldError error, {bool notify = true});

  /// Sets the [value] for [isSubmitted] of the field.
  // ignore: avoid_positional_boolean_parameters
  void setSubmitted(bool value);

  /// Sets the [value] of the field.
  ///
  /// This should be used while changing the value using field components.
  /// If [notify] is true, this will notify listeners.
  ///
  /// For setting the value programmatically, use [setValue].
  void onChanged(T? value, {bool notify = true});

  /// Validates the field.
  ///
  /// If [notify] is true, this will notify listeners.
  bool validate({bool notify = true});

  /// Callback for listening to changes in the field.
  void onUpdate(void Function(T? value) listener);

  /// Resets the field to its initial value.
  void reset();
}
