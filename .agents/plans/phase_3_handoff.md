# Phase 3 Handoff

## Status

Phase 3 is complete. The property and property-scoped unit experience now has
responsive presentation, typed filters and contracts, clearer information
hierarchy, and persisted display preferences.

## Completed

- Added comfortable and compact property display modes with a professional
  segmented control and persisted preference.
- Added responsive property grids and a compact property card.
- Replaced string sorting with `PropertySortField` and kept unsupported sort
  parameters out of the API request.
- Connected advanced filters to typed form-data options and fresh server
  requests.
- Added responsive filter sheet behavior for phone and tablet/desktop.
- Added active-filter labels resolved from server-provided options.
- Reorganized property details into responsive overview cards and metrics.
- Added an explicit incomplete-data card for important draft fields.
- Replaced unit `dynamic` current contract and history with
  `ContractEntity` values and defensive model parsing.
- Added tenant/renter compatibility and safe contract status parsing.
- Reorganized unit details into progressive mobile sections and a two-column
  expanded layout.
- Removed the fixed light unit-details background so dynamic themes work.

## Verification

- Property feature analysis: no issues.
- Property feature tests: 10/10 passed.
- Full test suite excluding the known scratch test: 23/23 passed.
- Final contract parser tests after file splitting: 2/2 passed.
- New and materially refactored unit-detail files remain below 150 lines.

## Known unrelated issue

`test/scratch_test.dart` is excluded because it can open the Hive
`codra_cache_v1` box more than once and leave `test_cache_dir/`. This issue
predates Phase 3 and does not affect production code or the verified suite.

## Recommended Phase 4 entry

Continue the parity backlog with typed contract list filters and authorized
contract workflows. Verify every request and response against the mobile API
before adding create, renew, amendment, collection, or export actions.
