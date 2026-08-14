int reportInt(Object? value) => reportNullableInt(value) ?? 0;

int? reportNullableInt(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

String reportString(Object? value) => value?.toString() ?? '';

Map<String, dynamic> reportMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return const {};
}

Iterable<Object?> reportValues(Object? value) =>
    value is List ? value : const [];

Iterable<Map<String, dynamic>> reportMaps(Object? value) sync* {
  if (value is! List) return;
  for (final item in value) {
    if (item is Map) yield Map<String, dynamic>.from(item);
  }
}
