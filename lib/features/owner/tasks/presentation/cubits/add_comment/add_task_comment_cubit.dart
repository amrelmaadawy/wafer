import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_task_comment_usecase.dart';
import 'add_task_comment_state.dart';

class AddTaskCommentCubit extends Cubit<AddTaskCommentState> {
  final AddTaskCommentUseCase addTaskCommentUseCase;

  AddTaskCommentCubit({required this.addTaskCommentUseCase}) : super(AddTaskCommentInitial());

  Future<void> addComment(int taskId, String body) async {
    emit(AddTaskCommentLoading());
    final result = await addTaskCommentUseCase(
      AddTaskCommentParams(taskId: taskId, body: body),
    );

    result.fold(
      (failure) => emit(AddTaskCommentError(message: failure.message)),
      (task) => emit(AddTaskCommentSuccess(task: task)),
    );
  }
}
