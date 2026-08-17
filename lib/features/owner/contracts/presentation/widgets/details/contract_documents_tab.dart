import 'package:flutter/material.dart';
import '../../../../../../core/documents/widgets/documents_list_widget.dart';
import '../../../domain/entities/contract_details_entity.dart';

class ContractDocumentsTab extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractDocumentsTab({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return const DocumentsListWidget(
      documents: [],
      isScrollable: true,
    );
  }
}
