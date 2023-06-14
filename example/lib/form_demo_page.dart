import 'package:flutter/material.dart';
import 'package:uniform/uniform.dart';
import 'package:uniform_example/validators/email_input_field_validator.dart';
import 'package:uniform_example/validators/password_input_field_validator.dart';

enum FormDemoTags {
  email,
  password,
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
      validators: {const RequiredInputFieldValidator()},
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
              TextInputFieldBuilder(
                tag: FormDemoTags.email,
                builder: (context, controller, textEditingController) {
                  return TextFormField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      errorText: controller.error.message,
                    ),
                    onChanged: controller.onChanged,
                  );
                },
              ),
              const SizedBox(height: 16),
              InputFieldBuilder<String>(
                tag: FormDemoTags.password,
                builder: (context, controller, _) {
                  return TextFormField(
                    initialValue: controller.value,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      errorText: controller.error.message,
                    ),
                    onChanged: controller.setValue,
                    obscureText: true,
                  );
                },
              ),
              const SizedBox(height: 40),
              Builder(
                builder: (context) {
                  return FilledButton(
                    onPressed: () {
                      final form = InputForm.controllerOf(context);

                      print(form.validate());
                    },
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
