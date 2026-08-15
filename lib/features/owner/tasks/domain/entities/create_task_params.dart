import 'package:equatable/equatable.dart';

class CreateTaskParams extends Equatable {
  final String title;
  final String? description;
  final int? deedId;
  final int? propertyId;
  final int? branchId;
  final String? status;
  final String? priority;
  final String? category;
  final String? startDate;
  final String? dueDate;
  final int? progress;
  final String? notes;
  final List<int>? assignees;
  final List<String>? imageDescriptions;

  const CreateTaskParams({
    required this.title,
    this.description,
    this.deedId,
    this.propertyId,
    this.branchId,
    this.status,
    this.priority,
    this.category,
    this.startDate,
    this.dueDate,
    this.progress,
    this.notes,
    this.assignees,
    this.imageDescriptions,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (description != null) 'description': description,
      if (deedId != null) 'deed_id': deedId,
      if (propertyId != null) 'property_id': propertyId,
      if (branchId != null) 'branch_id': branchId,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (category != null) 'category': category,
      if (startDate != null) 'start_date': startDate,
      if (dueDate != null) 'due_date': dueDate,
      if (progress != null) 'progress': progress,
      if (notes != null) 'notes': notes,
      if (assignees != null) 'assignees': assignees,
      if (imageDescriptions != null) 'image_descriptions': imageDescriptions,
    };
  }

  @override
  List<Object?> get props => [
        title,
        description,
        deedId,
        propertyId,
        branchId,
        status,
        priority,
        category,
        startDate,
        dueDate,
        progress,
        notes,
        assignees,
        imageDescriptions,
      ];
}
