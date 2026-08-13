enum PropertyDisplayMode { comfortable, compact }

extension PropertyDisplayModeStorage on PropertyDisplayMode {
  String get storageValue => name;

  static PropertyDisplayMode fromStorage(String? value) {
    return PropertyDisplayMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => PropertyDisplayMode.comfortable,
    );
  }
}
