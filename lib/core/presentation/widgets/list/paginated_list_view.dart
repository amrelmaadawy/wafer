import 'package:flutter/material.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/color_utils.dart';
import '../animations/staggered_list_item.dart';
import '../app_pagination_loader.dart';

/// A reusable paginated list/grid view with pull-to-refresh,
/// infinite scroll listening, and automated pagination loading indicators.
class PaginatedListView<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final bool isLoading;
  final bool isFetchingMore;
  final bool hasReachedMax;
  final RefreshCallback? onRefresh;
  final VoidCallback onLoadMore;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final IndexedWidgetBuilder? separatorBuilder;
  final bool isGrid;
  final SliverGridDelegate? gridDelegate;
  final bool useStaggeredAnimation;

  const PaginatedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onLoadMore,
    this.isLoading = false,
    this.isFetchingMore = false,
    this.hasReachedMax = false,
    this.onRefresh,
    this.emptyWidget,
    this.loadingWidget,
    this.errorWidget,
    this.padding,
    this.controller,
    this.separatorBuilder,
    this.isGrid = false,
    this.gridDelegate,
    this.useStaggeredAnimation = false,
  });

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  late final ScrollController _scrollController;
  bool _internalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _scrollController = widget.controller!;
    } else {
      _scrollController = ScrollController();
      _internalController = true;
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    if (_internalController) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll - 200) &&
        !widget.isFetchingMore &&
        !widget.hasReachedMax &&
        !widget.isLoading) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading && widget.items.isEmpty) {
      return widget.loadingWidget ??
          Center(
            child: CircularProgressIndicator(color: context.primaryColor),
          );
    }

    if (widget.errorWidget != null && widget.items.isEmpty) {
      return widget.errorWidget!;
    }

    if (widget.items.isEmpty && !widget.isLoading) {
      return widget.emptyWidget ?? const SizedBox.shrink();
    }

    final totalCount = widget.items.length + (widget.isFetchingMore ? 1 : 0);
    final effectivePadding = widget.padding ??
        const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.xxxl,
        );

    Widget content;
    if (widget.isGrid && widget.gridDelegate != null) {
      content = GridView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: effectivePadding,
        gridDelegate: widget.gridDelegate!,
        itemCount: totalCount,
        itemBuilder: (context, index) => _buildGridItem(context, index),
      );
    } else if (widget.separatorBuilder != null) {
      content = ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: effectivePadding,
        itemCount: totalCount,
        separatorBuilder: widget.separatorBuilder!,
        itemBuilder: (context, index) => _buildListItem(context, index),
      );
    } else {
      content = ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: effectivePadding,
        itemCount: totalCount,
        itemBuilder: (context, index) => _buildListItem(context, index),
      );
    }

    if (widget.onRefresh != null) {
      return RefreshIndicator(
        color: context.primaryColor,
        onRefresh: widget.onRefresh!,
        child: content,
      );
    }
    return content;
  }

  Widget _buildListItem(BuildContext context, int index) {
    if (index >= widget.items.length) {
      return const AppPaginationLoader();
    }
    final itemWidget = widget.itemBuilder(context, index, widget.items[index]);
    if (widget.useStaggeredAnimation) {
      return StaggeredListItem(index: index, child: itemWidget);
    }
    return itemWidget;
  }

  Widget _buildGridItem(BuildContext context, int index) {
    if (index >= widget.items.length) {
      return const Center(child: AppPaginationLoader());
    }
    final itemWidget = widget.itemBuilder(context, index, widget.items[index]);
    if (widget.useStaggeredAnimation) {
      return StaggeredListItem(index: index, child: itemWidget);
    }
    return itemWidget;
  }
}
