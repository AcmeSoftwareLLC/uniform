<h1 align="center">
<a href="https://github.com/AcmeSoftwareLLC/uniform">
<img src="https://raw.githubusercontent.com/AcmeSoftwareLLC/uniform/main/images/uniform.png" width="350">
</a>
</h1>

<p align="center">
<a href="https://pub.dev/packages/uniform"><img src="https://img.shields.io/pub/v/uniform?label=pub.dev&labelColor=333940&logo=dart"></a>
<a href="https://pub.dev/packages/uniform"><img src="https://img.shields.io/pub/points/uniform?label=Pub%20Points&logo=dart"></a>
<a href="https://github.com/AcmeSoftwareLLC/uniform/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-BSD--3-informational" alt="BSD-3 License"></a>
<a href="https://acmesoftware.com"><img src="https://img.shields.io/website?url=https%3A%2F%2Facmesoftware.com" alt="Website"></a>
<a href="https://www.linkedin.com/company/acmesoftware"><img src="https://img.shields.io/badge/Connect--000?style=social&logo=linkedin" alt="Connect with Acme Software on Linkedin"></a>
<a href="https://twitter.com/software_acme"><img alt="Twitter Follow" src="https://img.shields.io/twitter/follow/software_acme?label=Acme%20Software%20LLC&style=social"></a>
<a href="https://www.facebook.com/profile.php?id=100088946151671"><img alt="Facebook" src="https://img.shields.io/badge/Acme%20Software%20LLC--000?style=social&logo=facebook"></a>
<a href="https://www.instagram.com/acme.software/"><img alt="Instagram" src="https://img.shields.io/badge/Acme%20Software%20LLC--000?style=social&logo=instagram"></a>
</p>

<p align="center">
A form library for Flutter that handles form validation and state management gracefully,
<br>
with unified form representation.
</p>
<br>

Uniform handles the repetitive and annoying stuff—keeping track of values/errors/visited fields, orchestrating validation, and handling submission.

## Features

- 🪶 Lightweight & extensive.
- 🎮 Unified form representation using controllers.
- 🔄 Easy and customizable form validation API.
- 🔧 Built-in support for form submission and state management.
- 🛠️ Builders for quickly creating form fields.
- 🚀 Compatible with any state management solution or vanilla Flutter States.
- 🔒 Supports for global and local validators.

## Getting started

See the [Installing](https://pub.dev/packages/uniform/install) section.
No extra configurations needed.

## Usage

Note: Detailed Usage documentation is coming soon.
For now, please refer to the [example](https://github.com/AcmeSoftwareLLC/uniform/tree/main/example) for more details.

```dart
final formController = FormController(
  validators: {const InputFieldValidator.required()},
);

TextFieldController.create(formController, tag: 'email')
  ..setValidators({const EmailInputFieldValidator()});

FieldController<bool>.create(formController, tag: 'remember_me', autoValidate: true)
  ..setInitialValue(false)
  ..setValidators({const PasswordInputFieldValidator()});

InputForm(
  controller: formController,
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
          if(formController.validate()){
            print('Form Submitted!');
          }
        },
        child: const Text('Submit'),
      ),
    ],
  ),
),
```
