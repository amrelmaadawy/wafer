import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../domain/entities/contract_details_entity.dart';

class ContractDocumentsTab extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractDocumentsTab({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return CustomEmptyWidget(
      icon: Icons.folder_open_outlined,
      title: LocaleKeys.contractDetailsNoDocuments.tr(),
      subtitle: LocaleKeys.dashboard_no_data.tr(),
    );
  }
}
