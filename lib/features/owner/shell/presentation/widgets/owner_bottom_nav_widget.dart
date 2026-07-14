import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';

class OwnerBottomNavWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const OwnerBottomNavWidget({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  static List<_NavTab> get _tabs => [
        _NavTab(LocaleKeys.dashboardNavHome.tr(), Icons.dashboard_rounded, Icons.dashboard_outlined),
        _NavTab(LocaleKeys.dashboardNavProperties.tr(), Icons.apartment_rounded, Icons.apartment_outlined),
        _NavTab(LocaleKeys.dashboardNavContracts.tr(), Icons.description_rounded, Icons.description_outlined),
        _NavTab(LocaleKeys.dashboardNavFinance.tr(), Icons.account_balance_wallet_rounded, Icons.account_balance_wallet_outlined),
        _NavTab(LocaleKeys.dashboardNavProfile.tr(), Icons.person_rounded, Icons.person_outline_rounded),
      ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularXxl,
          border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_tabs.length, (i) => _NavItem(
            tab: _tabs[i],
            isSelected: currentIndex == i,
            onTap: () {
              HapticFeedback.lightImpact();
              onTabChanged(i);
            },
          )),
        ),
      ),
    );
  }
}

class _NavTab {
  final String label;
  final IconData active;
  final IconData inactive;
  const _NavTab(this.label, this.active, this.inactive);
}

class _NavItem extends StatefulWidget {
  final _NavTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.85), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.15), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _bounce = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    if (widget.isSelected) _ctrl.value = 1.0;
  }

  @override
  void didUpdateWidget(_NavItem old) {
    super.didUpdateWidget(old);
    if (widget.isSelected && !old.isSelected) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: widget.isSelected ? 16 : 10, vertical: 8),
        decoration: BoxDecoration(
          color: widget.isSelected ? context.primaryColor : Colors.transparent,
          borderRadius: AppRadius.circularXxl,
          boxShadow: widget.isSelected
              ? [BoxShadow(color: context.primaryShadow, blurRadius: 12, offset: const Offset(0, 4))]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: widget.isSelected ? _scale : const AlwaysStoppedAnimation(1.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: ScaleTransition(scale: anim, child: child),
                ),
                child: Icon(
                  widget.isSelected ? widget.tab.active : widget.tab.inactive,
                  key: ValueKey(widget.isSelected),
                  color: widget.isSelected
                      ? Colors.white
                      : AppColors.textSecondaryLight.withValues(alpha: 0.6),
                  size: 22,
                ),
              ),
            ),
            ClipRect(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerRight,
                child: widget.isSelected
                    ? Row(children: [
                        const SizedBox(width: 6),
                        AnimatedBuilder(
                          animation: _bounce,
                          builder: (context, child) => Opacity(
                            opacity: _bounce.value.clamp(0.0, 1.0),
                            child: child,
                          ),
                          child: Text(
                            widget.tab.label,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ])
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
