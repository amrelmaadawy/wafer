import 'package:equatable/equatable.dart';

class ActivityLogsUserEntity extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String userType;

  const ActivityLogsUserEntity({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.userType,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        userType,
      ];
}
