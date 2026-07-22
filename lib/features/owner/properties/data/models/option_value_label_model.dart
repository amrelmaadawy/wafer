import '../../domain/entities/option_value_label_entity.dart';

class OptionValueLabelModel extends OptionValueLabelEntity {
  const OptionValueLabelModel({
    required super.value,
    required super.label,
  });

  factory OptionValueLabelModel.fromJson(Map<String, dynamic> json) {
    return OptionValueLabelModel(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? json['name']?.toString() ?? '',
    );
  }
}
