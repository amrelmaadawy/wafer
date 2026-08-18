import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/presentation/widgets/app_responsive_content.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../cubit/owner_dashboard_cubit.dart';
import '../cubit/owner_dashboard_state.dart';
import '../widgets/owner_dashboard_content.dart';
import '../widgets/owner_dashboard_header.dart';
import '../widgets/owner_dashboard_skeleton_widget.dart';

class OwnerDashboardView extends StatefulWidget {
  const OwnerDashboardView({super.key});

  @override
  State<OwnerDashboardView> createState() => _OwnerDashboardViewState();
}

class _OwnerDashboardViewState extends State<OwnerDashboardView> {
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<OwnerDashboardCubit>();
    if (cubit.state is OwnerDashboardInitial) cubit.loadDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlayStyle =
        isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: ColoredBox(
        color: context.appSubtleSurfaceColor,
        child: Column(
          children: [
            const OwnerDashboardHeader(),
            Expanded(
              child: BlocBuilder<OwnerDashboardCubit, OwnerDashboardState>(
                builder: (context, state) => _content(context, state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context, OwnerDashboardState state) {
    if (state is OwnerDashboardLoading) {
      return const OwnerDashboardSkeletonWidget();
    }
    if (state is OwnerDashboardError) {
      return CustomErrorWidget(
        message: state.message,
        isLoading: _isRetrying,
        onRetry: () => _retry(context),
      );
    }
    if (state is! OwnerDashboardLoaded) return const SizedBox.shrink();
    return RefreshIndicator(
      color: context.primaryColor,
      displacement: 20,
      onRefresh: () => context.read<OwnerDashboardCubit>().loadDashboardStats(
            forceRefresh: true,
          ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 20, bottom: 120),
        child: AppResponsiveContent(
          child: OwnerDashboardContent(state: state),
        ),
      ),
    );
  }

  Future<void> _retry(BuildContext context) async {
    setState(() => _isRetrying = true);
    await context.read<OwnerDashboardCubit>().loadDashboardStats(
          forceRefresh: true,
          showLoadingState: false,
        );
    if (mounted) setState(() => _isRetrying = false);
  }
}
