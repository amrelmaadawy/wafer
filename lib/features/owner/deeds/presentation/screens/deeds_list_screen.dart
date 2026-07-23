import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/theme/color_utils.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/presentation/widgets/animations/staggered_list_item.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../cubit/list/deeds_list_cubit.dart';
import '../cubit/list/deeds_list_state.dart';
import '../widgets/deeds_filter_bar.dart';
import '../widgets/deed_card.dart';
import '../widgets/deeds_skeleton.dart';
import '../widgets/deeds_empty_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/routes.dart';

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
      appBar: CustomAppBar(
        title: LocaleKeys.deeds_title.tr(),
        subtitle: LocaleKeys.deeds_management_subtitle.tr(),
        centerTitle: false,
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
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () => context.read<DeedsListCubit>().getDeeds(forceRefresh: true),
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
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                context.push('${Routes.ownerDeedDetails}?id=${deed.id}');
                              },
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await GoRouter.of(context).push(Routes.ownerDeedsCreate);
          if (result == true && context.mounted) {
            context.read<DeedsListCubit>().getDeeds(forceRefresh: true);
          }
        },
        backgroundColor: context.primaryColor,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          LocaleKeys.deeds_create_deed.tr(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
