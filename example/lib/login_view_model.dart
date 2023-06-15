// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:uniform/uniform.dart';
import 'package:uniform_example/validators/email_input_field_validator.dart';
import 'package:uniform_example/validators/password_input_field_validator.dart';

enum LoginFormTags {
  email,
  password,
  gender,
  rememberMe,
}

class LoginViewModel extends ChangeNotifier {
  LoginViewModel() {
    formController = FormController(
      validators: {const InputFieldValidator.required()},
    );
    _initValidators();
  }

  late final FormController formController;

  Map<Object, Object?> _userData = {};

  Map<Object, Object?> get userData => _userData;

  Future<void> login() async {
    if (formController.validate()) {
      formController.setSubmitted(true);

      // Simulates login
      await Future<void>.delayed(const Duration(seconds: 2));

      _userData = formController.values;
      notifyListeners();

      formController.setSubmitted(false);
    }
  }

  Future<void> _initValidators() async {
    final emailController = await formController(LoginFormTags.email);
    emailController
      ..setValidators({const EmailInputFieldValidator()})
      ..setValue('sales@acme-software.com');

    final passwordController = await formController(LoginFormTags.password);
    passwordController.setValidators({const PasswordInputFieldValidator()});
  }
}
