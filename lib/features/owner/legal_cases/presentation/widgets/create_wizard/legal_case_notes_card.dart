import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import 'legal_case_wizard_card.dart';

class LegalCaseNotesCard extends StatelessWidget {
  final TextEditingController notesController;

  const LegalCaseNotesCard({super.key, required this.notesController});

  @override
  Widget build(BuildContext context) {
    return LegalCaseWizardCard(
      title: LocaleKeys.additional_notes.tr(),
      children: [
        CustomTextField(
          controller: notesController,
          label: LocaleKeys.notes.tr(),
          hintText: LocaleKeys.enter_notes.tr(),
          maxLines: 4,
        ),
      ],
    );
  }
}
