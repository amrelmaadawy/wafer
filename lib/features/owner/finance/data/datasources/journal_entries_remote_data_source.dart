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
  Future<JournalEntryModel> postJournalEntry(int id);
  Future<JournalEntryModel> reverseJournalEntry(int id, String reason);
}

class JournalEntriesRemoteDataSourceImpl implements JournalEntriesRemoteDataSource {
  final Dio _dio;

  JournalEntriesRemoteDataSourceImpl(this._dio);

  String _extractErrorMessage(Map<String, dynamic> responseData, String defaultMessage) {
    if (responseData.containsKey('errors') && responseData['errors'] is Map) {
      final errors = responseData['errors'] as Map;
      final StringBuffer sb = StringBuffer();
      errors.forEach((key, value) {
        if (value is List) {
          sb.writeln(value.join('\n'));
        } else {
          sb.writeln(value.toString());
        }
      });
      if (sb.isNotEmpty) {
        return sb.toString().trim();
      }
    }
    return responseData['message'] ?? defaultMessage;
  }

  @override
  Future<JournalEntriesResponseModel> getJournalEntries({required int page}) async {
    try {
      final response = await _dio.get(
        ApiConstants.ownerAccountingJournalEntries,
        queryParameters: {'page': page},
      );
      
      final responseData = response.data as Map<String, dynamic>? ?? {};
      
      if (responseData['success'] == true && responseData['data'] != null) {
        return JournalEntriesResponseModel.fromJson(responseData['data']);
      }
      
      throw ServerException(_extractErrorMessage(responseData, 'Failed to load journal entries'));
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
      
      throw ServerException(_extractErrorMessage(responseData, 'Failed to create journal entry'));
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
      
      throw ServerException(_extractErrorMessage(responseData, 'Failed to update journal entry'));
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<JournalEntryModel> postJournalEntry(int id) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.ownerAccountingJournalEntries}/$id/action',
        data: {'action': 'post'},
      );

      final responseData = response.data as Map<String, dynamic>? ?? {};
      if (responseData['success'] == true && responseData['data'] != null) {
        return JournalEntryModel.fromJson(responseData['data']['journal_entry']);
      }
      throw ServerException(_extractErrorMessage(responseData, 'Failed to post journal entry'));
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<JournalEntryModel> reverseJournalEntry(int id, String reason) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.ownerAccountingJournalEntries}/$id/action',
        data: {'action': 'reverse', 'reason': reason},
      );

      final responseData = response.data as Map<String, dynamic>? ?? {};
      if (responseData['success'] == true && responseData['data'] != null) {
        return JournalEntryModel.fromJson(responseData['data']['journal_entry']);
      }
      throw ServerException(_extractErrorMessage(responseData, 'Failed to reverse journal entry'));
    } on DioException {
      rethrow;
    }
  }
}
