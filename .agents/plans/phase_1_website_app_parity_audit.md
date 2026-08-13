# Phase 1 — Website/App Parity Audit

## Status

- Scope: authenticated establishment-manager experience on `codra.cloud/tenant/*` versus the current Flutter owner experience.
- Audit date: 2026-08-13.
- Result: audit complete; no production code was changed in this phase.
- Rules baseline: `.agents/rules/rules.md` and `.agents/rules/api_workflow.md`.

## Method

1. Inspected the authenticated website navigation, list pages, detail pages, filters, fields, actions, tables, and empty states.
2. Inspected Flutter routes, bounded contexts, domain entities, models, data sources, Cubits, and presentation widgets.
3. Compared capabilities and data semantics without copying private customer records into this document.
4. Classified each area as `Aligned`, `Partial`, or `Missing`.

## Executive Findings

- The Flutter app covers the main owner domains, but it does not yet mirror the website's complete information architecture.
- The website frequently offers `Cards/Table`, advanced filters, configurable columns, PDF/Excel export, and contextual actions. The app normally offers one mobile card/list presentation.
- Property and unit data coverage is relatively strong, but the app presents less operational context and has no standalone portfolio-wide units destination.
- Dashboard data is broadly aligned, but the website includes portfolio score, monthly net cash flow, cash-flow charts, richer collection metrics, and upcoming legal sessions that are not represented by the current dashboard entity.
- Website-only operational modules include approvals, warehouse, tenant tickets, clients, establishment settings, and a full activity-log explorer.
- Some app modules exist only partially: tasks have data/domain support but no complete destination; contracts lack the website's complete create/renew/amend/collect workflow; finance does not expose all website surfaces.
- The website itself returned a server-error page for the chart-of-accounts URL during this audit. This is a website issue, not an app gap, and must not be reproduced.

## Parity Matrix

| Domain | Website capability | Flutter capability | Status | Required response |
|---|---|---|---|---|
| Dashboard | Portfolio score, net monthly cash flow, collections, arrears, occupancy, contracts, installments, maintenance, tasks, legal cases, overdue table, property/time filters | Finance summary, installment states, occupancy, alerts, arrears, maintenance, tasks/legal summary | Partial | Add missing typed metrics only when supplied by the mobile API; simplify visual hierarchy rather than copying the desktop density |
| Properties list | Cards/table-like data, property/deed grouping, search, owner/branch/city/district/contract/type filters, deed filtering, actions | Cards only, search, basic status/filter sheet, pagination | Partial | Add compact/cards/grid modes, typed advanced filters, sort, result count, deed/branch/location filters, saved display preference |
| Property details | Owners, deed, valuation, structured address and coordinates, units, contracts, finance, maintenance, related deed lands, tasks, attachments, create contract, inline contextual edits | Overview, units, contracts, maintenance, owners, deed, valuation, summary/KPI | Partial | Add missing typed location fields, attachments/tasks/financial activity when API-supported; reorganize into progressive sections |
| Units list | Portfolio-wide list, cards/table, configurable columns, advanced filters, price range, completion state, export, marketing portal | Units are primarily nested inside a property | Missing/Partial | Add a standalone typed units destination or explicitly confirm product decision to keep property-scoped only; add display modes and filters |
| Unit details | Operational and marketing data, property link, status, pricing, media, sharing/marketing actions | Rich specs, dimensions, prices, meters, amenities, media, maintenance, current contract | Partial | Replace dynamic contract/history with typed entities; add missing marketing/share fields only if mobile API exposes them |
| Contracts list | Cards/table, advanced filters, PDF/Excel, view, renew, guided create flow | List/details/installments | Partial | Add typed search/filter/sort and missing authorized workflows: create, renew, amendment request, installment collection |
| Contract details | Parties/property/unit, dates, timeline, financial summary, installments, amendments, renewals, legal links, preview/collection | Details and installments exist | Partial | Verify every website field against mobile response; group details progressively and add permitted actions via use cases |
| Maintenance | List/detail, approvals/rejection, history, assignment and operational tracking | List/create/edit/details, technicians and negotiations | Aligned/Partial | Run field-level response audit; preserve app-specific technician and negotiation flows; unify status and timeline semantics |
| Tasks | Kanban/table, search/filter, create/edit/delete, assignees, progress, comments | Dashboard summary and limited task data integration; no complete task destination | Missing | Create an independent bounded context UI only after endpoint/body/response review per `api_workflow.md` |
| Legal cases | List, filters, export, detail, property/unit/contract links, stages and attachments | List/create/update/detail/stages plus reports | Largely aligned | Add export only if authorized/API-supported; verify court/party/amount/session fields and attachment flow |
| Finance overview | Cashbox and accounting navigation | Finance overview/accounts available | Partial | Align the information architecture without exposing accounting actions not supported by mobile endpoints |
| Receipts | Table/cards, filters, payer, account/revenue classification, journal preview, PDF | List/create/update/detail/cancel | Largely aligned | Verify payer/account/revenue/status fields; add display mode and export only through an approved endpoint/service |
| Payments | List/details/create, filters, beneficiary, expense account, journal data | List/create/update/detail/cancel | Largely aligned | Field-level audit and consistent state/actions |
| Transfers | List/create, from/to accounts, amount, status, reference | List/create/update/approve | Largely aligned | Verify approval semantics and filters |
| Journal entries | List/create, lines, posting status and totals | List/create/update with typed lines | Largely aligned | Verify branch/type/status fields and posting permissions |
| Banks | Dedicated bank-account management | Generic finance accounts; no dedicated bank UX | Missing/Partial | Do not infer equivalence; requires a separate mobile API contract or explicit product decision |
| Trial balance | Date/account-level filters, zero-account option, printable report | Reports center does not expose this report | Missing | Add only with a typed report endpoint and PDF/export service |
| Reports | Units, occupancy, contracts, defaulters, movements, maintenance, technicians, legal, employee tasks, activity, approvals | Most listed reports exist | Largely aligned | Close naming/filter/export gaps; confirm approvals and occupancy-rate variants |
| Approvals | Dedicated pending/history experience | Approval report only; no operational inbox | Missing | Requires dedicated typed endpoints and permission-aware workflow |
| Warehouse | Inventory, warehouses, movements, suppliers, property consumption, low stock | No feature | Missing | Treat as future independent bounded context, not part of the immediate property UI redesign |
| Clients | Client list, identity/contact/type/access/status management | No general clients feature | Missing | Requires ownership/privacy/permissions review and typed API contracts |
| Tenant tickets | Ticket inbox and support workflow | No tenant-ticket feature | Missing | Requires messaging/notification abstraction and API contract |
| Activity log | Searchable/filterable audit explorer with before/after data | Activity report exists | Partial | Keep read-only and permission-gated; add detail explorer only if API supplies safe redacted data |
| Settings | Establishment/branches, users/permissions, approvals, subscription and domain settings | Profile/theme only | Missing | Split into bounded contexts; never add settings based on website HTML alone |
| Profile | Identity, account and job information, update credentials | Profile/edit/password/theme | Largely aligned | Verify identity/job fields, privacy, and mobile API support |

## Data Gaps That Matter to the Client

### Dashboard

- Portfolio score and its interpretation.
- Net monthly cash flow and time-series revenue/expense data.
- Collection total/rate and installment totals as distinct values.
- Maintenance recent-items feed and richer legal-case upcoming-session data.
- Dashboard filtering by property and period.

### Property

- Structured location is incomplete in the app entity: website supports short address, region, city, district, street, building number, postal code, additional number, latitude, and longitude.
- Website exposes contextual finance, tasks, attachments, and related lands under the same deed.
- Website list prioritizes property/deed, category/use, ownership/deed, occupancy, finance, and branch as separate information groups.
- App has no list view preference and currently underuses `imageUrl`, `availableUnits`, `rentedUnits`, and `occupancyRate` in the property card.

### Unit

- Website supports portfolio-wide filtering by property, type, purpose, status, completion, and price range.
- Website supports configurable columns and export.
- Marketing title, contact, marketing description, and marketing portal are not represented in the current app domain.
- Current app domain contains `dynamic currentContract` and `List<dynamic> contractsHistory`; this must be corrected before UI expansion.

### Contract

- Website covers amendment requests, renewal history/requests, contract timeline, preview, installment collection, and linked legal cases.
- App coverage must be verified against the mobile API response before any new action is exposed.

## UX Conclusions

- Do not clone website tables onto a phone. Preserve the same data and actions through mobile progressive disclosure.
- Every major list should provide at least a comfortable card mode and a compact list mode. Grid is enabled only where screen width supports it.
- Filters should be summarized as active chips and moved to a dedicated bottom sheet/dialog according to breakpoint.
- A summary section must be collapsible so the primary list remains visible.
- Details should follow: identity/status, essential metrics, urgent actions, then secondary sections.
- Missing critical data should be explicitly marked as incomplete; optional absent data can be hidden.
- Website labels/statuses are reference semantics, but app text must still come from localized mobile keys.

## Architecture Guardrails for Later Phases

- No website-only capability is implemented without an endpoint/body/response contract.
- No raw map or dynamic API structure may reach Presentation.
- UI does not calculate financial, occupancy, permission, or status rules.
- New capabilities stay inside their bounded context with Data/Domain/Presentation/DI layers.
- Cross-domain shared UI moves to Core only after demonstrated reuse and review.
- View preference persistence uses a repository/storage abstraction; widgets never access storage directly.
- Endpoints remain centralized in `ApiConstants`; Dio and GetIt remain the only approved networking/DI mechanisms.
- All new user text is added to Arabic/English translation files and locale keys first.
- Dynamic theme colors use `context.primaryColor` and `context.primaryShadow`.
- For the conflicting file-size rules, the stricter 150-line target is used for new and materially refactored files.

## Priority Backlog Derived From This Audit

### P0 — Directly addresses the client's feedback

1. Unified design tokens and responsive page shell.
2. Property list display switcher and reduced information density.
3. Typed advanced property filters and sort.
4. Property detail progressive hierarchy and structured missing-data treatment.
5. Unit list/detail hierarchy and removal of dynamic contract data.
6. Responsive phone/tablet/landscape layouts.

### P1 — Closes important website parity gaps

1. Dashboard typed metric parity and property/period filters.
2. Standalone portfolio units experience.
3. Contract lifecycle actions supported by the mobile API.
4. Complete tasks destination.
5. Finance/report filter and export parity.
6. Operational approvals inbox.

### P2 — Separate product initiatives

1. Warehouse.
2. Clients.
3. Tenant support tickets.
4. Establishment/users/permissions settings.
5. Dedicated banks and trial balance if approved for mobile.

## Phase 1 Acceptance Checklist

- [x] Authenticated website navigation inspected.
- [x] Main website list pages inspected.
- [x] Representative property, unit, contract, maintenance, and legal detail pages inspected.
- [x] Finance, reports, settings, profile, activity, approvals, warehouse, clients, and support-ticket surfaces inventoried.
- [x] Flutter features, routes, entities, models, data sources, and presentation coverage inventoried.
- [x] High-impact field and workflow gaps documented.
- [x] Priorities separated into immediate UX work, important parity work, and separate product initiatives.
- [x] Architecture and API-workflow constraints recorded.
- [x] No implementation from a later phase was started.

## Exit Decision

Phase 1 is complete. Phase 2 may start only after user review of this audit. The recommended Phase 2 scope is the unified design foundation and responsive shell needed by the later property redesign; it must not add website-only business capabilities.
