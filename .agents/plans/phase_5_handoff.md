# Phase 5 Handoff

## Status

Phase 5 is in progress. The dashboard confirmed scope, standalone portfolio
units destination, and confirmed read-only tasks overview are complete and
verified. Report export parity for confirmed local builders is also complete.
Dashboard property/period filters, website-only metrics, contract
lifecycle mutations, and operational task mutations remain API-blocked and
were not fabricated.

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

### Standalone portfolio units

- Promoted the confirmed units-status report into a professional portfolio-wide
  units destination without inventing a new endpoint.
- Added direct access from the properties header.
- Added responsive one/two/three-column cards and a compact list mode.
- Added portfolio summary metrics and confirmed property/status filters.
- Preserved the confirmed local PDF export and removed the unfinished Excel
  action from this destination.
- Connected each unit to its existing typed details route using property and
  unit identifiers.
- Removed the remaining `dynamic activeContract` report field rather than
  exposing an unconfirmed response shape.
- Centralized the existing units-status endpoint through `ApiConstants`.
- Hardened unit, filter-option, summary, property, and pagination parsing.
- Fixed all-filter sentinel handling and pagination retry state.
- Added Arabic/English labels and removed the obsolete units list widget.
- Kept every new and materially refactored units file at or below 150 lines.

### Tasks overview

- Added a standalone `/owner/tasks` destination backed by the confirmed
  `owner/reports/employee-tasks` endpoint.
- Connected the dashboard tasks card directly to the new destination.
- Rebuilt the employee workload experience with responsive one/two/three
  column cards and dynamic light/dark surfaces.
- Added completed, pending, overdue, and employee summary metrics.
- Preserved the confirmed PDF and Excel exports with safe file names.
- Added a localized read-only notice so unsupported mutations are not implied.
- Centralized the confirmed `owner/tasks/form-data` endpoint.
- Hardened employee, summary, nested report, and pagination parsing.
- Prevented duplicate concurrent pagination requests and preserved loaded
  content while loading additional pages.
- Added Arabic/English destination, scope, and export labels.
- Kept every new and materially refactored tasks file at or below 150 lines.

Individual task list/detail, Kanban, search/filter, create, edit, delete,
assignee updates, progress changes, and comments remain blocked because the
workspace exposes form-data but no method/endpoint/body/response contracts for
those operations.

### Finance and report parity

- Replaced the shared hard-coded report export control with Arabic/English
  localized labels and dynamic light/dark surfaces.
- Connected the legal-cases report to its existing confirmed local PDF and
  Excel builders and export services.
- Preserved the confirmed server-provided legal-case status filter.
- Removed the approvals report's misleading PDF/Excel actions because no
  approval export builder or API contract exists in the workspace.
- Localized the approvals empty state and aligned both touched report screens
  with the active scaffold theme.
- Added widget coverage for opening export choices and invoking the selected
  export callback.

### Operational approvals foundation

- Audited the workspace and confirmed that `GET owner/reports/approvals` is a
  read-only report, not an operational approval inbox contract.
- Confirmed that maintenance and transfer approval mutations are scoped to
  their own bounded contexts and cannot be reused as generic approval actions.
- Removed `dynamic` access from approval summary and item rendering.
- Preserved the typed loaded report while fetching subsequent pages, fixing a
  pagination-time runtime failure where the UI attempted to read `report` from
  a loading state that did not expose it.
- Added a Cubit test covering typed pagination preservation and page merging.
- Kept generic approve/reject actions hidden until dedicated endpoints,
  permissions, request bodies, responses, and state-transition rules exist.

## Verification

- Dashboard and related core files analyze with no issues.
- Dashboard tests: 10/10 passed.
- Portfolio units tests: 5/5 passed.
- Tasks overview tests: 5/5 passed.
- Regression suites verified independently:
  - widget: 1/1 passed.
  - core: 5/5 passed.
  - owner properties: 10/10 passed.
  - owner contracts: 5/5 passed.
- Report tests: 13/13 passed.
- Total verified tests: 44/44.
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

Contract lifecycle actions were audited against the current workspace, Git
history, and publicly discoverable official documentation. Creation, renewal,
amendment, collection, cancellation, and contract-document preview remain
blocked until exact method/endpoint/body/response, permissions, validation,
and lifecycle contracts are supplied. The unused legacy
`contract/owner/cancel` constant was removed because it had no method, body,
response, caller, or supporting history and must not be treated as an API
contract.

Finance/report filter and export parity is complete for all capabilities
confirmed by the current workspace. Trial balance, dedicated banking UX, and
approvals export remain API/product-contract blocked and were not fabricated.

The operational approvals foundation is hardened and read-only. Completing an
actionable inbox requires dedicated typed list/detail/history and
approve/reject API contracts plus permission and state-transition rules; the
existing approvals report cannot be treated as an operational endpoint.

The P1 backlog is complete within the API contracts confirmed by this
workspace. P2 starts with warehouse, followed by clients, tenant support
tickets, establishment/users/permissions settings, and dedicated banks/trial
balance. None currently has a mobile API contract in `ApiConstants`, so the
next implementation requires a product decision and exact API contracts.
