part of 'form_controller.dart';

class InputFieldError {
  const InputFieldError(this.message);

  const factory InputFieldError.none() = _NoInputFieldError;

  final String? message;
}

class _NoInputFieldError extends InputFieldError {
  const _NoInputFieldError() : super(null);
}
