enum FinanceAccountType {
  asset('asset'),
  liability('liability'),
  expense('expense'),
  revenue('revenue'),
  equity('equity'),
  unknown('unknown');

  final String value;
  const FinanceAccountType(this.value);

  static FinanceAccountType fromString(String? val) {
    if (val == null) return FinanceAccountType.unknown;
    return FinanceAccountType.values.firstWhere(
      (e) => e.value == val.toLowerCase(),
      orElse: () => FinanceAccountType.unknown,
    );
  }
}
