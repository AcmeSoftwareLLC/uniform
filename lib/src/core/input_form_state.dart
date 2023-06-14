enum InputFormState {
  /// The field has not been modified yet.
  pristine,

  /// The field has not been modified yet.
  dirty,

  /// The field has not been touched yet.
  untouched,

  /// The field has been touched.
  touched,

  /// The field content is not valid.
  invalid,

  /// The field content is valid.
  valid,
}
