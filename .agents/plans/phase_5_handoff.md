# Phase 5 Handoff

## Status

Phase 5 has started. The dashboard is complete and verified for the confirmed
mobile API scope. Property/period filters and the remaining website-only
metrics are API-blocked and were not fabricated.

## Confirmed API scope

- `GET owner/dashboard` without documented query parameters.
- Financial summary, occupancy, installment statistics, overdue installments,
  tasks, legal cases, alerts, and quick-action data already returned by the
  endpoint.

The workspace contains no confirmed dashboard property/period query contract
or response fields for portfolio score, net monthly cash flow, collection
rates/time series, or upcoming legal sessions.

## Completed

- Centralized the dashboard endpoint in `ApiConstants`.
- Added defensive response parsing for numeric strings, malformed lists, and
  renter/tenant naming variants.
- Split dashboard models and entities into focused files.
- Rebuilt the dashboard with responsive compact and expanded layouts.
- Added dynamic light/dark surfaces, borders, overlays, and skeleton states.
- Reworked financial, occupancy, installment, overdue, alert, task/legal, and
  quick-action widgets.
- Removed unused maintenance and receipt widgets that were no longer rendered.
- Kept all dashboard production Dart files at or below 150 lines.
- Added dashboard model parsing tests.

## Verification

- Dashboard and related core files analyze with no issues.
- Dashboard tests: 10/10 passed.
- Regression suites verified independently:
  - widget: 1/1 passed.
  - core: 5/5 passed.
  - owner properties: 10/10 passed.
  - owner contracts: 5/5 passed.
- Total verified tests: 31/31.
- `git diff --check`: passed.

## Required API input for remaining dashboard parity

- Exact period query key and supported enum/value set.
- Exact property query key and the source of selectable owner properties.
- Cache ownership and filter-key semantics.
- Exact response keys and types for portfolio score, net monthly cash flow,
  collection totals/rates/time series, and upcoming legal sessions.

After those contracts are supplied, add a typed dashboard filter entity through
Data, Domain, Cubit, and UI, then add the remaining typed metric entities.

## Next Phase 5 backlog item

The next independent P1 item is the standalone portfolio units destination.
