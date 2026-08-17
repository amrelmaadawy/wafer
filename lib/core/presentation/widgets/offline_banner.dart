import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../di/service_locator.dart';
import '../../localization/locale_keys.dart';
import '../../services/connectivity_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';

class OfflineBannerWidget extends StatefulWidget {
  final Widget child;

  const OfflineBannerWidget({super.key, required this.child});

  @override
  State<OfflineBannerWidget> createState() => _OfflineBannerWidgetState();
}

class _OfflineBannerWidgetState extends State<OfflineBannerWidget> {
  late final ConnectivityService _connectivityService;
  StreamSubscription<bool>? _subscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _connectivityService = sl<ConnectivityService>();
    _checkInitialStatus();
    _subscription = _connectivityService.onConnectivityChanged.listen((isOnline) {
      if (mounted && _isOffline != !isOnline) {
        setState(() {
          _isOffline = !isOnline;
        });
      }
    });
  }

  Future<void> _checkInitialStatus() async {
    final isOnline = await _connectivityService.isConnected;
    if (mounted && _isOffline != !isOnline) {
      setState(() {
        _isOffline = !isOnline;
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              _isOffline ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            color: AppColors.secondaryDark,
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    LocaleKeys.offlineMode.tr(),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}
