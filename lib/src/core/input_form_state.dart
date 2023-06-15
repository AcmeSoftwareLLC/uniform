// Copyright 2023 Acme Software LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The state of a form.
enum InputFormState {
  /// The field has not been modified yet.
  pristine,

  /// The field has not been modified yet.
  dirty,

  /// The field has not been touched yet.
  untouched,

  /// The field has been touched.
  touched,

  /// The field content is not valid.
  invalid,

  /// The field content is valid.
  valid,

  /// The field has been submitted.
  submitted,
}
