import 'package:equatable/equatable.dart';

class TasksFilterParams extends Equatable {
  final int page;
  final int perPage;
  final String? search;
  final String? status;
  final String? priority;
  final int? assigneeId;
  final String? dueDate;
  final String? sortBy;
  final String? sortOrder;

  const TasksFilterParams({
    this.page = 1,
    this.perPage = 15,
    this.search,
    this.status,
    this.priority,
    this.assigneeId,
    this.dueDate,
    this.sortBy,
    this.sortOrder,
  });

  TasksFilterParams copyWith({
    int? page,
    int? perPage,
    String? search,
    String? status,
    String? priority,
    int? assigneeId,
    String? dueDate,
    String? sortBy,
    String? sortOrder,
    bool clearSearch = false,
    bool clearStatus = false,
    bool clearPriority = false,
    bool clearAssignee = false,
    bool clearDueDate = false,
  }) {
    return TasksFilterParams(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: clearSearch ? null : (search ?? this.search),
      status: clearStatus ? null : (status ?? this.status),
      priority: clearPriority ? null : (priority ?? this.priority),
      assigneeId: clearAssignee ? null : (assigneeId ?? this.assigneeId),
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toQueryMap() {
    final map = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (search != null && search!.trim().isNotEmpty) {
      map['search'] = search!.trim();
    }
    if (status != null && status!.isNotEmpty) {
      map['status'] = status;
    }
    if (priority != null && priority!.isNotEmpty) {
      map['priority'] = priority;
    }
    if (assigneeId != null) {
      map['assignee_id'] = assigneeId;
    }
    if (dueDate != null && dueDate!.isNotEmpty) {
      map['due_date'] = dueDate;
    }
    if (sortBy != null && sortBy!.isNotEmpty) {
      map['sort_by'] = sortBy;
    }
    if (sortOrder != null && sortOrder!.isNotEmpty) {
      map['sort_order'] = sortOrder;
    }
    return map;
  }

  @override
  List<Object?> get props => [
        page,
        perPage,
        search,
        status,
        priority,
        assigneeId,
        dueDate,
        sortBy,
        sortOrder,
      ];
}
