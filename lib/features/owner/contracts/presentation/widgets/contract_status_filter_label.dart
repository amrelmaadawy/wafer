import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../domain/entities/contract_status_filter.dart';

extension ContractStatusFilterLabel on ContractStatusFilter {
  String get localizedLabel => switch (this) {
    ContractStatusFilter.all => LocaleKeys.contractsFilterAll.tr(),
    ContractStatusFilter.active => LocaleKeys.contractsFilterActive.tr(),
    ContractStatusFilter.expiring => LocaleKeys.contractsFilterExpiring.tr(),
    ContractStatusFilter.draft => LocaleKeys.contractsFilterDraft.tr(),
    ContractStatusFilter.terminated =>
      LocaleKeys.contractsFilterTerminated.tr(),
  };
}
