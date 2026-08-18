import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../localization/locale_keys.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/color_utils.dart';
import '../../../theme/theme_context.dart';

/// A standardized search field with debounce, clear button, and design system integration.
class UnifiedSearchField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final String? hintLocaleKey;
  final String? initialValue;
  final Duration debounceDuration;
  final EdgeInsetsGeometry? margin;

  const UnifiedSearchField({
    super.key,
    required this.onChanged,
    this.onClear,
    this.hintLocaleKey,
    this.initialValue,
    this.debounceDuration = const Duration(milliseconds: 350),
    this.margin,
  });

  @override
  State<UnifiedSearchField> createState() => _UnifiedSearchFieldState();
}

class _UnifiedSearchFieldState extends State<UnifiedSearchField> {
  late final TextEditingController _controller;
  Timer? _debounce;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _showClear = _controller.text.isNotEmpty;
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
    final hint = (widget.hintLocaleKey ?? LocaleKeys.commonSearch).tr();

    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: context.appSurfaceColor,
          borderRadius: AppRadius.circularXl,
          border: Border.all(
            color: AppColors.borderLight.withValues(alpha: 0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          onChanged: _onSearchChanged,
          style: TextStyle(
            color: context.appOnSurfaceColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: context.appSecondaryTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(start: 8),
              child: Icon(Icons.search_rounded, color: primaryColor, size: 22),
            ),
            suffixIcon: _showClear
                ? IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondaryLight,
                      size: 18,
                    ),
                    onPressed: () {
                      _controller.clear();
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      widget.onChanged('');
                      widget.onClear?.call();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }
}
