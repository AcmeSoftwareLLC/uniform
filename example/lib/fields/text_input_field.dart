// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:uniform/uniform.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({
    required this.tag,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    super.key,
  });

  final Object tag;
  final String labelText;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextInputFieldBuilder(
      tag: tag,
      builder: (context, controller, textEditingController) {
        return TextFormField(
          focusNode: controller.focusNode,
          controller: textEditingController,
          decoration: InputDecoration(
            label: Text(controller.isRequired ? '$labelText *' : labelText),
            hintText: hintText,
            errorText: controller.error.message,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: TextStyle(color: Colors.grey.shade700),
          ),
          onChanged: controller.onChanged,
          obscureText: obscureText,
          enabled: !controller.isSubmitted,
        );
      },
    );
  }
}
