// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:uniform/uniform.dart';

class PasswordInputFieldValidator implements InputFieldValidator {
  const PasswordInputFieldValidator();

  @override
  InputFieldError resolve(String value) {
    if (value.length < 8) {
      return InputFieldError('Password must be at least 8 characters.');
    }

    return InputFieldError.none();
  }
}
