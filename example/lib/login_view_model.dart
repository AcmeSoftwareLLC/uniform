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
    loginFormController = FormController(
      validators: {const InputFieldValidator.required()},
    );
    _initValidators();
  }

  late final FormController loginFormController;

  Map<Object, Object?> _userData = {};

  Map<Object, Object?> get userData => _userData;

  void login() {
    if (loginFormController.validate()) {
      _userData = loginFormController.value;
      notifyListeners();
    }
  }

  Future<void> _initValidators() async {
    final emailController = await loginFormController(LoginFormTags.email);
    emailController
      ..setValidators({const EmailInputFieldValidator()})
      ..setValue('sales@acme-software.com');

    final passwordController =
        await loginFormController(LoginFormTags.password);
    passwordController.setValidators({const PasswordInputFieldValidator()});
  }
}
