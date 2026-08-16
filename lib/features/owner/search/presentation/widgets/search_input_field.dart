import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import 'package:wafer/core/theme/theme_context.dart';

class SearchInputField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String? initialValue;

  const SearchInputField({
    super.key,
    required this.onChanged,
    required this.onClear,
    this.initialValue,
  });

  @override
  State<SearchInputField> createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<SearchInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: true,
      textInputAction: TextInputAction.search,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: LocaleKeys.search_hint.tr(),
        hintStyle: TextStyle(color: context.appSecondaryTextColor),
        prefixIcon: Icon(Icons.search, color: context.appSecondaryTextColor),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, child) {
            return value.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: context.appSecondaryTextColor),
                    onPressed: () {
                      _controller.clear();
                      widget.onClear();
                    },
                  )
                : const SizedBox.shrink();
          },
        ),
        filled: true,
        fillColor: context.appSubtleSurfaceColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1),
        ),
      ),
    );
  }
}
