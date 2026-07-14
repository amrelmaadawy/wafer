import 'package:flutter/material.dart';

class OwnerPageSwitcher extends StatefulWidget {
  final int currentIndex;
  final int previousIndex;
  final bool isForward;
  final Widget child;

  const OwnerPageSwitcher({
    super.key,
    required this.currentIndex,
    required this.previousIndex,
    required this.isForward,
    required this.child,
  });

  @override
  State<OwnerPageSwitcher> createState() => _OwnerPageSwitcherState();
}

class _OwnerPageSwitcherState extends State<OwnerPageSwitcher>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late Animation<Offset> _slideIn;
  late Animation<Offset> _slideOut;
  Widget? _outgoing;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
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
  void didUpdateWidget(OwnerPageSwitcher old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _outgoing = old.child;
      _setupAnimations();
      _ctrl.forward(from: 0).then((_) {
        if (mounted) {
          setState(() => _outgoing = null);
        }
      });
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
        if (_outgoing != null)
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, child) => FadeTransition(
              opacity: Tween(begin: 1.0, end: 0.0).animate(
                CurvedAnimation(
                  parent: _ctrl,
                  curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
                ),
              ),
              child: SlideTransition(position: _slideOut, child: child),
            ),
            child: _outgoing,
          ),
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, child) => FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _ctrl,
                curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
              ),
            ),
            child: SlideTransition(position: _slideIn, child: child),
          ),
          child: widget.child,
        ),
      ],
    );
  }
}
