# Wafer ERP — Professional Upgrade Plan

## الهدف

تحويل Wafer من تطبيق كبير يحتوي على Modules وScreens كثيرة إلى ERP متماسك، Business-driven، قابل للتوسع، وآمن في التعامل مع البيانات والعمليات.

القاعدة الأساسية:

Architecture → Business Model → Entity Relationships → Status Machines → Permissions → Navigation → Features → UX → Visual Polish

وليس:

UI → Screens → Routes → Features → اكتشاف المشاكل لاحقًا

---

# PHASE 1 — Foundation

## 1.1 توحيد Navigation

استخدام GoRouter فقط.

ممنوع التنقل العشوائي باستخدام Navigator المباشر.

توحيد:
- Push
- Pop
- Replace
- Redirect
- Deep Links
- Back Navigation
- Return Results

## 1.2 Route Architecture

اعتماد convention ثابت:

/properties
/properties/:propertyId
/properties/:propertyId/units/:unitId

/contracts
/contracts/:contractId
/contracts/:contractId/installments

/finance
/finance/transactions

/maintenance
/maintenance/:maintenanceId

/tasks
/tasks/:taskId

/legal-cases
/legal-cases/:caseId

إلغاء الـrelative routes غير الضرورية، خصوصًا Legal Cases.

## 1.3 Unified State System

كل Feature يدعم:

- Initial
- Loading
- Refreshing
- Success
- Empty
- Error
- Unauthorized
- Forbidden
- Offline
- Submitting
- Action Success
- Action Error

## 1.4 Shared UX Components

إنشاء طبقة Shared Components مثل:

- AppSearch
- AppFilter
- AppEmptyState
- AppErrorState
- AppSkeleton
- AppStatusBadge
- AppConfirmDialog
- AppFormSection
- AppFormField
- AppDateFilter
- AppPagination
- AppBottomSheet
- AppActivityTimeline
- AppLoadingOverlay

لكن بدون تحويل الـFeatures إلى Generic Mega Screens.

---

# PHASE 2 — إصلاح المشاكل الموجودة

هذه المرحلة قبل أي إعادة تصميم كبيرة.

## 2.1 Tasks

إضافة:
- Search
- Filter by Status
- Filter by Priority
- Filter by Assignee
- Filter by Due Date
- Sort
- Debounced Search

## 2.2 Legal Cases

إضافة:
- Search
- Status Filter
- Date Filter
- Priority
- Sorting عند الحاجة

وتوحيد الـUX مع Tasks.

## 2.3 Destructive Actions

أي عملية مثل:

- Delete
- Cancel
- Reject
- Reverse
- Remove

تمر عبر:

User Action
→ Confirmation
→ Explain Impact
→ Confirm
→ API
→ Success/Error

## 2.4 Pagination

حماية Pagination من إرسال أكثر من request في نفس الوقت باستخدام:

- isLoadingNextPage
- hasReachedMax
- request locking
- debounce كطبقة مساعدة فقط

## 2.5 Dashboard Cards

أي Card تبدو Interactive يجب أن تكون قابلة للضغط فعلًا، وأي Card قابلة للضغط يجب أن يكون واضحًا بصريًا أنها Interactive.

مثال:

Active Contracts → Contracts
Expired/Expiring Contracts → Exact Contract List

---

# PHASE 3 — ERP Core

هذه أهم مرحلة لتحويل التطبيق من CRUD App إلى ERP حقيقي.

## 3.1 Entity Hierarchy

تثبيت العلاقات:

Portfolio
↓
Property
↓
Unit
↓
Tenant
↓
Contract
↓
Installments
↓
Payments

وبالتوازي:

Property
├── Documents
├── Maintenance
├── Tasks
├── Legal Cases
└── Financial Transactions

## 3.2 Entity Relationships

كل Entity مهمة يجب أن تعرف الـEntities المرتبطة بها.

مثال:

Payment
↓
Contract
↓
Unit
↓
Property

وكذلك:

Maintenance
↓
Unit
↓
Property

---

# PHASE 4 — Entity Context Hubs

أي Details Screen مهمة تتحول إلى Context Hub.

## Property

Property
├── Overview
├── Units
├── Contracts
├── Finance
├── Maintenance
├── Documents
└── Activity

## Unit

Unit
├── Overview
├── Tenant
├── Contract
├── Payments
├── Maintenance
├── Documents
└── Activity

## Contract

Contract
├── Overview
├── Installments
├── Payments
├── Documents
└── Activity

الهدف أن المستخدم لا يحتاج للقفز بين Modules مختلفة لجمع معلومات مرتبطة بنفس Entity.

---

# PHASE 5 — Status-Driven ERP

كل Entity مهمة يكون لها State Machine واضحة.

## Maintenance

New
→ Approved
→ Assigned
→ In Progress
→ Completed

مع:
- Rejected
- Cancelled

## Contract

Draft
→ Pending
→ Active
→ Expiring
→ Expired
→ Terminated

## Task

Created
→ Assigned
→ In Progress
→ Completed

مع:
- Cancelled
- Overdue

## Payment

Draft
→ Pending
→ Approved
→ Paid
→ Reconciled

مع:
- Reversed

## Legal Case

Open
→ In Progress
→ Hearing
→ Resolved
→ Closed

---

# PHASE 6 — Business Rules

لا نعتمد على CRUD فقط.

كل Status يحدد:

- Allowed Actions
- Allowed Fields
- Permissions
- Validation
- Allowed Transitions

مثال:

Payment = Paid

Edit Amount → ممنوع
Edit Account → ممنوع
Delete → ممنوع
Print → مسموح
View → مسموح
Reverse → مسموح حسب الصلاحية

مثال:

Maintenance = New

Approve → مسموح
Reject → مسموح
Complete → ممنوع
Assign Technician → حسب الـWorkflow

الهدف هو منع المستخدم من تنفيذ عمليات غير منطقية تجاريًا.

---

# PHASE 7 — Finance 2.0

Finance أكبر Module، لذلك لا يكفي تجميل الـUI فقط.

إعادة تنظيمه:

Finance
├── Overview
├── Transactions
│   ├── Receipts
│   ├── Payments
│   ├── Transfers
│   └── Adjustments
├── Receivables
├── Payables
├── Accounts
└── Accounting
    └── Journal

## Unified Transactions

عرض جميع العمليات في Timeline/Table واحدة:

16 Aug | Receipt  | Property A | +20,000
15 Aug | Payment  | Property B | -5,000
14 Aug | Transfer | Account A  | 10,000

مع Filters:

- Search
- Date Range
- Property
- Unit
- Contract
- Type
- Status
- Account

## Property-Based Finance

كلما كان ذلك منطقيًا، تكون المعاملات المالية مرتبطة بـ:

- Property
- Unit
- Contract

حتى يستطيع المالك رؤية Finance لكل عقار على حدة.

---

# PHASE 8 — Portfolio Management

إضافة مفهوم Portfolio للمالك الذي لديه أكثر من عقار.

Portfolio
├── All Properties
├── Property Performance
├── Occupancy
├── Revenue
├── Expenses
└── Net Income

مثال:

Property A
Revenue: 120K
Expenses: 20K
Net: 100K
Occupancy: 94%

Property B
Revenue: 80K
Expenses: 30K
Net: 50K
Occupancy: 72%

ويتم دعم Filter:

All Properties
Property A
Property B
Property C

في الـFinance والتقارير والـDashboard عند الحاجة.

---

# PHASE 9 — Global Search

Global Search أصبحت أولوية أساسية بسبب حجم التطبيق.

Search واحد من أي مكان:

Search Wafer

يبحث في:

- Properties
- Units
- Tenants
- Contracts
- Payments
- Receipts
- Maintenance
- Tasks
- Legal Cases
- Documents

النتائج تكون Grouped حسب النوع.

مثال:

محمد أحمد

People
→ محمد أحمد — Tenant

Contracts
→ Contract #104

Units
→ Unit A-203

Payments
→ Payment #992

الضغط على النتيجة يفتح الـEntity مباشرة.

---

# PHASE 10 — Document Management

إنشاء Document Vault مركزي:

Documents
├── All Documents
├── Property Documents
├── Deeds
├── Contracts
├── Financial Documents
├── Maintenance Attachments
└── Legal Documents

وفي نفس الوقت تظهر Documents داخل الـEntity نفسها.

مثال:

Contract #102
├── Details
├── Installments
├── Documents
└── Activity

---

# PHASE 11 — Activity & Audit Trail

كل Entity مهمة تحتوي على Activity Timeline.

مثال:

Today 10:42
Payment created

Today 10:45
Payment approved

Today 11:03
Payment marked as paid

كل Activity تحتوي على:

- User
- Action
- Timestamp
- Entity
- Entity ID
- Old Value عند الحاجة
- New Value عند الحاجة

الهدف:
- Traceability
- Accountability
- Auditability

خصوصًا في:
- Finance
- Contracts
- Legal
- Maintenance

---

# PHASE 12 — Notifications System

Notifications ليست مجرد Screen.

يكون لها نظام موحد:

Notification
├── Financial
├── Contracts
├── Maintenance
├── Tasks
├── Legal
└── System

كل Notification تحتوي على:

- Type
- Priority
- Entity Type
- Entity ID
- Timestamp
- Read Status
- Action

مثال:

"القسط #452 متأخر"

Tap
→ Contract #123
→ Installment #452

وليس مجرد فتح صفحة Notifications.

يجب دعم:
- Unread Badge
- Deep Linking
- Priority
- Categorization

---

# PHASE 13 — Contracts Management

بما أن Owner App لا ينشئ أو يعدل العقود حاليًا، لا يتم فرض CRUD كامل عليها.

بدل ذلك:

Contract
├── Active
├── Expiring Soon
├── Expired
└── Terminated

وفي Details يظهر بوضوح:

"إدارة العقد تتم عبر المنصة الإلكترونية.
هذا التطبيق مخصص للمتابعة والاطلاع."

مع Action مثل:

[Request Renewal]

إذا كان الـBackend يدعم ذلك.

## Contract Expiry

لا يتم تثبيت 30/60 يوم كـBusiness Rule داخل الـUI.

يفضل أن تكون Thresholds قابلة للتكوين، مثل:

- 90 days
- 60 days
- 30 days
- 7 days

والـDashboard يعرض:

Contracts Expiring Soon
7

ثم:

Contract #102
Expires in 12 days
[View]

---

# PHASE 14 — Maintenance 2.0

Workflow واضح:

New
→ Approve / Reject
→ Assign Technician
→ In Progress
→ Complete

والـActions تتغير حسب الـStatus.

مثال:

Status: New
[Approve]
[Reject]

Status: Approved
[Assign Technician]

Status: In Progress
[Add Photos]
[Complete]

لا يتم عرض Actions غير متاحة في الحالة الحالية.

---

# PHASE 15 — Offline Strategy

لا نبدأ مباشرة بـFull Offline Sync.

## Level 1

- Cache
- Offline Read
- Retry
- Last Known Data

## Level 2

خصوصًا Maintenance:

Create / Update Offline
→ Local Queue
→ Connection Restored
→ Sync
→ Server Confirmation

## Level 3

Conflict Resolution:

Local Update
vs
Server Update

يتم تنفيذ Offline Write بعد تثبيت الـBusiness Rules والـState Machines.

---

# PHASE 16 — Security & Permissions

حتى لو Owner هو الـRole الوحيد حاليًا، يتم تجهيز Permission Model من البداية.

Role
↓
Permission
↓
Resource
↓
Action

مثال:

Finance.Payment

View → مسموح
Create → مسموح
Edit → مسموح حسب الدور
Approve → حسب الدور
Reverse → حسب الدور
Delete → ممنوع

ويتم تجهيز:

- Token Refresh
- Session Expiry
- Forced Logout
- Password Change
- Sensitive Action Confirmation
- Device/Session Management عند الحاجة

2FA وBiometric لاحقًا حسب الـBusiness Requirements.

---

# PHASE 17 — Standard Search / Filter / Sort

كل List كبيرة تتبع Pattern موحد:

List
├── Search
├── Filter
├── Sort
└── Pagination

## Properties

- Status
- City
- Type
- Occupancy

## Contracts

- Status
- Property
- Expiry
- Tenant

## Tasks

- Status
- Priority
- Assignee
- Due Date

## Maintenance

- Status
- Priority
- Property
- Technician
- Date

## Finance

- Type
- Property
- Account
- Status
- Date Range

الهدف أن المستخدم يتعلم Pattern واحد في التطبيق كله.

---

# PHASE 18 — Reports

التقارير الحالية يتم تطويرها إلى:

- Filterable
- Exportable
- Comparable
- Context-Aware

مثال:

Revenue Report

Property: All
Period: Jan → Aug

Actions:
[PDF]
[Excel]

ويفضل أن يدعم التقرير:
- Property
- Unit
- Contract
- Date Range
- Status
- Financial Type

حسب نوع التقرير.

---

# PHASE 19 — Dashboard 2.0

Dashboard يتحول من Information Dashboard إلى Operational Dashboard.

الترتيب المقترح:

Dashboard
├── Critical Alerts
├── Pending Actions
├── Financial Overview
├── Portfolio Overview
├── Maintenance Priority Queue
├── Overdue Installments
├── Contracts Expiring Soon
├── Tasks
└── Quick Actions

## Critical Alerts

مثال:

3 أقساط متأخرة
2 عقود تنتهي قريبًا
4 طلبات صيانة معلقة
1 قضية تحتاج إجراء

كل Alert يفتح الـEntity أو الـList المناسب مباشرة.

## Pending Actions

مثال:

- 3 Tasks تحتاج متابعة
- 2 Maintenance تحتاج Approval
- 1 Contract يحتاج Renewal Request

الهدف:
"What needs my attention?"
بدل:
"What data do I have?"

---

# PHASE 20 — Final UX / UI Polish

بعد تثبيت الـBusiness Architecture، يتم عمل UX Audit شامل.

## Lists

- Loading
- Empty
- Error
- Search
- Filter
- Pagination
- Pull-to-Refresh

## Forms

- Validation
- Loading
- Submit Error
- Success
- Unsaved Changes
- Keyboard Handling

## Details

- Status
- Context
- Actions
- Documents
- Activity
- Related Entities

## Destructive Actions

- Confirmation
- Impact Explanation
- Loading
- Success
- Error

## Visual Consistency

- RTL
- Typography
- Spacing
- Status Colors
- Icon Consistency
- Touch Targets
- Animations
- Skeletons
- Haptics
- Tablet Layout
- Accessibility
- Dark/Light Mode
- Localization
- Error Messages
- Empty States

---

# Priority Matrix

## P0 — يجب تنفيذه قبل التوسع

1. GoRouter / Deep Links
2. Tasks Search / Filters
3. Legal Search / Filters
4. Pagination Protection
5. Destructive Confirmations
6. Status Machines
7. Business Rules
8. Permission Model
9. Global Search
10. Notification Deep Links
11. Unified State Handling
12. Entity Relationships
13. Activity / Audit Trail

## P1 — أساسي للوصول لمستوى ERP احترافي

14. Entity Context Hubs
15. Portfolio Management
16. Finance 2.0
17. Unified Transactions
18. Property-Based Financial Filtering
19. Document Vault
20. Contract Expiry Management
21. Contract Renewal Workflow
22. Maintenance Workflow
23. Dashboard 2.0
24. Notification Categories / Priorities
25. Standard Search / Filter / Sort
26. Reports Enhancement

## P2 — تحسينات متقدمة

27. Offline Read / Cache
28. Offline Queue / Sync
29. Conflict Resolution
30. PDF / Excel Export
31. Advanced Analytics
32. Dashboard Customization
33. Session / Device Management
34. 2FA / Biometric
35. English Localization
36. Advanced Accessibility

---

# Final Architecture Vision

                    WAFER ERP
                       │
          ┌────────────┼────────────┐
          │            │            │
      Portfolio     Operations    Finance
          │            │            │
      Properties   Maintenance   Transactions
      Units        Tasks         Receivables
      Contracts    Legal         Payables
      Tenants                    Accounts
                                  │
          ┌───────────────────────┘
          │
    Cross-Cutting ERP
          │
    Search
    Notifications
    Documents
    Activity
    Permissions
    Audit
    Reports
    Security

---

# أهم قاعدة في التنفيذ

لا يتم التعامل مع الخطة كقائمة Features مستقلة.

الـdependency الصحيح:

Architecture
→ Business Model
→ Entity Relationships
→ Status Machines
→ Permissions
→ Navigation
→ Features
→ UX
→ Visual Polish

الهدف النهائي:

Wafer لا يكون "تطبيق فيه 65+ شاشة".

يكون:

"ERP فيه Entities مترابطة، Business Rules واضحة، Status Lifecycles، Permissions، Audit Trail، Search، Notifications، Documents، Finance، Operations، وتقارير، وكل Action له سبب وحالة وصلاحية ونتيجة واضحة."

---

# Definition of Done للـERP

لا نعتبر Module مكتملًا لمجرد أن:

Screen + API + CRUD

لكن يجب أن يحتوي على:

- Entity واضحة
- Relationships واضحة
- Status Lifecycle
- Allowed Actions
- Validation
- Permissions
- Search
- Filter
- Sorting عند الحاجة
- Loading State
- Empty State
- Error State
- Confirmation للعمليات الحساسة
- Activity / Audit عند الحاجة
- Notifications عند الحاجة
- Deep Linking عند الحاجة
- Documents عند الحاجة
- Related Entities
- Responsive UX

وبالتالي تصبح كل Feature جزءًا من ERP واحد، وليس Module منفصلًا.
