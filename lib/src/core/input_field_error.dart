part of 'form_controller.dart';

class InputFieldError {
  InputFieldError([this.message]);

  factory InputFieldError.none() = _NoInputFieldError;

  final String? message;

  Object get tag => _tag;

  // ignore: prefer_final_fields
  Object _tag = Object();
}

class _NoInputFieldError extends InputFieldError {}
