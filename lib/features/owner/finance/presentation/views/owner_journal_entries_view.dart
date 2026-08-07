import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:wafer/core/utils/widgets/app_toast.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/journal_entries/journal_entries_cubit.dart';
import '../cubit/journal_entries/journal_entries_state.dart';
import '../cubit/journal_entries/post_journal_entry_cubit.dart';
import '../cubit/journal_entries/post_journal_entry_state.dart';
import '../cubit/journal_entries/reverse_journal_entry_cubit.dart';
import '../cubit/journal_entries/reverse_journal_entry_state.dart';
import '../widgets/finance_journal_entry_card.dart';
import '../widgets/finance_payments_skeleton.dart'; 
class OwnerJournalEntriesView extends StatefulWidget {
  const OwnerJournalEntriesView({super.key});

  @override
  State<OwnerJournalEntriesView> createState() => _OwnerJournalEntriesViewState();
}

class _OwnerJournalEntriesViewState extends State<OwnerJournalEntriesView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<JournalEntriesCubit>().fetchJournalEntries(forceRefresh: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<JournalEntriesCubit>().fetchJournalEntries();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<JournalEntriesCubit>().fetchJournalEntries(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PostJournalEntryCubit, PostJournalEntryState>(
          listener: (context, state) {
            if (state is PostJournalEntrySuccess) {
              AppToast.showSuccess(context, LocaleKeys.ownerFinancePostSuccess.tr());
              _onRefresh();
            } else if (state is PostJournalEntryError) {
              AppToast.showError(context, state.message);
            }
          },
        ),
        BlocListener<ReverseJournalEntryCubit, ReverseJournalEntryState>(
          listener: (context, state) {
            if (state is ReverseJournalEntrySuccess) {
              AppToast.showSuccess(context, LocaleKeys.ownerFinanceReverseSuccess.tr());
              _onRefresh();
            } else if (state is ReverseJournalEntryError) {
              AppToast.showError(context, state.message);
            }
          },
        ),
      ],
      child: Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: LocaleKeys.owner_finance_journal_entries.tr(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(Routes.ownerFinanceCreateJournalEntry).then((value) {
            if (value == true) {
              _onRefresh();
            }
          });
        },
        backgroundColor: context.primaryColor,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: context.primaryColor,
        child: BlocBuilder<JournalEntriesCubit, JournalEntriesState>(
          builder: (context, state) {
            if (state is JournalEntriesLoading) {
              return const FinancePaymentsSkeleton();
            }

            if (state is JournalEntriesError && state.entries.isEmpty) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => _onRefresh(),
              );
            }

            if (state is JournalEntriesEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 80,
                      color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LocaleKeys.reports_empty_state.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              );
            }

            List<dynamic> entries = [];
            bool hasReachedMax = true;

            if (state is JournalEntriesLoaded) {
              entries = state.entries;
              hasReachedMax = state.hasReachedMax;
            } else if (state is JournalEntriesLoadingMore) {
              entries = state.entries;
              hasReachedMax = state.hasReachedMax;
            } else if (state is JournalEntriesError) {
              entries = state.entries;
            }

            return ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16).copyWith(bottom: 80),
              itemCount: entries.length + (hasReachedMax ? 0 : 1),
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index >= entries.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final entry = entries[index];
                return FinanceJournalEntryCard(entry: entry);
              },
            );
          },
        ),
      ),
    ));
  }
}
