import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/domain/validators/field_validator.dart';
import 'package:wafer/core/localization/locale_keys.dart';

void main() {
  group('FieldValidator', () {
    test('required validator returns error for null and empty, null for valid string', () {
      expect(FieldValidator.required(null), LocaleKeys.validationRequired);
      expect(FieldValidator.required(''), LocaleKeys.validationRequired);
      expect(FieldValidator.required('   '), LocaleKeys.validationRequired);
      expect(FieldValidator.required('Valid text'), isNull);
    });

    test('positiveNumber returns error for null or non-positive, null for positive number', () {
      expect(FieldValidator.positiveNumber(null), LocaleKeys.validationPositiveNumber);
      expect(FieldValidator.positiveNumber(0), LocaleKeys.validationPositiveNumber);
      expect(FieldValidator.positiveNumber(-10), LocaleKeys.validationPositiveNumber);
      expect(FieldValidator.positiveNumber(100), isNull);
    });

    test('validateDateRange returns error if end date is before start date', () {
      final start = DateTime(2026, 1, 1);
      final endValid = DateTime(2026, 1, 15);
      final endInvalid = DateTime(2025, 12, 31);

      expect(FieldValidator.validateDateRange(start, endValid), isNull);
      expect(FieldValidator.validateDateRange(start, endInvalid), LocaleKeys.validationInvalidDateRange);
      expect(FieldValidator.validateDateRange(null, endValid), isNull);
    });
  });
}
