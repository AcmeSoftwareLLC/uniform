part of 'form_controller.dart';

abstract interface class InputFieldValidator {
  const factory InputFieldValidator.required([
    String message,
  ]) = _RequiredInputFieldValidator;

  InputFieldError resolve(covariant Object? value);
}

class _RequiredInputFieldValidator implements InputFieldValidator {
  const _RequiredInputFieldValidator([
    this.message = 'This field is required.',
  ]);

  final String message;

  @override
  InputFieldError resolve(Object? value) {
    if (value == null || value is String && value.isEmpty) {
      return InputFieldError(message);
    }

    return InputFieldError.none();
  }
}
