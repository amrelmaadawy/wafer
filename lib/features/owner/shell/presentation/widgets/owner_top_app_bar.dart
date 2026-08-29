import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../notifications/presentation/cubit/unread_count_cubit.dart';
import '../../../../notifications/presentation/widgets/notification_bell_badge_widget.dart';
import '../models/breadcrumb_item.dart';

class OwnerTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final IconData? titleIcon;
  final List<BreadcrumbItem>? breadcrumbs;
  final bool showDrawerButton;
  final bool showSearch;
  final bool showNotifications;
  final bool forceDrawerButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onDrawerPressed;
  final List<Widget>? extraActions;
  final List<Widget>? extraIconActions;
  final PreferredSizeWidget? bottom;
  final double? elevation;

  const OwnerTopAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.titleIcon,
    this.breadcrumbs,
    this.showDrawerButton = true,
    this.showSearch = true,
    this.showNotifications = true,
    this.forceDrawerButton = false,
    this.onBackPressed,
    this.onDrawerPressed,
    this.extraActions,
    this.extraIconActions,
    this.bottom,
    this.elevation,
  });

  @override
  Size get preferredSize {
    final extraHeight = (breadcrumbs != null && breadcrumbs!.isNotEmpty) ? 8.0 : 0.0;
    return Size.fromHeight(
      kToolbarHeight + extraHeight + (bottom?.preferredSize.height ?? 0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.primaryColor;
    final canPop = Navigator.canPop(context);

    Widget? leadingWidget;
    if (canPop && !forceDrawerButton) {
      leadingWidget = CustomBackButton(onPressed: onBackPressed);
    } else if (showDrawerButton || forceDrawerButton) {
      leadingWidget = Padding(
        padding: const EdgeInsetsDirectional.only(start: AppSpacing.sm),
        child: Center(
          child: Material(
            color: primary.withValues(alpha: 0.08),
            borderRadius: AppRadius.circularMd,
            child: InkWell(
              onTap: onDrawerPressed ?? () {
                HapticFeedback.lightImpact();
                final rootScaffold = context.findRootAncestorStateOfType<ScaffoldState>();
                if (rootScaffold != null) {
                  rootScaffold.openDrawer();
                } else {
                  Scaffold.of(context).openDrawer();
                }
              },
              borderRadius: AppRadius.circularMd,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.menu_rounded,
                  color: primary,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return AppBar(
      elevation: elevation ?? 0,
      scrolledUnderElevation: 0,
      backgroundColor: context.appSurfaceColor,
      centerTitle: false,
      leadingWidth: (canPop && !forceDrawerButton) ? 68 : ((showDrawerButton || forceDrawerButton) ? 56 : null),
      leading: leadingWidget,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (titleIcon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: .12),
                borderRadius: AppRadius.circularMd,
              ),
              child: Icon(titleIcon, color: primary, size: 22),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h4.copyWith(
                    color: context.appOnSurfaceColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                if (breadcrumbs != null && breadcrumbs!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  _buildBreadcrumbs(context, breadcrumbs!, primary),
                ] else if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.appSecondaryTextColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      actions: _buildActions(context, primary),
      bottom: bottom,
    );
  }

  Widget _buildBreadcrumbs(
    BuildContext context,
    List<BreadcrumbItem> items,
    Color primary,
  ) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  isRtl
                      ? Icons.keyboard_arrow_left_rounded
                      : Icons.keyboard_arrow_right_rounded,
                  size: 14,
                  color: context.appSecondaryTextColor.withValues(alpha: 0.6),
                ),
              ),
            _buildBreadcrumbChip(
              context: context,
              item: items[i],
              isLast: i == items.length - 1,
              primary: primary,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBreadcrumbChip({
    required BuildContext context,
    required BreadcrumbItem item,
    required bool isLast,
    required Color primary,
  }) {
    if (isLast) {
      return Text(
        item.label,
        style: AppTextStyles.bodySmall.copyWith(
          color: context.appSecondaryTextColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        if (item.onTap != null) {
          item.onTap!();
        } else if (item.route != null) {
          context.push(item.route!);
        } else if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      borderRadius: AppRadius.circularSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        child: Text(
          item.label,
          style: AppTextStyles.bodySmall.copyWith(
            color: primary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: primary.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, Color primary) {
    final hasSearchOrNotif = showSearch || showNotifications;
    final hasExtra = extraActions != null && extraActions!.isNotEmpty;
    final hasExtraIcons = extraIconActions != null && extraIconActions!.isNotEmpty;

    if (!hasSearchOrNotif && !hasExtra && !hasExtraIcons) return [];

    return [
      if (hasExtra) ...extraActions!,
      if (hasSearchOrNotif || hasExtraIcons)
        Padding(
          padding: const EdgeInsetsDirectional.only(end: AppSpacing.md, start: 4),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasExtraIcons)
                  ...extraIconActions!.expand((action) => [
                        action,
                        if (hasSearchOrNotif || action != extraIconActions!.last)
                          _buildDivider(primary),
                      ]),
                if (showSearch)
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.push(Routes.ownerSearch);
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.search_rounded,
                          color: primary,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                if (showSearch && showNotifications)
                  Container(
                    width: 1.5,
                    height: 20,
                    color: primary.withValues(alpha: 0.15),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                  ),
                if (showNotifications)
                  BlocProvider.value(
                    value: sl<UnreadCountCubit>()..getUnreadCount(),
                    child: const NotificationBellBadgeWidget(isTransparent: true),
                  ),
              ],
            ),
          ),
        ),
    ];
  }

  Widget _buildDivider(Color primary) {
    return Container(
      width: 1.5,
      height: 20,
      color: primary.withValues(alpha: 0.15),
      margin: const EdgeInsets.symmetric(horizontal: 2),
    );
  }
}
