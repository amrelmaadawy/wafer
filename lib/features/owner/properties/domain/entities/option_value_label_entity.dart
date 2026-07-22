import 'package:equatable/equatable.dart';

class OptionValueLabelEntity extends Equatable {
  final String value;
  final String label;

  const OptionValueLabelEntity({
    required this.value,
    required this.label,
  });

  @override
  List<Object?> get props => [value, label];
}
