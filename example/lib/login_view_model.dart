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

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> login() async {
    if (loginFormController.validate()) {
      _isLoading = true;
      notifyListeners();

      await Future<void>.delayed(const Duration(seconds: 2));

      _isLoading = false;
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
