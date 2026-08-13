# Phase 4 Handoff

## Status

Phase 4 is complete for the confirmed mobile API scope. The owner contracts
area now provides production list, details, and installments experiences.
Unconfirmed mutation and export workflows remain intentionally unavailable.

## Confirmed API scope

- Paginated contract list.
- Contract status query filter.
- Contract details.
- Contract installments.

No endpoint/body/response contract exists in the workspace for contract
creation, renewal, amendment requests, installment collection, cancellation,
preview, or export. Phase 4 does not expose speculative actions.

## Completed

- Replaced the contracts coming-soon placeholder with a functional screen.
- Added typed `ContractStatusFilter` through Data, Domain, Cubit, and UI.
- Added loading, error/retry, empty, refresh, and paginated loaded states.
- Added responsive list/grid presentation and constrained expanded layouts.
- Added centralized GoRouter paths for contract details and installments.
- Rebuilt list cards and filter controls with dynamic theme support.
- Reworked contract list and details parsing with defensive typed values.
- Removed Arabic/hardcoded fallback data from API models.
- Added renter/tenant response compatibility.
- Reorganized details into progressive mobile sections and two expanded
  columns.
- Converted installment filters to typed `InstallmentStatusFilter`.
- Moved installment financial totals and progress calculations into a Domain
  entity.
- Rebuilt installment summary/cards and localized date formatting.
- Updated empty and skeleton states for light/dark themes.
- Kept all contract source and test files at or below 150 lines.

## Verification

- Contracts, routing, and Phase 4 tests analyze with no issues.
- Phase 4 tests: 5/5 passed.
- Existing suites verified independently:
  - widget: 1/1 passed.
  - core: 5/5 passed.
  - owner dashboard: 7/7 passed.
  - owner properties: 10/10 passed.
  - owner contracts: 5/5 passed.
- Total verified tests: 28/28.
- `git diff --check`: passed.

## Test runner note

One combined Flutter test invocation timed out without emitting test output.
Running every suite independently completed successfully. The known
`test/scratch_test.dart` Hive test remains excluded, as documented in prior
handoffs.

## Required input for deferred workflows

Provide the exact mobile API method, endpoint, request body/query, success
response, validation errors, permissions, and lifecycle rules before enabling
create, renew, amend, collect, cancel, preview, or export actions.
