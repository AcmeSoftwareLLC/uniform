import 'package:flutter/foundation.dart';

part 'field_controller.dart';
part 'input_field_error.dart';
part 'input_field_validator.dart';

class FormController {
  FormController({
    Set<InputFieldValidator> validators = const {},
  }) : _validators = validators;

  final Map<Object, FieldController> _fields = {};
  final Set<InputFieldValidator> _validators;

  Iterable<Object> get tags => _fields.keys;

  FieldController<T> field<T extends Object>(Object tag) {
    assert(
      _fields.containsKey(tag),
      'Field "$tag" not bound to FormController with tags: ${tags.join(', ')}.',
    );
    return _fields[tag]! as FieldController<T>;
  }

  bool validate({Set<Object>? tags}) {
    final fields = tags == null ? _fields.values : tags.map(field);

    var isFormValid = true;
    for (final field in fields) {
      if (!field.validate()) isFormValid = false;
    }
    return isFormValid;
  }
}
