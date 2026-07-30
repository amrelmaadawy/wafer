import 'package:equatable/equatable.dart';
import '../../../../properties/domain/entities/property_list_item_entity.dart';
import '../../../../properties/domain/entities/unit_entity.dart';

enum CreateMaintenanceStatus { initial, loading, success, failure }

class OwnerCreateMaintenanceState extends Equatable {
  final CreateMaintenanceStatus status;
  final String? errorMessage;
  
  final bool isPropertiesLoading;
  final List<PropertyListItemEntity> properties;
  final String? propertiesError;
  
  final bool isUnitsLoading;
  final List<UnitEntity> units;
  final String? unitsError;

  final int? selectedPropertyId;
  final int? selectedUnitId;
  
  final String clientName;
  final String clientPhone;
  final String description;
  final String requestedDate;
  final List<String> maintenanceTypes;
  final bool isPrivate;

  const OwnerCreateMaintenanceState({
    this.status = CreateMaintenanceStatus.initial,
    this.errorMessage,
    
    this.isPropertiesLoading = false,
    this.properties = const [],
    this.propertiesError,
    
    this.isUnitsLoading = false,
    this.units = const [],
    this.unitsError,
    
    this.selectedPropertyId,
    this.selectedUnitId,
    
    this.clientName = '',
    this.clientPhone = '',
    this.description = '',
    this.requestedDate = '',
    this.maintenanceTypes = const [],
    this.isPrivate = false,
  });

  OwnerCreateMaintenanceState copyWith({
    CreateMaintenanceStatus? status,
    String? errorMessage,
    
    bool? isPropertiesLoading,
    List<PropertyListItemEntity>? properties,
    String? propertiesError,
    
    bool? isUnitsLoading,
    List<UnitEntity>? units,
    String? unitsError,
    
    int? selectedPropertyId,
    int? selectedUnitId,
    
    String? clientName,
    String? clientPhone,
    String? description,
    String? requestedDate,
    List<String>? maintenanceTypes,
    bool? isPrivate,
  }) {
    return OwnerCreateMaintenanceState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      
      isPropertiesLoading: isPropertiesLoading ?? this.isPropertiesLoading,
      properties: properties ?? this.properties,
      propertiesError: propertiesError ?? this.propertiesError,
      
      isUnitsLoading: isUnitsLoading ?? this.isUnitsLoading,
      units: units ?? this.units,
      unitsError: unitsError ?? this.unitsError,
      
      selectedPropertyId: selectedPropertyId ?? this.selectedPropertyId,
      selectedUnitId: selectedUnitId ?? this.selectedUnitId, // Keep unit selected when property changes? Usually reset. The cubit will handle resetting it.
      
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      description: description ?? this.description,
      requestedDate: requestedDate ?? this.requestedDate,
      maintenanceTypes: maintenanceTypes ?? this.maintenanceTypes,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
  
  // Custom copyWith to allow nullifying selectedUnitId when property changes
  OwnerCreateMaintenanceState copyWithNullUnitId({
    CreateMaintenanceStatus? status,
    String? errorMessage,
    bool? isPropertiesLoading,
    List<PropertyListItemEntity>? properties,
    String? propertiesError,
    bool? isUnitsLoading,
    List<UnitEntity>? units,
    String? unitsError,
    int? selectedPropertyId,
    String? clientName,
    String? clientPhone,
    String? description,
    String? requestedDate,
    List<String>? maintenanceTypes,
    bool? isPrivate,
  }) {
    return OwnerCreateMaintenanceState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isPropertiesLoading: isPropertiesLoading ?? this.isPropertiesLoading,
      properties: properties ?? this.properties,
      propertiesError: propertiesError ?? this.propertiesError,
      isUnitsLoading: isUnitsLoading ?? this.isUnitsLoading,
      units: units ?? this.units,
      unitsError: unitsError ?? this.unitsError,
      selectedPropertyId: selectedPropertyId ?? this.selectedPropertyId,
      selectedUnitId: null, // explicitly null
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      description: description ?? this.description,
      requestedDate: requestedDate ?? this.requestedDate,
      maintenanceTypes: maintenanceTypes ?? this.maintenanceTypes,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isPropertiesLoading,
        properties,
        propertiesError,
        isUnitsLoading,
        units,
        unitsError,
        selectedPropertyId,
        selectedUnitId,
        clientName,
        clientPhone,
        description,
        requestedDate,
        maintenanceTypes,
        isPrivate,
      ];
}
