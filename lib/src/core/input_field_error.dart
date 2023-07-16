// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of 'form_controller.dart';

/// The error of a field.
class InputFieldError {
  /// Creates an instance of [InputFieldError].
  InputFieldError([this.message]);

  /// Creates an instance of [InputFieldError] with no error.
  factory InputFieldError.none() = _NoInputFieldError;

  /// The error message.
  final String? message;

  /// The tag of the field that this error is bound to.
  Object get tag => _tag;

  // ignore: prefer_final_fields
  Object _tag = Object();

  @override
  String toString() => message ?? super.toString();
}

class _NoInputFieldError extends InputFieldError {}
