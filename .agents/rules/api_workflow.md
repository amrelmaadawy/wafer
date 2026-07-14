---
trigger: always_on
---

# API & FEATURE IMPLEMENTATION WORKFLOW RULES

## 1. Base URL & Centralized Networking
- **Base URL**: `https://codra.cloud/api/v1/mobile/` must be used centrally via environment/API configuration (`ApiConstants.baseUrl`).
- Never hardcode URLs or endpoint strings inside feature layers. All endpoints must be defined centrally in clean contracts or constants files.

## 2. Endpoint Implementation Pipeline
For every API endpoint sent by the developer (`endpoint`, `body`, and `response`), follow this exact sequential workflow without deviation:

### Step 1: Deep Input Analysis
- Analyze the HTTP method, endpoint path, required query parameters/body structure, and the exact response payload structure (including metadata, pagination, and error structures).

### Step 2: UI/UX Design Proposal & Verification
- **Dynamic Primary Colors**: Always derive primary colors dynamically via `context.primaryColor` and `context.primaryShadow` (from `color_utils.dart`); NEVER hardcode `AppColors.primary` in navbars, buttons, or interactive UI elements.
- **If a Design/Prototype is Provided**: Follow and execute the design faithfully using our centralized Design System (`AppColors`, `AppFonts`, `AppSpacing`, `AppRadius`, etc.).
- **If No Design is Provided**: Analyze the data structure (`body` and `response`) and propose a comprehensive UI/UX Design before writing UI code. Specifically outline:
  - Screen layout & structure.
  - Interactive components & widgets (cards, lists, forms).
  - State representations: `Loading`, `Success`, `Error` (with retry), and `Empty`.

### Step 3: Structured Implementation Plan
- Before implementing any feature code, create a detailed implementation plan specifying every Clean Architecture layer needed:
  1. **Domain Layer**: `Entity` (immutable, business models) & `UseCase` & `Repository` interface contract.
  2. **Data Layer**: `Model` (with `fromJson`/`toJson`) & `RemoteDataSource` & `Repository` implementation.
  3. **Presentation Layer**: `Cubit` & `State` (immutable, Equatable) & UI `Screens`, `Views`, and `Widgets`.
  4. **Dependency Injection**: Central GetIt registration.

### Step 4: Proactive Suggestions
- Always proactively propose value-added improvements during planning and execution:
  - UX enhancements (animations, skeletons, transitions).
  - Edge-case handling (offline queues, caching ownership, error mapping).
  - Performance optimizations (pagination, lazy loading, debouncing).

### Step 5: Strict Rule Enforcement
- Ensure 100% adherence to `rules.md` (Clean Architecture boundaries, max 150 lines per file, zero duplicated logic, GetIt only, localized strings, robust validation, and security).
- **Strict Localization (`easy_localization`) Enforcement**:
  - ABSOLUTELY ZERO HARDCODED STRINGS inside any Widget, Screen, View, Toast, or Dialog.
  - All user-facing text MUST use `easy_localization` (`.tr()` or `LocaleKeys.key.tr()`).
  - When creating or modifying any UI component, every text string MUST first be added to `assets/translations/ar.json` and `en.json`, defined in `LocaleKeys`, and referenced via `.tr()`. Never bypass this rule.

## 3. Sub-Module Domain-Driven Feature Architecture
For large and complex features (like `owner`), never group all files together in a monolithic `data`, `domain`, or `presentation` folder. Instead, partition the feature into strictly isolated sub-modules representing Domain-Driven Bounded Contexts.
- **Sub-Module Separation**: E.g., `features/owner/` should be split into `dashboard/`, `contracts/`, `finance/`, `properties/`, and `shell/`.
- **Independent Layers**: Every sub-module MUST contain its own independent `data/`, `domain/`, and `presentation/` layers.
- **Routing & Shell**: Navigation logic and the main entry screen must be isolated in a dedicated `shell/` sub-module.
- **Modular Dependency Injection**: Use helper methods (e.g., `_initDashboard()`, `_initContracts()`) in the primary DI file (e.g., `owner_di.dart`) to keep dependencies decoupled by sub-module.
- **Zero Cross-Importing**: Avoid importing `data` or `presentation` logic across sub-modules. Shared logic should go into `core/`.
