enum ContractStatusFilter {
  all,
  active,
  expiring,
  draft,
  terminated;

  String? get apiValue => this == all ? null : name;
}
