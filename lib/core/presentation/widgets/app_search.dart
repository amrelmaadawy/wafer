import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../localization/locale_keys.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/color_utils.dart';
import '../../theme/theme_context.dart';

/// A reusable, debounced search field with clear functionality.
/// Uses easy_localization for all text.
/// Calls [onChanged] after [debounceDuration] of inactivity.
class AppSearch extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String? hintLocaleKey;
  final Duration debounceDuration;
  final bool autofocus;

  const AppSearch({
    super.key,
    required this.onChanged,
    this.hintLocaleKey,
    this.debounceDuration = const Duration(milliseconds: 400),
    this.autofocus = false,
  });

  @override
  State<AppSearch> createState() => _AppSearchState();
}

class _AppSearchState extends State<AppSearch> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (_showClear != hasText) {
      setState(() => _showClear = hasText);
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;
    
    return Container(
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        onChanged: _onSearchChanged,
        style: TextStyle(
          color: context.appOnSurfaceColor,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: (widget.hintLocaleKey ?? LocaleKeys.commonSearch).tr(),
          hintStyle: TextStyle(
            color: context.appSecondaryTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(start: 8),
            child: Icon(Icons.search_rounded, color: primaryColor, size: 24),
          ),
          suffixIcon: _showClear
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textLight, size: 20),
                  onPressed: () {
                    _controller.clear();
                    _onSearchChanged('');
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
