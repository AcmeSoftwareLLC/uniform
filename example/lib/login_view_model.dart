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

  void login() {
    if (formController.validate()) {
      _userData = formController.values;
      notifyListeners();
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
