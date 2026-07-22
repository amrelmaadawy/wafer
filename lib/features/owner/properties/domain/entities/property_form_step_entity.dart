import 'package:equatable/equatable.dart';

class PropertyFormStepEntity extends Equatable {
  final String key;
  final String label;
  final String? endpoint;
  final List<String> fields;
  final bool autoSave;
  final String? syncEndpoint;
  final List<String>? unitWorkflow;
  final Map<String, dynamic>? visibleWhen;

  const PropertyFormStepEntity({
    required this.key,
    required this.label,
    this.endpoint,
    required this.fields,
    required this.autoSave,
    this.syncEndpoint,
    this.unitWorkflow,
    this.visibleWhen,
  });

  @override
  List<Object?> get props => [
        key,
        label,
        endpoint,
        fields,
        autoSave,
        syncEndpoint,
        unitWorkflow,
        visibleWhen,
      ];
}
