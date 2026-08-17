import 'package:equatable/equatable.dart';

class OfflineQueueEntry extends Equatable {
  final String id;
  final String featureKey;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retryCount;
  final String status;

  const OfflineQueueEntry({
    required this.id,
    required this.featureKey,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'featureKey': featureKey,
    'payload': payload,
    'createdAt': createdAt.toIso8601String(),
    'retryCount': retryCount,
    'status': status,
  };

  factory OfflineQueueEntry.fromMap(Map<dynamic, dynamic> map) {
    return OfflineQueueEntry(
      id: map['id'] as String,
      featureKey: map['featureKey'] as String,
      payload: Map<String, dynamic>.from(map['payload'] as Map),
      createdAt: DateTime.parse(map['createdAt'] as String),
      retryCount: (map['retryCount'] as int?) ?? 0,
      status: (map['status'] as String?) ?? 'pending',
    );
  }

  OfflineQueueEntry copyWith({
    String? id,
    String? featureKey,
    Map<String, dynamic>? payload,
    DateTime? createdAt,
    int? retryCount,
    String? status,
  }) {
    return OfflineQueueEntry(
      id: id ?? this.id,
      featureKey: featureKey ?? this.featureKey,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    featureKey,
    payload,
    createdAt,
    retryCount,
    status,
  ];
}
