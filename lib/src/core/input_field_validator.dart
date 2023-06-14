part of 'form_controller.dart';

abstract interface class InputFieldValidator {
  InputFieldError resolve(covariant Object? value);
}

class RequiredInputFieldValidator implements InputFieldValidator {
  const RequiredInputFieldValidator();

  @override
  InputFieldError resolve(String? value) {
    if (value == null || value.isEmpty) {
      return const InputFieldError('This field is required');
    }

    return const InputFieldError.none();
  }
}
