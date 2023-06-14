import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uniform/uniform.dart';
import 'package:uniform_example/validators/email_input_field_validator.dart';
import 'package:uniform_example/validators/password_input_field_validator.dart';

enum FormDemoTags {
  email,
  password,
  rememberMe,
}

class FormDemoPage extends StatefulWidget {
  const FormDemoPage({super.key});

  @override
  State<FormDemoPage> createState() => _FormDemoPageState();
}

class _FormDemoPageState extends State<FormDemoPage> {
  late final FormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FormController(
      validators: {const InputFieldValidator.required()},
    );
    _initValidators();
  }

  Future<void> _initValidators() async {
    final emailController = await _controller(FormDemoTags.email);
    emailController
      ..setValidators({const EmailInputFieldValidator()})
      ..setValue('sales@acme-software.com');

    final passwordController = await _controller(FormDemoTags.password);
    passwordController.setValidators(
      {const PasswordInputFieldValidator()},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uniform Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: InputForm(
          controller: _controller,
          child: Column(
            children: [
              const TextInputField(
                tag: FormDemoTags.email,
                hintText: 'Email',
              ),
              const SizedBox(height: 16),
              const TextInputField(
                tag: FormDemoTags.password,
                hintText: 'Password',
                obscureText: true,
                autoValidate: true,
              ),
              const SizedBox(height: 16),
              InputFieldBuilder<bool>(
                tag: FormDemoTags.rememberMe,
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
                        ? () => log('Form Valid: ${_controller.validate()}')
                        : null,
                    child: const Text('Submit'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
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
