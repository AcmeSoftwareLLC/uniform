// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'form_controller.dart';

/// The validator of a field.
abstract interface class InputFieldValidator {
  /// Creates a validator that validates the field.
  const factory InputFieldValidator(
    String? Function(Object? value) validator,
  ) = _InputFieldValidator;

  /// Creates a validator that validates if the field has data.
  const factory InputFieldValidator.required([
    String message,
  ]) = _RequiredInputFieldValidator;

  /// Resolves the error of the field.
  InputFieldError resolve(covariant Object? value);
}

@immutable
class _InputFieldValidator implements InputFieldValidator {
  const _InputFieldValidator(this.validator);

  final String? Function(Object? value) validator;

  @override
  InputFieldError resolve(Object? value) {
    final message = validator(value);

    if (message == null) return InputFieldError.none();
    return InputFieldError(message);
  }

  String get _name => '_InputFieldValidator';

  @override
  int get hashCode => _name.hashCode;

  @override
  bool operator ==(Object other) => other is _InputFieldValidator;
}

@immutable
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

  String get _name => 'RequiredInputFieldValidator';

  @override
  int get hashCode => _name.hashCode;

  @override
  bool operator ==(Object other) => other is _RequiredInputFieldValidator;
}
