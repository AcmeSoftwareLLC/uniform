// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:uniform/uniform.dart';

class CheckboxInputField extends StatelessWidget {
  const CheckboxInputField({
    required this.tag,
    required this.label,
    super.key,
  });

  final Object tag;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InputFieldBuilder<bool>(
      tag: tag,
      builder: (context, controller, _) {
        return CheckboxListTile(
          focusNode: controller.focusNode,
          value: controller.value,
          enabled: !controller.isSubmitted,
          onChanged: controller.onChanged,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(label),
          isError: controller.error.message != null,
        );
      },
    );
  }
}
