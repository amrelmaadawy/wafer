import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../cubit/owner_dashboard_cubit.dart';
import '../cubit/owner_nav_cubit.dart';
import '../cubit/owner_nav_state.dart';
import '../views/owner_dashboard_view.dart';
import '../views/owner_properties_view.dart';
import '../views/owner_leases_view.dart';
import '../views/owner_finance_view.dart';
import '../views/owner_more_view.dart';
import '../widgets/owner_bottom_nav_widget.dart';

class OwnerMainScreen extends StatelessWidget {
  const OwnerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<OwnerNavCubit>(create: (_) => sl<OwnerNavCubit>()),
          BlocProvider<OwnerDashboardCubit>(create: (_) => sl<OwnerDashboardCubit>()),
        ],
        child: const _OwnerMainContent(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content
// ---------------------------------------------------------------------------

class _OwnerMainContent extends StatefulWidget {
  const _OwnerMainContent();

  @override
  State<_OwnerMainContent> createState() => _OwnerMainContentState();
}

class _OwnerMainContentState extends State<_OwnerMainContent> {
  int _previousIndex = 0;

  static const _views = [
    OwnerDashboardView(),
    OwnerPropertiesView(),
    OwnerLeasesView(),
    OwnerFinanceView(),
    OwnerMoreView(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OwnerNavCubit, OwnerNavState>(
      listener: (context, state) {
        if (state.currentIndex != _previousIndex) {
          setState(() => _previousIndex = state.currentIndex);
        }
      },
      builder: (context, state) {
        final current = state.currentIndex;
        final isForward = current > _previousIndex;

        return Scaffold(
          extendBody: true,
          body: _PageSwitcher(
            currentIndex: current,
            previousIndex: _previousIndex,
            isForward: isForward,
            child: _views[current],
          ),
          bottomNavigationBar: OwnerBottomNavWidget(
            currentIndex: current,
            onTabChanged: (i) => context.read<OwnerNavCubit>().changeTab(i),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Professional page switcher
// ---------------------------------------------------------------------------

class _PageSwitcher extends StatefulWidget {
  final int currentIndex;
  final int previousIndex;
  final bool isForward;
  final Widget child;

  const _PageSwitcher({
    required this.currentIndex,
    required this.previousIndex,
    required this.isForward,
    required this.child,
  });

  @override
  State<_PageSwitcher> createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<_PageSwitcher> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late Animation<Offset> _slideIn;   // non-final — reassigned on every tab change
  late Animation<Offset> _slideOut;
  Widget? _outgoing;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
    _setupAnimations();
    _ctrl.value = 1.0;
  }

  void _setupAnimations() {
    final fwd = widget.isForward;
    _slideIn = Tween<Offset>(
      begin: Offset(fwd ? -0.07 : 0.07, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutQuart));
    _slideOut = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(fwd ? 0.04 : -0.04, 0),
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInCubic));
  }

  @override
  void didUpdateWidget(_PageSwitcher old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _outgoing = old.child;
      _setupAnimations();
      _ctrl.forward(from: 0).then((_) => setState(() => _outgoing = null));
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Outgoing page fades + slides away
        if (_outgoing != null)
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, child) => FadeTransition(
              opacity: Tween(begin: 1.0, end: 0.0)
                  .animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.4, curve: Curves.easeIn))),
              child: SlideTransition(position: _slideOut, child: child),
            ),
            child: _outgoing,
          ),
        // Incoming page fades + slides in
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, child) => FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.2, 1.0, curve: Curves.easeOut))),
            child: SlideTransition(position: _slideIn, child: child),
          ),
          child: widget.child,
        ),
      ],
    );
  }
}
