// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'form_controller.dart';

/// The validator of a field.
abstract interface class InputFieldValidator {
  /// Creates a validator that validates if the field has data.
  const factory InputFieldValidator.required([
    String message,
  ]) = _RequiredInputFieldValidator;

  /// Resolves the error of the field.
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
