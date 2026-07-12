---
trigger: always_on
---

# REAL ESTATE ERP RULES
## 1. Architecture
- Clean Architecture: Presentation, Domain, Data.
- Dependencies point inward; no cross-layer access.
- UI has no business logic/API/DB/cache/storage access.
- Shared logic in Core; features use abstractions.
## 2. Development
- Feature-driven development.
- Each feature owns data/domain/presentation.
- Reuse architecture, constants, theme, localization, widgets, repos, use cases first.
- Duplicate logic/widgets/constants/endpoints/validators forbidden.
## 3. Feature Structure
- Keep the approved structure only.
- Features include entities, models, repos, use cases, cubits, states, screens, views, widgets, data sources.
- Cross-feature calls use Core contracts/abstractions.
## 4. File Size
- Max 150 lines per file.
- Split large widgets, cubits, services, repos, data sources, use cases.
## 5. Code Quality
- Clean, DRY, SOLID, readable, testable.
- No dead code, unused imports, magic values, needless abstractions.
- Prefer composition.
## 6. Naming
- Screen: HomeScreen; View: HomeView; Widget: PropertyCard.
- Cubit: PropertyCubit; State: PropertyState.
- Entity: PropertyEntity; Model: PropertyModel.
- Repository: PropertyRepository; UseCase: GetPropertyUseCase.
- DataSource: PropertyRemoteDataSource.
## 7. State Management
- Cubit default; Bloc only for complex flows.
- States immutable and Equatable.
- Async flows have loading/success/error/empty when applicable.
- Side effects outside widgets.
## 8. Dependency Injection
- GetIt only.
- Central registration; no manual creation in UI, cubits, repos, use cases.
- Each feature exposes its own registration and the app injector calls it.
## 9. Networking & API
- Dio only with central Auth, Logging, Error, Locale, Retry interceptors.
- Centralized endpoints; no endpoint strings in features.
- Typed requests/responses and strong JSON parsing only.
- No dynamic API handling in feature logic.
- Pagination/search/filter/sort contracts are typed.
## 10. Errors
- Map exceptions to Failures.
- UI shows localized friendly errors.
- Domain never receives raw Dio/storage/platform exceptions.
## 11. Security & Privacy
- No plaintext secrets, hardcoded keys, URLs, tokens, or credentials.
- Use Secure Storage for sensitive values.
- Validate all input.
- Protect personal, financial, ID, contract, document data.
- Logs and analytics must not expose secrets or sensitive content.
## 12. Configuration
- Centralized Dev, Staging, Production configs.
- Base URLs, flags, logging, keys are env-driven.
## 13. Storage, Cache & Offline
- UI never accesses storage or cache directly.
- Storage is abstracted and replaceable.
- Repos control cache, invalidation, mutations, sync, Single Source of Truth.
- Cache must include ownership context.
- Offline queues/conflicts are explicit for contracts, payments, maint., property changes.
## 14. UI & Design System
- No hardcoded colors, fonts, sizes, radius, shadows, strings, icons, assets.
- Use AppColors/AppFonts/AppSpacing/AppRadius/AppIcons/AppAssets/AppDurations/AppSizes.
- All user text from localization.
- Support Arabic/English, RTL/LTR, dark/light, scalable text, contrast, semantics, touch targets.
- Support phones/tablets/foldables, portrait/landscape, 320px+.
## 15. Performance
- Use const, avoid unnecessary rebuilds, dispose controllers.
- Paginate data, lazy-load/cache images/docs.
- Heavy/report logic runs async in Domain/services, not UI.
## 16. Domain Journey
- Flow: Property -> Unit -> Lease -> Invoice -> Payment -> Maint. -> Reports.
- Support drafts, auto-save, resume, status, previous/current/next step.
- UI reflects state; never calculates/decides rules.
## 17. Core Domain Entities
- Property, Unit, Owner, Tenant, LeaseContract, Invoice, Payment, MaintenanceRequest, Employee, Role, Perm, Document, Notification, Report.
- Every entity has ownership, context, perms, status rules.
## 18. Multi-Tenant Rules
- Support Company/Office, Individual Owner, Tenant.
- Records include needed context: companyId, branchId, ownerId, tenantId, propertyId, unitId, contractId.
- Prevent leakage between companies, owners, tenants, branches.
- Super Admin access explicit, perm-gated, audited.
## 19. Account Type, Role, Perm
- Account Type = experience: Company, IndividualOwner, Tenant.
- Role = responsibility: SuperAdmin, CompanyAdmin, BranchManager, Accountant, LeasingAgent, Maint.Manager, Technician, Owner, Tenant.
- Perm = action: view, create, update, delete, approve, reject, assign, export, pay, refund, archive.
- Never merge these concepts.
- Access checks include type, role, perm, ownership, status.
## 20. Module Visibility
- Company users access permitted dashboard, properties, units, owners, tenants, leases, invoices, payments, maint., employees, perms, docs, reports, notifs, settings.
- Owners access only own dashboard, properties, units, leases, income, invoices, payments, maint. approvals, docs, notifs, profile.
- Tenants access only dashboard, contracts, invoices, payments, history, maint., shared docs, notifs, communication.
- Hidden UI is not security; Domain/API enforce access.
## 21. Data Ownership Matrix
- Company users see only company/branch/perm scope.
- Owners see only data linked to ownerId.
- Tenants see only data linked to tenantId.
- Shared records define all involved IDs.
- Missing sensitive ownership context blocks implementation.
## 22. Property & Unit Management
- Properties support CRUD, archive/restore, search, filter, sort, pagination, images, docs, location, amenities, ownership, status.
- Types: residential, commercial, land, administrative, mixed-use, custom.
- Units belong to properties; include area, floor, number, type, rent, deposit, specs, images, docs.
- Unit status: vacant, occupied, reserved, under_maint., unavailable, archived.
- Availability derives from lease/maint. state.
## 23. Owners, Tenants & Interactions
- Owners may be company-managed/self-service.
- Owners access only own properties, contracts, income, payments, maint., docs.
- Tenants access only own profile, contracts, invoices, payments, docs, maint., messages.
- Track calls, visits, messages, agreements, notes, follow-ups linked to entities.
## 24. Lease Lifecycle
- States: draft, active, expiring, renewed, terminated, cancelled, archived.
- Domain handles renewal, termination, cancellation, expiry, versioning.
- Contracts include parties, dates, rent, deposit, schedule, terms, attachments.
- Post-activation changes need versioning/audit.
## 25. Billing & Payments
- Domain calculates rent, fees, discounts, penalties, taxes, refunds, adjustments, totals.
- UI never calculates financial values.
- Invoice states: draft, issued, partially_paid, paid, overdue, cancelled, refunded.
- Payment providers abstracted: cash, transfer, card, wallet, Paymob, Fawry, Stripe, Apple Pay, Google Pay.
- Payment states: pending, completed, failed, cancelled, refunded, partially_refunded.
- Completed payments immutable except controlled adjustment/refund.
## 26. Maint.
- States: new, approved, rejected, assigned, in_progress, completed, cancelled, archived.
- Tenants create when allowed; owners/companies approve, reject, assign, track.
- Requests include images, notes, priority, cost, technician/vendor, invoices, evidence.
- Costs link to owner, tenant, company, or shared.
- Vendors/technicians are independent with assignments, costs, ratings, notes, history.
## 27. Docs & Uploads
- Central document/upload service only.
- Supports contracts, invoices, receipts, property/owner/tenant docs, IDs, plans, images, maint. evidence.
- Requires perms, secure preview/download, versioning, audit, progress, retry, cancel, recovery, compression, validation.
## 28. Notifs & Communication
- Provider-independent Push, In-App, Email, SMS.
- Localized templates for rent due, overdue, expiry, renewal, maint., approvals, docs, payment results.
- Communication is perm-aware and linked to relevant entity.
## 29. Admin, Dashboard & Onboarding
- Main entities support CRUD, search, filter, sort, pagination, archive, restore, export.
- Bulk actions need confirmation/audit.
- Dashboards are role/account-aware; use Domain metrics.
- Company dashboard: portfolio, occupancy, revenue, overdue, expiring leases, maint., employees.
- Owner dashboard: properties, occupancy, income, overdue, expiring leases, maint.
- Tenant dashboard: contract, dues, payments, maint., notifs.
- Onboarding is account-aware, persistent, resumable, guarded, Domain-driven.
- Company onboarding: profile, branches, admin, roles, first property.
- Owner onboarding: profile, verification, first property/unit, optional contract.
- Tenant onboarding: invite/contract code, verification, linked lease only.
## 30. Reports
- Reports come from repos/use cases, not UI calculations.
- Required: revenue, overdue, occupancy, property performance, owner income, maint. cost, lease expiry, employee activity.
- Support date range, property, owner, unit, payment/contract status, export, pagination.
## 31. Navigation
- GoRouter only.
- Central routes/guards/deep links; no inline navigation.
- Guards respect auth, onboarding, account type, role, perm, ownership.
## 32. Analytics, Logging & Audit
- Central provider-independent analytics/logging.
- Track property viewed, unit created, lease created/renewed, invoice issued, payment completed, maint. requested/completed, doc uploaded, report exported.
- Audit critical actions with actor, action, time, entity, context, before/after.
- Audit contracts, invoices, payments/refunds, perms, docs, maint. approvals/rejections, exports.
## 33. Feature Flags & Providers
- Central remote flags for beta, payments, notifs, reports, messaging, vendors, future AI.
- Abstract auth, payments, analytics, notifs, storage, docs, maps, geocoding, messaging, AI.
- Business logic provider-agnostic.
## 34. Maps & AI
- Location is structured: address, city, district, coordinates, landmarks.
- Map provider replaceable.
- AI optional/abstracted for descriptions, tagging, rent suggestions, maint. classification, report insights.
- AI output needs user review; not business truth.
## 35. Core & Domain Protection
- Core changes need review.
- Features cannot bypass/modify Core directly.
- Move logic to Core only when shared.
- Business rules live in Domain entities, value objects, repos, use cases.
- Data, Network, Storage, Provider, UI contain no business rules.
## 36. Forms, Search & Validation
- Central validators/localized messages.
- Validate property, unit, contract, payment, invoice, user, document, maint. input.
- Complex validation in Domain.
- Search/filter/sort typed and reusable.
## 37. Testing
- Minimum: Repository, UseCase, Cubit tests.
- Cover auth, perms, API, property/unit, lease, billing, payments, maint., notifs, state.
- Financial/perm logic need strong unit tests.
## 38. Git, Docs & Migration
- No direct commits to main; use branches/PRs/reviews.
- Prefixes: feat, fix, refactor, docs, test, chore.
- Document Core, complex features, domain rules, perms, billing, statuses, API contracts.
- Structural changes need migration, versioning, compatibility, validation, rollback.
## 39. Definition of Done
- Done means compliant, localized, responsive, accessible, secure, perm-aware, tested, documented, logged, and handles loading/success/empty/error/edge cases.
- Contracts, payments, perms, docs, migrations need extra review/audit.
## 40. Prohibited & Enforcement
- No architecture violations, hardcoded values/strings/endpoints/secrets, global state, repo bypass, UI calculations, UI-only perms, unreviewed Core changes, data leakage.
- Before coding, inspect architecture, constants, localization, design system, widgets, repos, use cases, perms, domain rules.
- Challenge technical debt, weak security, poor UX, leakage, poor performance, low scalability.
- Prioritize maintainability; reject non-compliance.