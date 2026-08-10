import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wafer/features/owner/dashboard/data/datasources/owner_dashboard_remote_data_source.dart';
import 'package:wafer/features/owner/dashboard/data/repositories/owner_dashboard_repository_impl.dart';
import 'package:wafer/features/owner/dashboard/data/models/owner_dashboard_model.dart';
import 'package:wafer/core/error/failures.dart';

class MockOwnerDashboardRemoteDataSource extends Mock implements OwnerDashboardRemoteDataSource {}

void main() {
  late OwnerDashboardRepositoryImpl repository;
  late MockOwnerDashboardRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockOwnerDashboardRemoteDataSource();
    repository = OwnerDashboardRepositoryImpl(mockRemoteDataSource);
  });

  final tDashboardModel = OwnerDashboardModel.fromJson(const {}); // Empty or mock data

  group('getDashboardStats', () {
    test('should return remote data when the call to remote data source is successful', () async {
      // arrange
      when(() => mockRemoteDataSource.getDashboardStats(forceRefresh: any(named: 'forceRefresh')))
          .thenAnswer((_) async => tDashboardModel);
      // act
      final result = await repository.getDashboardStats();
      // assert
      verify(() => mockRemoteDataSource.getDashboardStats(forceRefresh: false));
      expect(result, equals(Right(tDashboardModel)));
    });

    test('should pass forceRefresh flag to data source', () async {
      // arrange
      when(() => mockRemoteDataSource.getDashboardStats(forceRefresh: any(named: 'forceRefresh')))
          .thenAnswer((_) async => tDashboardModel);
      // act
      final result = await repository.getDashboardStats(forceRefresh: true);
      // assert
      verify(() => mockRemoteDataSource.getDashboardStats(forceRefresh: true));
      expect(result, equals(Right(tDashboardModel)));
    });

    test('should retry with forceRefresh=true if cache deserialization fails with TypeError', () async {
      // arrange
      when(() => mockRemoteDataSource.getDashboardStats(forceRefresh: false))
          .thenThrow(TypeError());
      when(() => mockRemoteDataSource.getDashboardStats(forceRefresh: true))
          .thenAnswer((_) async => tDashboardModel);
      // act
      final result = await repository.getDashboardStats(forceRefresh: false);
      // assert
      verify(() => mockRemoteDataSource.getDashboardStats(forceRefresh: false));
      verify(() => mockRemoteDataSource.getDashboardStats(forceRefresh: true));
      expect(result, equals(Right(tDashboardModel)));
    });

    test('should return ServerFailure if both cache and forceRefresh network calls fail with type error', () async {
      // arrange
      when(() => mockRemoteDataSource.getDashboardStats(forceRefresh: any(named: 'forceRefresh')))
          .thenThrow(TypeError());
      // act
      final result = await repository.getDashboardStats(forceRefresh: false);
      // assert
      expect(result, equals(const Left(ServerFailure("Data format error"))));
    });
  });
}
