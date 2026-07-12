class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'An error occurred with the server.']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'An error occurred with the cache.']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection.']);
}
