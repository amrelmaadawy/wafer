import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/color_utils.dart';
import '../widgets/login_form_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale.languageCode == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(context),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 48),
                      _buildBrand(context),
                      const SizedBox(height: 32),
                      _buildFormCard(context),
                      const SizedBox(height: 24),
                      _buildFooter(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 38,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [context.primaryDark, context.primaryColor, context.primaryLight],
              ),
            ),
          ),
        ),
        Expanded(flex: 62, child: Container(color: const Color(0xFFF4F6FB))),
      ],
    );
  }

  Widget _buildBrand(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 20, offset: const Offset(0, 6))],
          ),
          child: Center(child: Icon(Icons.home_work_rounded, size: 34, color: context.primaryColor)),
        ),
        const SizedBox(height: 14),
        Text(LocaleKeys.authBrandName.tr(), style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
        const SizedBox(height: 4),
        Text(LocaleKeys.authBrandSubtitle.tr(), style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13)),
      ],
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: context.primaryShadow.withValues(alpha: 0.08), blurRadius: 40, offset: const Offset(0, 12)),
              BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(LocaleKeys.authLoginTitle.tr(), textAlign: TextAlign.center, style: TextStyle(color: context.primaryDark, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(LocaleKeys.authLoginSubtitle.tr(), textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
              const SizedBox(height: 24),
              const LoginFormWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_outline_rounded, size: 12, color: Color(0xFFB0B8CC)),
        const SizedBox(width: 5),
        Text(LocaleKeys.authCopyrights.tr(), style: TextStyle(color: Colors.black.withValues(alpha: 0.35), fontSize: 11.5)),
      ],
    );
  }
}
