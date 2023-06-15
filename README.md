A form library for Flutter that handles form validation and state management gracefully, with unified form representation.
Uniform handles the repetitive and annoying stuff—keeping track of values/errors/visited fields, orchestrating validation, and handling submission.

## Features

- Unified form representation using controllers.
- Easy and customizable form validation API.
- Built-in support for form submission and state management.
- Builders for quickly creating form fields.
- Compatible with any state management solution or vanilla Flutter States.
- Supports for global and local validators.

## Getting started

See the [Installing](https://pub.dev/packages/uniform/install) section.
No extra configurations needed.

## Usage

Note: Detailed Usage documentation is coming soon.
For now, please refer to the [example](https://github.com/AcmeSoftwareLLC/uniform/tree/main/example) for more details.

```dart
InputForm(
  child: Column(
    children: [
      TextInputFieldBuilder(
        tag: 'email',
        builder: (_, controller, textController) {
          return TextFormField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Email Address',
              errorText: controller.error.message,
            ),
            enabled: !controller.isSubmitted,
            onChanged: controller.onChanged,
          );
        },
      ),
      const SizedBox(height: 16),
      InputFieldBuilder<bool>(
        tag: 'remember_me',
        initialValue: false,
        builder: (context, controller, _) {
          return CheckboxListTile(
            title: const Text('Remember Me'),
            value: controller.value,
            controlAffinity: ListTileControlAffinity.leading,
            enabled: !controller.isSubmitted,
            onChanged: controller.onChanged,
          );
        },
      ),
      const SizedBox(height: 40),
      FilledButton(
        onPressed: () {
          if(InputForm.controllerOf(context).validate()){
            print('Form Submitted!');
          }
        },
        child: const Text('Submit'),
      ),
    ],
  ),
),
```

## Recommendation

The package works best in combination with [clean_framework](https://pub.dev/packages/clean_framework).