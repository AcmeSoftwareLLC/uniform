import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uniform/uniform.dart';
import 'package:uniform_example/login_view_model.dart';

enum Gender {
  male('Male'),
  female('Female'),
  other('Other');

  const Gender(this.name);

  final String name;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = LoginViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uniform Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: InputForm(
          controller: viewModel.loginFormController,
          child: Column(
            children: [
              const TextInputField(
                tag: LoginFormTags.email,
                hintText: 'Email',
              ),
              const SizedBox(height: 16),
              const TextInputField(
                tag: LoginFormTags.password,
                hintText: 'Password',
                obscureText: true,
                autoValidate: true,
              ),
              const SizedBox(height: 16),
              InputFieldBuilder<Gender>(
                tag: LoginFormTags.gender,
                builder: (context, controller, _) {
                  return DropdownButtonFormField(
                    value: controller.value,
                    onChanged: controller.onChanged,
                    decoration: InputDecoration(
                      errorText: controller.error.message,
                      hintText: 'Gender',
                    ),
                    items: [
                      for (final gender in Gender.values)
                        DropdownMenuItem(
                          value: gender,
                          child: Text(gender.name),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              InputFieldBuilder<bool>(
                tag: LoginFormTags.rememberMe,
                builder: (context, controller, _) {
                  return CheckboxListTile(
                    value: controller.value ?? false,
                    onChanged: controller.onChanged,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('Remember me'),
                  );
                },
              ),
              const SizedBox(height: 40),
              InputActionBuilder(
                builder: (context, controller, _) {
                  log('Form States: ${controller.states}');

                  return FilledButton(
                    onPressed: controller.contains({InputFormState.touched})
                        ? viewModel.login
                        : null,
                    child: const Text('Login'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}

class TextInputField extends StatelessWidget {
  const TextInputField({
    required this.tag,
    required this.hintText,
    this.obscureText = false,
    this.autoValidate = false,
    super.key,
  });

  final Object tag;
  final String hintText;
  final bool obscureText;
  final bool autoValidate;

  @override
  Widget build(BuildContext context) {
    return TextInputFieldBuilder(
      tag: tag,
      autoValidate: autoValidate,
      builder: (context, controller, textEditingController) {
        return TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: controller.error.message,
          ),
          onChanged: controller.onChanged,
          obscureText: obscureText,
        );
      },
    );
  }
}
