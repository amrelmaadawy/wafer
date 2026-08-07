import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/post_journal_entry_use_case.dart';
import 'post_journal_entry_state.dart';

class PostJournalEntryCubit extends Cubit<PostJournalEntryState> {
  final PostJournalEntryUseCase postJournalEntryUseCase;

  PostJournalEntryCubit({required this.postJournalEntryUseCase}) : super(PostJournalEntryInitial());

  Future<void> postEntry(int id) async {
    emit(PostJournalEntryLoading(entryId: id));
    final result = await postJournalEntryUseCase(id);
    result.fold(
      (failure) => emit(PostJournalEntryError(failure.message)),
      (entry) => emit(PostJournalEntrySuccess(entry)),
    );
  }
}
