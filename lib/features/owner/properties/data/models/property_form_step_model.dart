import '../../domain/entities/property_form_step_entity.dart';

class PropertyFormStepModel extends PropertyFormStepEntity {
  const PropertyFormStepModel({
    required super.key,
    required super.label,
    super.endpoint,
    required super.fields,
    required super.autoSave,
    super.syncEndpoint,
    super.unitWorkflow,
    super.visibleWhen,
  });

  factory PropertyFormStepModel.fromJson(Map<String, dynamic> json) {
    final fieldsList = (json['fields'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();
    final workflowList = (json['unit_workflow'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList();

    return PropertyFormStepModel(
      key: json['key']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      endpoint: json['endpoint']?.toString(),
      fields: fieldsList,
      autoSave: json['auto_save'] as bool? ?? false,
      syncEndpoint: json['sync_endpoint']?.toString(),
      unitWorkflow: workflowList,
      visibleWhen: json['visible_when'] as Map<String, dynamic>?,
    );
  }
}
