part of 'form_controller.dart';

abstract class _FormControllerBase extends ChangeNotifier {
  _FormControllerBase({
    Set<InputFieldValidator> validators = const {},
    String? debugLabel,
  })  : _validators = validators,
        _debugLabel = debugLabel;

  final Map<Object, _FieldControllerBase> _fields = {};
  final Set<InputFieldValidator> _validators;
  final Set<InputFormState> _states = {
    InputFormState.pristine,
    InputFormState.untouched,
  };
  final Map<Object, InputFieldError> _errors = {};
  final Set<Object> _activeTags = {};

  /// A debug label that is used for diagnostic output.
  ///
  /// Will always return null in release builds.
  String? get debugLabel => _debugLabel;
  String? _debugLabel;
  set debugLabel(String? value) {
    assert(
      () {
        _debugLabel = value;
        return true;
      }(),
      'Only set the value in debug builds.',
    );
  }

  /// The current [errors] of this form.
  Map<Object, InputFieldError> get errors => Map.unmodifiable(_errors);

  /// All the field [tags] bound to this form.
  Set<Object> get tags => Set.unmodifiable(_fields.keys);

  /// All the field [tags] active in the form.
  Set<Object> get activeTags => Set.unmodifiable(_activeTags);

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

  /// Gets the [FieldController] bound with the [tag].
  FieldController<T> call<T extends Object>(Object tag);

  /// Gets the [FieldController] bound with the [tag].
  FieldController<T>? getField<T extends Object>(Object tag);

  /// Returns true if the form states contains any of the [states].
  bool contains(Set<InputFormState> states);

  /// Gets the value of the field bound with the [tag].
  T? getValue<T extends Object>(Object tag);

  /// Validates the form.
  ///
  /// Only the fields that are currently bound to UI are validated.
  /// If non-UI fields are to be validated as well,
  /// [activate] method can be used.
  /// Similarly to ignore validation of non-UI fields [deactivate] can be used.
  ///
  /// If [tags] is not null,
  /// only the fields with the given [tags] will be validated.
  /// If [notify] is true,
  /// the form will notify its listeners if the form is invalid.
  /// If [focusOnError] is true,
  /// the first field that is invalid will be focused.
  bool validate({
    Set<Object>? tags,
    bool notify = true,
    bool focusOnError = true,
  });

  /// Sets the field bound with the [tag] as active.
  void activate(Object tag);

  /// Sets the field bound with the [tag] as inactive.
  void deactivate(Object tag);

  /// Removes the field bound with the [tag].
  void remove(Object tag);

  /// Resets the form to initial state.
  void reset();

  /// Sets the value for [isSubmitted] of the form and each field.
  // ignore: avoid_positional_boolean_parameters
  void setSubmitted(bool isSubmitted);

  /// Sets the initial values for the form.
  ///
  /// If [notify] is true, each field will be notified with the initial value.
  void setInitialValues(
    Map<Object, Object?> initialValues, {
    bool notify = true,
  });

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

  void _setError(InputFieldError error) {
    _errors[error.tag] = error;
  }

  @override
  String toString() => 'FormController[$debugLabel]: ${tags.join(', ')}';
}
