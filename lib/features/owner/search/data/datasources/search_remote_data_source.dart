import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../../domain/entities/search_result_entity.dart';
import '../../domain/entities/search_results_grouped_entity.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResultsGroupedEntity> search(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl(this.dio);

  @override
  Future<SearchResultsGroupedEntity> search(String query) async {
    final queryParams = {'search': query};

    final results = await Future.wait([
      _searchProperties(queryParams),
      _searchContracts(queryParams),
      _searchPayments(queryParams),
      _searchReceipts(queryParams),
      _searchMaintenance(queryParams),
      _searchTasks(queryParams),
      _searchLegalCases(queryParams),
    ]);

    return SearchResultsGroupedEntity(
      properties: results[0],
      contracts: results[1],
      payments: results[2],
      receipts: results[3],
      maintenance: results[4],
      tasks: results[5],
      legalCases: results[6],
    );
  }

  Future<List<SearchResultEntity>> _searchProperties(
      Map<String, dynamic> queryParams) async {
    try {
      final response = await dio.get(
        ApiConstants.ownerProperties,
        queryParameters: queryParams,
      );
      return _parseResults(
        response,
        SearchResultType.property,
        titleKey: 'name',
        subtitleKey: 'reference',
      );
    } catch (_) {
      return [];
    }
  }

  Future<List<SearchResultEntity>> _searchContracts(
      Map<String, dynamic> queryParams) async {
    try {
      final response = await dio.get(
        ApiConstants.ownerContracts,
        queryParameters: queryParams,
      );
      return _parseResults(
        response,
        SearchResultType.contract,
        titleKey: 'contract_number',
        subtitleKey: 'status',
      );
    } catch (_) {
      return [];
    }
  }

  Future<List<SearchResultEntity>> _searchPayments(
      Map<String, dynamic> queryParams) async {
    try {
      final response = await dio.get(
        ApiConstants.ownerAccountingPayments,
        queryParameters: queryParams,
      );
      return _parseResults(
        response,
        SearchResultType.payment,
        titleKey: 'reference',
        subtitleKey: 'amount',
      );
    } catch (_) {
      return [];
    }
  }

  Future<List<SearchResultEntity>> _searchReceipts(
      Map<String, dynamic> queryParams) async {
    try {
      final response = await dio.get(
        ApiConstants.ownerAccountingReceipts,
        queryParameters: queryParams,
      );
      return _parseResults(
        response,
        SearchResultType.receipt,
        titleKey: 'receipt_number',
        subtitleKey: 'amount',
      );
    } catch (_) {
      return [];
    }
  }

  Future<List<SearchResultEntity>> _searchMaintenance(
      Map<String, dynamic> queryParams) async {
    try {
      final response = await dio.get(
        ApiConstants.ownerMaintenance,
        queryParameters: queryParams,
      );
      return _parseResults(
        response,
        SearchResultType.maintenance,
        titleKey: 'reference',
        subtitleKey: 'status',
      );
    } catch (_) {
      return [];
    }
  }

  Future<List<SearchResultEntity>> _searchTasks(
      Map<String, dynamic> queryParams) async {
    try {
      // Endpoint hardcoded because it's not in ApiConstants
      final response = await dio.get(
        '${ApiConstants.baseUrl}owner/tasks',
        queryParameters: queryParams,
      );
      return _parseResults(
        response,
        SearchResultType.task,
        titleKey: 'title',
        subtitleKey: 'status',
      );
    } catch (_) {
      return [];
    }
  }

  Future<List<SearchResultEntity>> _searchLegalCases(
      Map<String, dynamic> queryParams) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}owner/legal-cases',
        queryParameters: queryParams,
      );
      return _parseResults(
        response,
        SearchResultType.legalCase,
        titleKey: 'case_number',
        subtitleKey: 'status',
      );
    } catch (_) {
      return [];
    }
  }

  List<SearchResultEntity> _parseResults(
    Response response,
    SearchResultType type, {
    required String titleKey,
    required String subtitleKey,
  }) {
    final List<SearchResultEntity> results = [];
    final dataMap = response.data;
    if (dataMap == null || dataMap is! Map) return results;

    final dataList = dataMap['data'];
    if (dataList == null) return results;

    // Usually pagination is handled by a nested 'data' array or items are in dataList directly
    List<dynamic> items = [];
    if (dataList is Map && dataList['data'] is List) {
      items = dataList['data'];
    } else if (dataList is List) {
      items = dataList;
    } else if (dataMap['items'] is List) {
      items = dataMap['items']; // for maintenance/tasks
    } else if (dataList is Map && dataList['items'] is List) {
      items = dataList['items'];
    }

    for (final item in items) {
      if (item is Map<String, dynamic>) {
        final id = item['id'] as int?;
        if (id == null) continue;

        String title = item[titleKey]?.toString() ?? 'Unknown';
        String subtitle = item[subtitleKey]?.toString() ?? '';

        results.add(SearchResultEntity(
          id: id,
          type: type,
          title: title,
          subtitle: subtitle,
          extra: item, // Keep the full map in extra just in case we need it
        ));
      }
    }

    return results;
  }
}
