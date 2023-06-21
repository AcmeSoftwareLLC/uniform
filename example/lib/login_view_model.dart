// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:uniform/uniform.dart';
import 'package:uniform_example/login_page.dart';
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
    _initFieldControllers();
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

  Future<void> _initFieldControllers() async {
    TextFieldController.create(formController, tag: LoginFormTags.email)
      ..setValidators({const EmailInputFieldValidator()})
      ..setValue('sales@acme-software.com');
    TextFieldController.create(formController, tag: LoginFormTags.password)
        .setValidators({const PasswordInputFieldValidator()});
    FieldController<Gender>.create(formController, tag: LoginFormTags.gender);
    FieldController<bool>.create(
      formController,
      tag: LoginFormTags.rememberMe,
    ).setValue(false);
  }
}
