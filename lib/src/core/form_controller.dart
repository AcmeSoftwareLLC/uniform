import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'field_controller.dart';
part 'input_field_error.dart';
part 'input_field_validator.dart';

class FormController {
  FormController({
    Set<InputFieldValidator> validators = const {},
  }) : _validators = validators;

  final Map<Object, FieldController> _fields = {};
  final Set<InputFieldValidator> _validators;
  final Completer<void> _initCompleter = Completer();

  Iterable<Object> get tags => _fields.keys;

  Future<FieldController<T>> call<T extends Object>(Object tag) async {
    await _initCompleter.future;
    return _field(tag);
  }

  bool validate({Set<Object>? tags}) {
    final fields = tags == null ? _fields.values : tags.map(_field);

    var isFormValid = true;
    for (final field in fields) {
      if (!field.validate()) isFormValid = false;
    }
    return isFormValid;
  }

  void remove(Object tag) => _fields.remove(tag);

  void dispose() {
    for (final field in _fields.values) {
      field.dispose();
    }
  }

  @internal
  void initialize(Duration timestamp) => _initCompleter.complete();

  FieldController<T> _field<T extends Object>(Object tag) {
    assert(
      _fields.containsKey(tag),
      'Field "$tag" not bound to FormController with tags: ${tags.join(', ')}.',
    );
    return _fields[tag]! as FieldController<T>;
  }
}
