import 'package:equatable/equatable.dart';
import '../../../domain/entities/property_display_mode.dart';

class PropertyDisplayState extends Equatable {
  final PropertyDisplayMode mode;

  const PropertyDisplayState(this.mode);

  @override
  List<Object> get props => [mode];
}
