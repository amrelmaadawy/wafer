# Cache Policy and Strategy

## Cache Key Strategy
- The cache key MUST include the HTTP Method + Full URL + Query Parameters.
- The cache key MUST NOT include volatile headers such as the `Authorization` token, `Date`, or random tracking headers. Including these will cause every request to miss the cache.
- `dio_cache_interceptor` handles this correctly by default (it uses URL + Method + Query params), but we must ensure we don't accidentally override the key builder to include the auth token.

## Cache Eviction Policy
- **Dashboard & Reports**: 5-10 minutes Time-To-Live (TTL). Stale-while-revalidate is allowed.
- **Static/Reference Data**: 24 hours TTL.
- **Max Cache Size**: Configured via the store (e.g., Hive store limits or manual clear if needed, though `dio_cache_interceptor` with Hive doesn't strictly have a size limit, we will clear on logout).
- **Security**: The entire cache MUST be cleared on logout (`AuthRepository.logout()`) to prevent data leakage between different users on the same device.
- **Versioning/Schema**: The Hive store will be named with a version tag (e.g., `codra_cache_v1`). If the schema changes, we bump the version and discard the old cache.
