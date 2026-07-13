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
          BlocProvider<OwnerNavCubit>(create: (context) => sl<OwnerNavCubit>()),
          BlocProvider<OwnerDashboardCubit>(create: (context) => sl<OwnerDashboardCubit>()),
        ],
        child: const _OwnerMainContent(),
      ),
    );
  }
}

class _OwnerMainContent extends StatefulWidget {
  const _OwnerMainContent();

  @override
  State<_OwnerMainContent> createState() => _OwnerMainContentState();
}

class _OwnerMainContentState extends State<_OwnerMainContent> {
  int _previousIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OwnerNavCubit, OwnerNavState>(
      listener: (context, state) {
        if (state.currentIndex != _previousIndex) {
          setState(() {
            _previousIndex = state.currentIndex;
          });
        }
      },
      builder: (context, state) {
        final isForward = state.currentIndex >= _previousIndex;

        return Scaffold(
          extendBody: true,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  ...previousChildren,
                  ?currentChild,
                ],
              );
            },
            transitionBuilder: (child, animation) {
              final isIncoming = child.key == ValueKey<int>(state.currentIndex);
              final slideOffset = isForward ? const Offset(-0.06, 0) : const Offset(0.06, 0);

              if (isIncoming) {
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.1, 1.0, curve: Curves.easeOutCubic),
                  ),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: slideOffset,
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                    ),
                    child: child,
                  ),
                );
              } else {
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
                  ),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end: Offset(-slideOffset.dx, 0),
                    ).animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeIn),
                    ),
                    child: child,
                  ),
                );
              }
            },
            child: KeyedSubtree(
              key: ValueKey<int>(state.currentIndex),
              child: _getViewForIndex(state.currentIndex),
            ),
          ),
          bottomNavigationBar: OwnerBottomNavWidget(
            currentIndex: state.currentIndex,
            onTabChanged: (index) {
              context.read<OwnerNavCubit>().changeTab(index);
            },
          ),
        );
      },
    );
  }

  Widget _getViewForIndex(int index) {
    switch (index) {
      case 0:
        return const OwnerDashboardView();
      case 1:
        return const OwnerPropertiesView();
      case 2:
        return const OwnerLeasesView();
      case 3:
        return const OwnerFinanceView();
      case 4:
        return const OwnerMoreView();
      default:
        return const OwnerDashboardView();
    }
  }
}
