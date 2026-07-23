import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/presentation/widgets/animations/staggered_list_item.dart';
import '../cubit/list/deeds_list_cubit.dart';
import '../cubit/list/deeds_list_state.dart';
import '../widgets/deeds_filter_bar.dart';
import '../widgets/deed_card.dart';
import '../widgets/deeds_skeleton.dart';
import '../widgets/deeds_empty_state.dart';
import 'package:url_launcher/url_launcher.dart';

class DeedsListScreen extends StatefulWidget {
  const DeedsListScreen({super.key});

  @override
  State<DeedsListScreen> createState() => _DeedsListScreenState();
}

class _DeedsListScreenState extends State<DeedsListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeedsListCubit>().getDeeds();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<DeedsListCubit>().loadNextPage();
    }
  }

  Future<void> _openAttachment(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          LocaleKeys.deeds_title.tr(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const DeedsFilterBar(),
          Expanded(
            child: BlocBuilder<DeedsListCubit, DeedsListState>(
              builder: (context, state) {
                if (state is DeedsListLoading || state is DeedsListInitial) {
                  return const DeedsSkeleton();
                } else if (state is DeedsListError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context.read<DeedsListCubit>().getDeeds(forceRefresh: true),
                          child: Text(LocaleKeys.common_retry.tr()),
                        ),
                      ],
                    ),
                  );
                } else if (state is DeedsListEmpty) {
                  return const DeedsEmptyState();
                }

                if (state is DeedsListLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<DeedsListCubit>().getDeeds(forceRefresh: true);
                    },
                    color: context.read<DeedsListCubit>().currentFilter.branchId != null 
                        ? Theme.of(context).primaryColor 
                        : Theme.of(context).primaryColor, // Ensure valid color or use AppColors.primary
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: state.deeds.length + (state.isFetchingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.deeds.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          );
                        }

                        final deed = state.deeds[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: StaggeredListItem(
                            index: index,
                            child: DeedCard(
                              deed: deed,
                              onAttachmentTap: () => _openAttachment(deed.documentAttachment),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
