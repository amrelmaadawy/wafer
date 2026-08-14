int reportInt(Object? value) => reportNullableInt(value) ?? 0;

int? reportNullableInt(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}
