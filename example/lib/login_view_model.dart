// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:uniform/uniform.dart';
import 'package:uniform_example/login_page.dart';
import 'package:uniform_example/validators/email_input_field_validator.dart';
import 'package:uniform_example/validators/password_input_field_validator.dart';

enum LoginFormTags {
  name,
  email,
  password,
  selectGender,
  gender,
}

class LoginViewModel extends ChangeNotifier {
  LoginViewModel()
      : formController = FormController(debugLabel: 'LoginFormController') {
    _nameField = TextFieldController.create(
      formController,
      tag: LoginFormTags.name,
    )..setValidators(
        {
          const InputFieldValidator.required(),
        },
      );

    _emailField = TextFieldController.create(
      formController,
      tag: LoginFormTags.email,
    )..setValidators(
        {
          const InputFieldValidator.required(),
          const EmailInputFieldValidator(),
        },
      );

    _passwordField = TextFieldController.create(
      formController,
      tag: LoginFormTags.password,
      autoValidate: true,
    )..setValidators(
        {
          const InputFieldValidator.required(),
          const PasswordInputFieldValidator(),
        },
      );

    FieldController<bool>.create(
      formController,
      tag: LoginFormTags.selectGender,
    )
      ..setInitialValue(false)
      ..onUpdate(_onSelectGenderUpdate);

    _genderField = FieldController<Gender>.create(
      formController,
      tag: LoginFormTags.gender,
    );

    formController.setInitialValues(
      {
        LoginFormTags.email: 'sales@acme-software.com',
        LoginFormTags.gender: Gender.female,
      },
    );
  }

  final FormController formController;

  late final TextFieldController _nameField;
  late final TextFieldController _emailField;
  late final TextFieldController _passwordField;
  late final FieldController<Gender> _genderField;

  Map<Object, Object?> _userData = {};
  bool _requireGender = false;

  Map<Object, Object?> get userData => _userData;

  bool get requireGender => _requireGender;

  Future<void> login() async {
    if (formController.validate()) {
      formController.setSubmitted(true);

      // Simulates login
      await Future<void>.delayed(const Duration(seconds: 2));

      _userData = {
        'Full Name': _nameField.value,
        'Email Address': _emailField.value,
        'Password': _passwordField.value,
        'Gender': _genderField.value?.name,
      };
      notifyListeners();

      formController.setSubmitted(false);
    }
  }

  void _onSelectGenderUpdate(bool? selectGender) {
    _requireGender = selectGender ?? false;
    notifyListeners();
  }

  @override
  void dispose() {
    formController.dispose();
    super.dispose();
  }
}
