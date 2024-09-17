// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:uniform/uniform.dart';
import 'package:uniform_example/fields/checkbox_input_field.dart';
import 'package:uniform_example/fields/dropdown_input_field.dart';
import 'package:uniform_example/fields/form_button.dart';
import 'package:uniform_example/fields/text_input_field.dart';
import 'package:uniform_example/login_view_model.dart';

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
    viewModel = LoginViewModel()..addListener(_onViewModelUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uniform Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: InputForm(
          controller: viewModel.formController,
          child: Column(
            children: [
              const TextInputField(
                tag: LoginFormTags.email,
                labelText: 'Email Address',
                hintText: 'Enter your email address',
              ),
              const SizedBox(height: 16),
              const TextInputField(
                tag: LoginFormTags.name,
                labelText: 'Full Name',
                hintText: 'Enter your full name',
              ),
              const SizedBox(height: 16),
              const TextInputField(
                tag: LoginFormTags.password,
                labelText: 'Password',
                hintText: 'Enter your password',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              const CheckboxInputField(
                tag: LoginFormTags.selectGender,
                label: 'Select Gender',
              ),
              ListenableBuilder(
                listenable: viewModel,
                builder: (context, child) {
                  if (viewModel.requireGender) return child!;

                  return const SizedBox.shrink();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: DropdownInputField(
                    tag: LoginFormTags.gender,
                    hintText: 'Gender',
                    menuEntries: [
                      for (final gender in Gender.values)
                        DropdownMenuEntry(value: gender, label: gender.name),
                    ],
                    width: MediaQuery.sizeOf(context).width - 32,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FormButton(
                onPressed: viewModel.login,
                child: const Text('Login'),
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

  void _onViewModelUpdate() {
    final userData = Map.of(viewModel.userData);

    if (userData.isNotEmpty) {
      viewModel.userData.clear();

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Login Success'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final MapEntry(:key, :value) in userData.entries)
                  Text('$key: $value'),
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          );
        },
      );
    }
  }
}

enum Gender {
  male('Male'),
  female('Female'),
  other('Other');

  const Gender(this.name);

  final String name;
}
