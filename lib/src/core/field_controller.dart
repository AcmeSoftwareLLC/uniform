part of 'form_controller.dart';

class FieldController<T extends Object> extends ChangeNotifier {
  FieldController({
    required this.tag,
    required this.parent,
    this.initialValue,
  }) {
    parent._fields[tag] = this;

    _value = initialValue;
    _validators = parent._validators;
  }

  final Object tag;
  final FormController parent;
  final T? initialValue;
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

  void setValue(T? value) {
    _value = value;
    if (_lastErrorValue != _value) setError(const InputFieldError.none());

    notifyListeners();
  }

  void setError(InputFieldError error) {
    _error = error;
    _lastErrorValue = _value;

    notifyListeners();
  }

  bool validate() {
    for (final validator in _validators) {
      final error = validator.resolve(_value);
      setError(error);

      if (error is! _NoInputFieldError) return false;
    }

    return true;
  }

  @override
  String toString() {
    return 'FieldController[$tag]: $value';
  }
}
