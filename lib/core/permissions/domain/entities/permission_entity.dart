import 'package:equatable/equatable.dart';

enum PermissionResource {
  property,
  unit,
  contract,
  finance,
  maintenance,
  report,
  task,
  legalCase,
  deed,
  notification,
}

enum PermissionAction {
  view,
  create,
  edit,
  approve,
  reverse,
  delete,
  export,
}

class PermissionEntity extends Equatable {
  final PermissionResource resource;
  final List<PermissionAction> allowedActions;

  const PermissionEntity({
    required this.resource,
    required this.allowedActions,
  });

  bool hasAction(PermissionAction action) {
    return allowedActions.contains(action);
  }

  @override
  List<Object?> get props => [resource, allowedActions];
}
