import 'package:flutter/material.dart';
import 'package:uniform/uniform.dart';

enum FormDemoTags {
  name,
  description,
}

class FormDemoPage extends StatelessWidget {
  const FormDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uniform Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: InputForm(
          controller: FormController(
            validators: {const RequiredInputFieldValidator()},
          ),
          child: Column(
            children: [
              InputField(
                tag: FormDemoTags.name,
                builder: (context, controller, _) {
                  print(controller);
                  return TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Name',
                      errorText: controller.error.message,
                    ),
                    onChanged: controller.setValue,
                  );
                },
              ),
              const SizedBox(height: 16),
              InputField(
                tag: FormDemoTags.description,
                builder: (context, controller, _) {
                  print(controller);
                  return TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Description',
                      errorText: controller.error.message,
                    ),
                    onChanged: controller.setValue,
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
