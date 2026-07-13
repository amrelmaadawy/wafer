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
