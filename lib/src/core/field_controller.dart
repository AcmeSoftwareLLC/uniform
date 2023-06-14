part of 'form_controller.dart';

class FieldController<T extends Object> extends ChangeNotifier {
  FieldController({
    required this.tag,
    required this.parent,
    this.initialValue,
    this.autoValidate = false,
  }) {
    parent._fields[tag] = this;

    _value = initialValue;
    _validators = parent._validators;
  }

  final Object tag;
  final FormController parent;
  final T? initialValue;
  final bool autoValidate;
  late Set<InputFieldValidator> _validators;

  T? _value;
  T? _lastErrorValue;
  InputFieldError _error = const InputFieldError.none();

  T? get value => _value;

  InputFieldError get error => _error;

  bool get isDirty => _value != initialValue;

  void setValidators(Set<InputFieldValidator> validators) {
    _validators = parent._validators.union(validators);
  }

  void setValue(T? value, {bool notify = true}) {
    parent._setDirty();
    _value = value;

    if (_value != null && autoValidate) validate();
    if (_lastErrorValue != _value) setError(const InputFieldError.none());
    if (notify) notifyListeners();
  }

  void setError(InputFieldError error, {bool notify = true}) {
    _error = error;
    _lastErrorValue = _value;

    if (notify) notifyListeners();
  }

  void onChanged(T? value, {bool notify = true}) {
    parent._setTouched();
    setValue(value, notify: notify);
  }

  bool validate({bool notify = true}) {
    for (final validator in _validators) {
      final error = validator.resolve(_value);
      setError(error, notify: notify);

      if (error is! _NoInputFieldError) return false;
    }

    return true;
  }

  @override
  String toString() {
    return 'FieldController[$tag]: $value';
  }
}

class TextFieldController extends FieldController<String> {
  TextFieldController({
    required super.tag,
    required super.parent,
    super.initialValue,
    super.autoValidate,
  });

  bool _isIMEInput = false;

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
