import '../../localization/locale_keys.dart';

class FieldValidator {
  FieldValidator._();

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.validationRequired;
    }
    return null;
  }

  static String? positiveNumber(num? value) {
    if (value == null || value <= 0) {
      return LocaleKeys.validationPositiveNumber;
    }
    return null;
  }

  static String? minLength(String? value, int min) {
    if (value == null || value.trim().length < min) {
      return LocaleKeys.auth_password_min_length;
    }
    return null;
  }

  static String? validateDateRange(DateTime? start, DateTime? end) {
    if (start != null && end != null && end.isBefore(start)) {
      return LocaleKeys.validationInvalidDateRange;
    }
    return null;
  }
}
