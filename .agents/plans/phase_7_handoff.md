# Phase 7 Handoff

## Status

Phase 7 (owner clients) has started with a contract, privacy, and ownership
audit. Production implementation is blocked because no standalone owner client
API or feature contract exists in the workspace.

The existing contextual user/client values cannot safely be promoted into a
client directory:

- Maintenance creation accepts only inline `client_name` and `client_phone`.
- Maintenance responses may include a small client reference scoped to the
  maintenance request.
- Accounting form-data exposes generic dropdown `value` and `label` options.
- Authentication exposes the signed-in user's account metadata, not an owner
  client collection.

These shapes provide no client ownership, access status, identity lifecycle,
privacy policy, pagination, or CRUD semantics.

## Required API contract

Provide the exact HTTP method, mobile endpoint, query/body, response, errors,
permissions, and ownership rules for:

- Client list with pagination, search, typed filters, and sorting.
- Client details and permitted contact/identity fields.
- Client creation, update, activation/deactivation, archive, and restore.
- Client-property, unit, contract, payment, and maintenance relationships.
- Client access/invitation state and account linking.
- Form-data for client types, identity types, statuses, countries, and branches.
- Document list/upload/preview/download permissions, if included.
- Export semantics and redaction rules, if included.

Every response must define owner/company/branch scope and whether the record is
a tenant, prospect, payer, beneficiary, maintenance contact, or another client
type. The API must enforce authorization; hiding UI is insufficient.

## Planned architecture after contract approval

1. `features/owner/clients/domain`: immutable client entities, typed query,
   repository, and focused use cases.
2. `features/owner/clients/data`: defensive models, Dio data source, repository
   implementation, cache ownership, and centralized endpoints.
3. `features/owner/clients/presentation`: responsive list/detail, search,
   filters, loading/error/empty states, and permission-aware actions.
4. Isolated GetIt registration and guarded typed GoRouter routes.
5. Repository, use-case, Cubit, parsing, privacy, pagination, and responsive
   widget tests.

## UX direction

- Mobile-first cards with a compact tablet list mode.
- Clear client type and access-status badges supplied by the API.
- Progressive detail sections for contact, relationships, financial summary,
  maintenance, and documents, shown only when authorized.
- Sensitive identity fields masked by default and excluded from logs.
- Empty, offline, permission-denied, loading, and retry states localized in
  Arabic and English.

## Verification baseline

No production code, endpoint, navigation item, or placeholder screen was added.
The verified Phase 5 baseline remains 44/44 tests with clean analysis and
`git diff --check`.

## Next initiative

If the client API contract remains unavailable, the next P2 initiative is
tenant support tickets. It also requires a dedicated messaging, attachment,
notification, ownership, and status-transition contract before implementation.
