# Uniform Example

An example app to demonstrate the usage of uniform package.

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