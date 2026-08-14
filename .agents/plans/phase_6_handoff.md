# Phase 6 Handoff

## Status

Phase 6 (P2 product initiatives) has started with an API-contract and ownership
audit. Feature implementation is blocked before code generation because the
workspace and public official documentation expose no mobile API contracts for
warehouse, clients, tenant support tickets, establishment administration,
dedicated banks, or trial balance.

No endpoint, request body, response shape, permission, lifecycle rule, or
multi-tenant ownership rule was invented.

## Audit evidence

- `ApiConstants` contains owner dashboard, accounting, reports, maintenance,
  properties, deeds, units, contracts, and shared profile/notification routes.
- No `warehouse`, `inventory`, `stock`, `supplier`, `client`, `ticket`,
  `establishment`, `bank-account`, or `trial-balance` mobile endpoint exists.
- No Data, Domain, Presentation, DI, route, fixture, OpenAPI, Swagger, or
  Postman contract exists for those bounded contexts.
- An official-domain search produced no published mobile API documentation for
  warehouse or inventory routes.
- Existing maintenance client fields and finance account options are contextual
  values. They are not contracts for standalone clients or bank management.

## First implementation target: Warehouse

Once the API contract is supplied, implement `features/owner/warehouse` as an
independent bounded context with:

1. Domain: warehouse, inventory item, stock balance, movement, supplier,
   property consumption, low-stock rule, typed filters, repository contracts,
   and use cases.
2. Data: defensive models, Dio remote data source, repository implementation,
   pagination/cache ownership, and centralized `ApiConstants` entries.
3. Presentation: responsive overview, item list/detail, movement history,
   supplier list, filters/search, loading/error/empty states, and authorized
   mutations only.
4. DI and navigation: isolated registration and guarded typed GoRouter routes.
5. Tests: model parsing, repositories, use cases, Cubits, pagination,
   permissions, and responsive widgets.

## Required warehouse API contract

For every operation provide the HTTP method, exact mobile path, query/body,
success response, validation errors, permissions, and state rules:

- Warehouse list/detail and form-data.
- Inventory item list/detail/create/update/archive.
- Stock balances by warehouse and property.
- Stock movement list/detail/create/cancel.
- Supplier list/detail/create/update/archive.
- Property consumption list/create/detail.
- Low-stock configuration and alerts.
- Pagination, search, filter, sort, and export semantics.

Every payload must define company, branch, owner, property, warehouse, actor,
currency/unit, timestamps, and audit ownership where applicable.

## Remaining P2 contracts

- Clients: identity/contact/access/status, ownership and privacy scope.
- Tenant support: ticket messages, attachments, assignment, status, and
  notification semantics.
- Establishment/users/permissions: roles, permission matrix, branch scope,
  invitations, activation, and audit rules.
- Banks/trial balance: bank-account ownership, accounting periods, posting
  state, filters, zero-balance behavior, and export contracts.

## Verification baseline

The Phase 5 regression baseline remains green at 44/44 tests, targeted analysis
has no issues, and `git diff --check` passes. Phase 6 adds no production code
until an exact contract is available.
