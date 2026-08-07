import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/journal_entries_response_model.dart';
import '../models/journal_entry_model.dart';
import '../../domain/entities/create_journal_entry_request_entity.dart';
import '../../domain/entities/update_journal_entry_request_entity.dart';

abstract class JournalEntriesRemoteDataSource {
  Future<JournalEntriesResponseModel> getJournalEntries({required int page});
  Future<JournalEntryModel> createJournalEntry(CreateJournalEntryRequestEntity request);
  Future<JournalEntryModel> updateJournalEntry(UpdateJournalEntryRequestEntity request);
}

class JournalEntriesRemoteDataSourceImpl implements JournalEntriesRemoteDataSource {
  final Dio _dio;

  JournalEntriesRemoteDataSourceImpl(this._dio);

  @override
  Future<JournalEntriesResponseModel> getJournalEntries({required int page}) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}owner/accounting/journal-entries',
        queryParameters: {'page': page},
      );
      
      final responseData = response.data as Map<String, dynamic>? ?? {};
      
      if (responseData['success'] == true && responseData['data'] != null) {
        return JournalEntriesResponseModel.fromJson(responseData['data']);
      }
      
      throw ServerException(responseData['message'] ?? 'Failed to load journal entries');
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<JournalEntryModel> createJournalEntry(CreateJournalEntryRequestEntity request) async {
    try {
      final response = await _dio.post(
        ApiConstants.ownerAccountingJournalEntries,
        data: request.toJson(),
      );

      final responseData = response.data as Map<String, dynamic>? ?? {};
      if (responseData['success'] == true && responseData['data'] != null) {
        return JournalEntryModel.fromJson(responseData['data']['journal_entry']);
      }
      
      throw ServerException(responseData['message'] ?? 'Failed to create journal entry');
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<JournalEntryModel> updateJournalEntry(UpdateJournalEntryRequestEntity request) async {
    try {
      final response = await _dio.patch(
        '${ApiConstants.ownerAccountingJournalEntries}/${request.journalEntryId}',
        data: request.toJson(),
      );

      final responseData = response.data as Map<String, dynamic>? ?? {};
      if (responseData['success'] == true && responseData['data'] != null) {
        return JournalEntryModel.fromJson(responseData['data']['journal_entry']);
      }
      
      throw ServerException(responseData['message'] ?? 'Failed to update journal entry');
    } on DioException {
      rethrow;
    }
  }
}
