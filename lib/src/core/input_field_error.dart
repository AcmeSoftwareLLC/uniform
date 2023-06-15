// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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
