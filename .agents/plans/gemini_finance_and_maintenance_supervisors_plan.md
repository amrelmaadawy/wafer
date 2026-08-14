# خطة تنفيذ موجّهة إلى Gemini: الحسابات المالية العامة ومشرفو الصيانة

> هذه وثيقة تنفيذ ملزمة وليست اقتراحًا عامًا. نفّذها بالترتيب، ولا توسّع نطاقها، ولا تستنتج أي API غير موثّق في الكود الحالي أو في عقد رسمي يصل لاحقًا.

## 1. الهدف التنفيذي

إكمال النطاق القابل للتنفيذ حاليًا على مرحلتين مستقلتين:

1. **المرحلة 9 — الحسابات المالية العامة**: رفع جودة ميزة دليل الحسابات الموجودة، وإكمال الفلاتر وحالات الواجهة والاختبارات باستخدام العقود المؤكدة فقط.
2. **المرحلة 10 — إدارة مشرفي الصيانة**: تحسين القائمة ونموذج الإضافة ضمن العمليات الثلاث المدعومة فقط: القائمة، بيانات النموذج، والإنشاء.

بعد المرحلتين، تبقى بقية عناصر P2 متوقفة صراحةً حتى وصول عقود API موثقة. لا يجوز استخدام بيانات وهمية أو تحويل شاشة غير مرتبطة إلى بديل مؤقت.

## 2. القراءة الإلزامية قبل أي تعديل

اقرأ الملفات التالية كاملةً وبالترتيب، واعتبرها أعلى أولوية من هذه الخطة عند التعارض:

1. `.agents/rules/rules.md`
2. `.agents/rules/api_workflow.md`
3. `.agents/plans/phase_1_website_app_parity_audit.md`
4. `.agents/plans/phase_5_handoff.md`
5. `.agents/plans/phase_6_handoff.md`
6. `.agents/plans/phase_7_handoff.md`
7. `.agents/plans/phase_8_handoff.md`

ثم افحص `git status --short` و`git diff` قبل العمل. مساحة العمل تحتوي تغييرات سابقة تخص المستخدم؛ لا تستخدم `git reset --hard` أو `git checkout --` أو `git restore`، ولا تعدّل أو تنسّق ملفات خارج نطاق المرحلة.

## 3. قواعد غير قابلة للتفاوض

- اتبع Clean Architecture: `Presentation -> Domain -> Data` فقط.
- لا تستورد Presentation من Domain أو Data، ولا Data من Domain.
- استخدم GetIt للحقن، Dio للشبكة، Cubit/BLoC للحالة، وGoRouter للمسارات وفق نمط المشروع.
- كل endpoint يوضع في `lib/core/network/api_constants.dart`. يمنع وجود مسار API كنص داخل data source.
- لا تخمّن method أو path أو query أو body أو response. عند غياب دليل مؤكد: أوقف هذه الجزئية، وثّقها كـ`BLOCKED_API_CONTRACT`، وأكمل الأجزاء المستقلة الآمنة.
- لا تضف fallback endpoint، ولا تحول `404/405` إلى نجاح، ولا تعرض mock data على أنها بيانات حقيقية.
- لا تسرب stack trace أو نص parsing داخلي إلى المستخدم. استخدم Failure mapping المعتمد ورسائل واجهة مترجمة.
- لا ترسل query فارغة أو مفاتيح body غير لازمة. استخدم أسماء المفاتيح المؤكدة حرفيًا.
- كل النصوص المرئية للمستخدم تضاف إلى `assets/translations/ar.json` و`assets/translations/en.json` وتُعرّف عبر `LocaleKeys`. لا hardcoded Arabic/English في Widgets.
- استخدم theme الحالي و`Theme.of(context)`/امتدادات المشروع؛ لا تثبّت ألوان light mode.
- الواجهة يجب أن تدعم RTL/LTR، الشاشات الصغيرة، tablet/web، وتكبير الخط.
- كل تدفق async يجب أن يغطي: initial/loading/success/empty/error/retry، ومع pagination يجب الحفاظ على المحتوى عند فشل الصفحة التالية.
- امنع الطلبات المتزامنة المكررة، وادمج النتائج دون تكرار IDs.
- لا يتجاوز أي ملف production أو test جديد أو المعاد تنظيمه جوهريًا **150 سطرًا**. قسّم المسؤوليات إلى ملفات صغيرة واضحة.
- لا تغيّر API عام مستخدم خارج الميزة دون تحديث جميع المستهلكين والاختبارات.
- نفّذ كل مرحلة واختبرها وأغلق handoff الخاص بها قبل الانتقال للمرحلة التالية.

## 4. خط الأساس الذي يجب الحفاظ عليه

- آخر خط أساس موثّق بعد المرحلة 8: **49 اختبارًا ناجحًا**.
- يوجد تنفيذ قائم للحسابات المالية ومشرفي الصيانة؛ المطلوب تحسينه لا إعادة بنائه عشوائيًا.
- المسارات وDI موجودة بالفعل للميزتين. افحص الاستخدام قبل أي تغيير، وحافظ على توافق التنقل الحالي.
- لا تعتبر نجاح التحليل وحده كافيًا؛ الاختبارات المستهدفة والانحدارية إلزامية.

---

# المرحلة 9 — الحسابات المالية العامة

## 5. تعريف النطاق

المقصود هنا **دليل الحسابات العامة فقط**. لا تسمّ هذه المرحلة إدارة بنوك، ولا تضف حقول IBAN أو رقم حساب بنكي أو اسم بنك، ولا تنفذ ميزان مراجعة؛ لا توجد عقود مؤكدة لهذه الوظائف.

### العقود المؤكدة

| العملية | Method | Path | المدخلات المؤكدة | الاستجابة المستخدمة حاليًا |
|---|---|---|---|---|
| قائمة الحسابات | GET | `owner/accounting/accounts` | `page`, `per_page`, واختياريًا `search`, `account_type`, `is_active`, `is_postable` | `data.accounts` و`data.pagination`، مع دعم الشكل المتداخل المثبت حاليًا |
| تفاصيل حساب | GET | `owner/accounting/accounts/{id}` | `id` في المسار | `data.account` |
| إنشاء حساب | POST | `owner/accounting/accounts` | body المبين أدناه | `data.account` |
| تعديل حساب | PATCH | `owner/accounting/accounts/{id}` | body جزئي بالمفاتيح المؤكدة | `data.account` |

Body الإنشاء المسموح:

```text
parent_id, code, name_ar, name_en, type,
is_postable, is_active, description_ar (اختياري وغير فارغ)
```

Body التعديل المسموح:

```text
code, name_ar, name_en, type, is_postable,
is_active, description_ar, parent_id
```

قيم `type` المثبتة في التنفيذ الحالي فقط:

```text
asset, liability, expense, revenue, equity
```

### خارج النطاق صراحةً

- حذف الحساب أو أرشفته أو استعادته.
- endpoints منفصلة للتفعيل/التعطيل.
- البنوك، الحسابات البنكية، IBAN، الأرصدة الافتتاحية، ميزان المراجعة، القيود، أو الترحيل.
- إضافة أنواع حسابات جديدة أو قواعد parent/child غير مثبتة.
- تغيير صيغة response بناءً على التخمين.

## 6. مهام Data Layer

1. أضف helper مركزيًا في `ApiConstants` لتفاصيل الحساب: `ownerAccountingAccountDetails(int id)` أو اسم متسق مع المشروع.
2. راجع `finance_remote_data_source.dart` بحيث:
   - يستخدم الثوابت فقط.
   - يبني query من كائن typed، ويحذف القيم null والنصوص الفارغة.
   - يستخدم GET/POST/PATCH كما في الجدول دون بدائل.
   - لا يلتقط الاستثناء ليعيد `Exception` برسالة واجهة؛ اترك التحويل للطبقة المعتمدة في repository.
3. اجعل parsing دفاعيًا داخل feature finance دون استيراد helper خاص بميزة reports:
   - تحقق أن الحاويات Maps والقوائم Lists قبل التحويل.
   - حوّل `id`, `parent_id`, `level` إلى int بشكل آمن.
   - حوّل booleans من `bool/0/1/"0"/"1"` بما يتوافق مع الأنماط المرصودة.
   - لا تنشئ كيانًا صالحًا ظاهريًا بـ`id = 0` عند غياب الحقل الإلزامي؛ أرجع parsing failure قابلًا للمعالجة.
   - ادعم شكلي القائمة المثبتين حاليًا فقط: accounts كقائمة مباشرة أو كحاوية تحتوي `data`.
4. اختبر أن request body لا يحتوي إلا المفاتيح المؤكدة، وأن الحقول الاختيارية لا تُرسل عند غيابها.
5. لا تجعل Models تعرف Widgets أو localization.

## 7. مهام Domain Layer

1. أنشئ `FinanceAccountsQueryEntity` immutable يحتوي:
   - `page`, `perPage`, `search`, `accountType`, `isActive`, `isPostable`.
   - validation للقيم العددية.
   - مساواة واضحة و`copyWith` عند الحاجة.
2. مرّر query ككائن واحد عبر use case وrepository بدل سلسلة معاملات تتوسع باستمرار.
3. مثّل أنواع الحسابات الخمسة بقيمة typed داخل Domain مع serializer يعيد القيم الإنجليزية المؤكدة حرفيًا. اجعل التسمية المترجمة في Presentation، لا داخل Domain.
4. حافظ على `CreateFinanceAccountParams` و`UpdateFinanceAccountParams` typed. انقل serialization إلى الحد الأنسب وفق نمط المشروع، مع بقاء Domain مستقلًا عن Dio.
5. لا تضف use case لعملية غير موجودة في جدول العقود.

## 8. مهام Presentation وState

### قائمة الحسابات

1. أعد تصميم state ليحفظ:
   - القائمة الحالية وpagination.
   - query النشط.
   - initial loading، refreshing، loadingMore كلٌ على حدة.
   - first-page error وpagination error كلٌ على حدة.
   - `hasReachedMax` وحماية request-in-flight.
2. أضف شريط بحث debounce مناسب، مع إلغاء أثر الردود القديمة منطقيًا عند تغير query.
3. أضف فلاتر للعقد الموجود فقط:
   - نوع الحساب.
   - نشط/غير نشط.
   - قابل للترحيل/غير قابل للترحيل.
   - زر مسح الفلاتر يظهر عند وجود فلتر نشط.
4. عند تغيير البحث أو الفلتر ابدأ من الصفحة 1 ولا تخلط نتائج query قديم بجديد.
5. عند فشل pagination أبقِ البطاقات واعرض retry قريبًا من نهاية القائمة. لا تحول الشاشة إلى full-page error.
6. امنع تكرار العناصر بحسب `id`.
7. وفر pull-to-refresh، empty state مختلفًا للقائمة الفارغة عن عدم وجود نتائج للفلاتر، وCTA مناسب لمسح الفلاتر.
8. اعرض عدد النتائج من pagination عندما يكون موثوقًا.

### التصميم الاحترافي

1. استخدم header واضحًا وعرضًا responsive:
   - عمود واحد للهاتف.
   - عمودان للعرض المتوسط.
   - ثلاثة أعمدة عند العرض الواسع إذا ظلت البطاقة قابلة للقراءة.
2. اجعل البطاقة تعرض: الاسم حسب اللغة مع fallback آمن، code، النوع المترجم، وحالتي active/postable بشارات واضحة غير معتمدة على اللون وحده.
3. حافظ على تسلسل بصري ومساحات من tokens المشروع، ووفّر touch targets لا تقل عن الحجم المقبول في Flutter.
4. اختبر Light/Dark وRTL/LTR. لا تستخدم `AppColors.backgroundLight` كثابت لخلفية الشاشة.

### التفاصيل والإنشاء والتعديل

1. حافظ على المسارات الحالية ولا تضف route موازيًا.
2. افصل form state والحقول والأزرار من view إذا اقترب الملف من 150 سطرًا.
3. validation محلي قبل الطلب:
   - code وnameAr وnameEn وtype مطلوبة.
   - trim للنصوص.
   - لا تحول إدخالًا غير صالح إلى `0` بصمت.
4. امنع double submit، واعرض loading داخل زر الإجراء.
5. لا تغلق النموذج عند الفشل، وحافظ على المدخلات مع رسالة مترجمة قابلة للفهم.
6. بعد نجاح الإنشاء/التعديل حدّث القائمة أو أعد تحميلها بطريقة واحدة متسقة، ثم اعرض feedback مترجمًا.
7. `parent_id` يبقى اختياريًا. لا تبن selector أو hierarchy rule إلا إذا كانت بياناته مؤكدة من المصدر القائم.

## 9. ملفات متوقعة ضمن المرحلة 9

عدّل فقط ما يلزم من هذه المناطق، وقد تنشئ ملفات أصغر تحتها:

```text
lib/core/network/api_constants.dart
lib/features/owner/finance/data/datasources/
lib/features/owner/finance/data/models/
lib/features/owner/finance/data/repositories/
lib/features/owner/finance/domain/entities/
lib/features/owner/finance/domain/repositories/
lib/features/owner/finance/domain/usecases/
lib/features/owner/finance/presentation/cubit/
lib/features/owner/finance/presentation/views/
lib/features/owner/finance/presentation/widgets/
lib/features/owner/finance/di/
assets/translations/ar.json
assets/translations/en.json
lib/core/localization/locale_keys.dart
lib/core/localization/locale_keys.g.dart
test/features/owner/finance/
```

لا تعدّل `locale_keys.g.dart` يدويًا إذا كان للمشروع generator معتمد؛ استخدم workflow المشروع ثم راجع diff.

## 10. اختبارات المرحلة 9

أنشئ اختبارات صغيرة تغطي على الأقل:

- Model parsing للاستجابة المباشرة والمتداخلة، booleans والأرقام، والحقول التالفة.
- Query serialization لكل فلتر، وعدم إرسال null/empty.
- Repository: success، Dio/network failure، parsing failure، وصحة endpoint/method.
- Use cases: تمرير query والـparams دون تغيير.
- Cubit: أول تحميل، نجاح فارغ، refresh، تغيير query، منع الطلب المكرر، pagination، deduplication، وفشل الصفحة التالية مع بقاء البيانات.
- Widget: loading/error/retry/empty/filter-empty، ظهور الفلاتر، RTL، وتخطيط narrow/wide دون overflow.
- Create/update: body exact، validation، منع double submit، success/failure.

## 11. بوابة قبول المرحلة 9

لا تنتقل للمرحلة 10 إلا إذا تحقق كل الآتي:

- لا توجد API strings للحسابات خارج `ApiConstants`.
- لا توجد عملية غير مؤكدة أو تسمية توحي بالبنوك/ميزان المراجعة.
- جميع حالات UI والفلاتر تعمل من نفس العقد.
- `dart format` على الملفات المعدلة فقط ناجح.
- التحليل على الملفات المعدلة ناجح بلا warnings/errors جديدة.
- اختبارات finance المستهدفة ناجحة.
- مجموعة الانحدار الكاملة، بما فيها الـ49 اختبارًا السابقة، ناجحة.
- `git diff --check` ناجح.
- أنشئ `.agents/plans/phase_9_handoff.md` يسجل: النطاق، العقود، الملفات، الاختبارات بالأعداد، النتائج، exclusions، وأي مخاطرة متبقية.

---

# المرحلة 10 — إدارة مشرفي الصيانة ضمن العمليات المدعومة

## 12. تعريف النطاق والعقود

| العملية | Method | Path | المدخلات/الاستجابة المؤكدة |
|---|---|---|---|
| بيانات نموذج الإضافة | GET | `owner/maintenance-supervisors/form-data` | `data` يحتوي options/defaults/validation |
| قائمة المشرفين | GET | `owner/maintenance-supervisors` | query المؤكد حاليًا: `page`، و`data` يحتوي `maintenance_supervisors` و`pagination` |
| إضافة مشرف | POST | `owner/maintenance-supervisors` | body أدناه، والاستجابة `data.maintenance_supervisor` |

Body الإنشاء المثبت من التدفق الحالي:

```text
user_id (required)
scope_type (required)
scope_values (conditional list; only when a selected value exists)
sort_order (optional integer)
is_active (required boolean)
```

`form-data` قد يعرض `scope_conditions`، لكن التدفق الحالي لا يثبت إرسال `scope_condition` في POST. لا ترسله ولا تخترع سلوكه حتى يصل عقد رسمي يحدد body.

### خارج النطاق صراحةً

- تفاصيل مشرف منفردة.
- تعديل، حذف، أرشفة، استعادة، أو endpoint تغيير حالة.
- البحث أو filters أو `per_page` ما لم يثبتها عقد رسمي؛ لا تستنتجها من ميزات أخرى.
- إضافة مستخدم جديد من الشاشة أو تعديل بيانات المستخدم.
- دعم أكثر من scope value في الواجهة دون دليل يؤكد سلوك الاختيار المتعدد.

## 13. مهام Data وDomain

1. أضف إلى `ApiConstants`:
   - `ownerMaintenanceSupervisors`.
   - `ownerMaintenanceSupervisorsFormData`.
2. استبدل النصوص hardcoded في data source بالثوابت، وحافظ على methods الثلاثة فقط.
3. استبدل `Map<String, dynamic>` عبر Domain وCubit بكائن typed: `CreateMaintenanceSupervisorParams`.
4. params يجب أن ينتج body بالمفاتيح الخمسة المؤكدة فقط، ويحذف الاختياري عند غيابه، ويحافظ على نوع scope value المطلوب من السيرفر.
5. أزل `dynamic` من الكيانات قدر الإمكان دون كسر العقد:
   - مثّل scope value ID كنوع صريح يدعم فقط scalar `int` أو `String` المرصودين.
   - وفر equality وserialization يحافظان على القيمة الأصلية.
   - استخدم النوع نفسه في defaults وlist scope values بدل `List<dynamic>`.
   - إذا أظهر fixture حقيقي نوعًا ثالثًا، لا تدعمه بالتخمين؛ سجله كـ`BLOCKED_API_CONTRACT`.
6. اجعل models دفاعية تجاه Map/List والأنواع القابلة للتحويل. لا تستخدم casts مباشرة قد تسقط الشاشة.
7. في قائمة المشرفين، لا تحوّل scope values غير العددية إلى `0`. استخدم representation متسقًا مع form-data أو ارفض payload غير المدعوم كـparsing failure.
8. أصلح error handling كي يمر عبر Failure mapping المعتمد، ولا تعرض `stackTrace` أو `Exception: ...` للمستخدم.
9. حافظ على repository/use cases/DI الحالية بعد تحويل signatures إلى typed params.

## 14. مهام Presentation وState

### القائمة

1. حافظ على pagination المعتمدة على `page` فقط.
2. أضف request guard، deduplication بالـID، refresh، وتحميل صفحة تالية دون محو البيانات.
3. ميّز بين first-page error وload-more error، ووفر retry لكل منهما.
4. اعرض empty state مترجمة مع زر إضافة مشرف إن كانت بيانات form-data متاحة عند فتح النموذج.
5. بعد نجاح الإضافة، حدّث القائمة deterministically ولا تضف عنصرًا مكررًا.
6. صمم البطاقات responsive وبثيم ديناميكي، وتعرض فقط البيانات الموجودة: المستخدم، scope label/values، الترتيب، الحالة، وتاريخ الإنشاء إذا كان صالحًا.
7. استخدم fallback مترجم عند غياب الاسم، ولا تعرض null أو نصًا فارغًا كمعلومة أساسية.

### نموذج الإضافة

1. قسم `add_supervisor_bottom_sheet.dart` إلى مكونات أصغر تحت 150 سطرًا: shell، form controller/state، fields، skeleton/error، submit section.
2. حمّل form-data عند الفتح، مع skeleton ثم error + retry داخل النافذة.
3. طبق defaults من السيرفر فقط عندما تطابق الخيارات المتاحة.
4. user وscope type مطلوبان. scope value مطلوب فقط عندما يذكر `validation.scope_type_requires_values` ذلك وتوجد خيارات متاحة.
5. عند تغيير scope type امسح scope value القديم.
6. `sort_order`: فارغ يعني عدم إرسال المفتاح؛ قيمة غير رقمية تعرض validation error ولا تتحول إلى صفر.
7. استخدم `boolean_values`/defaults كما يحددها form-data حيث يفيد العرض، دون تغيير body المؤكد.
8. لا تعرض scope condition كحقل قابل للحفظ طالما body الخاص به غير مؤكد. يمكن تجاهل options غير القابلة للإرسال بدل تضليل المستخدم.
9. امنع double submit، حافظ على المدخلات عند الفشل، وأغلق النافذة مع نتيجة success فقط.
10. أضف success message مستقلًا ومترجمًا؛ لا تستخدم عنوان "إضافة مشرف" كرسالة نجاح.

## 15. اختبارات المرحلة 10

غطِّ على الأقل:

- Form-data model مع IDs من int وString، defaults، validation، payloads ناقصة/تالفة.
- List model وpagination وscope values دون تحويل غير صالح إلى صفر.
- Params serialization: body exact، حذف `scope_values` و`sort_order` عند غيابهما، وعدم وجود `scope_condition`.
- Data source: endpoint/method/query/body لكل عملية من الثلاث فقط.
- Repository/use cases: success، network failure، parsing failure.
- List Cubit: initial/empty/refresh/pagination/request guard/dedup/load-more error.
- Form-data Cubit وCreate Cubit: loading/success/failure ومنع submit المتكرر.
- Widgets: form loading/error/retry، conditional scope value، validation للترتيب، حفظ المدخلات، RTL، narrow/wide، dark/light، وتحديث القائمة بعد النجاح.

## 16. بوابة قبول المرحلة 10

- لا يوجد أي endpoint نصي لمشرفي الصيانة خارج `ApiConstants`.
- لا توجد تفاصيل/تعديل/حذف/تغيير حالة أو أي زر يوحي بعملية غير مدعومة.
- لا يوجد `Map<String, dynamic>` بين Presentation وDomain في create flow.
- لا يوجد `dynamic` غير مبرر في IDs/default values، ولا تحويل لقيمة غير صالحة إلى صفر.
- لا تسرب للأخطاء التقنية للمستخدم.
- format، analyze، targeted tests، full regression، و`git diff --check` كلها ناجحة.
- أنشئ `.agents/plans/phase_10_handoff.md` بنفس تفاصيل handoff المطلوبة في المرحلة 9، وسجّل بوضوح أن العمليات المدعومة هي list/form-data/create فقط.

---

# 17. سجل P2 المؤجل حتى وصول عقود API

لا تبدأ البنود التالية، حتى لو أمكن تصميم UI لها، قبل توفر method/path/request/response/error contract موثق وfixture ناجح على بيئة المشروع:

| البند المؤجل | سبب التوقف | الحد الأدنى المطلوب لفتحه |
|---|---|---|
| المخازن | لا يوجد عقد API كامل مؤكد | list/details/mutations/form-data حسب المطلوب، مع schemas وأخطاء |
| العملاء | لا يوجد عقد API كامل مؤكد | endpoints، query، pagination، models، وصلاحيات العمليات |
| تذاكر دعم المستأجرين | لا توجد بيانات أو عقود مؤكدة | list/details/create/update/status contract وfixtures |
| إعدادات المنشأة/المستخدمين/الصلاحيات العامة | العقود غير مكتملة أو غير متاحة | فصل كل bounded context وعقوده وصلاحياته |
| البنوك المخصصة | لا يوجد endpoint أو schema بنكي مؤكد | endpoints وحقول الحساب البنكي وسياسة إخفاء البيانات الحساسة |
| ميزان المراجعة | لا يوجد report contract مؤكد | endpoint، filters، totals، pagination/export، وعينة response |

عند وصول أي عقد:

1. قارنه بـ`.agents/rules/api_workflow.md`.
2. أضف evidence matrix في plan مستقل.
3. اختبر العقد بطلب حقيقي/fixture موثق قبل بناء UI.
4. لا تخلط أكثر من bounded context في مرحلة واحدة.

# 18. ترتيب التنفيذ والتحقق

نفذ بهذا التسلسل دون تجاوز:

1. Baseline: status + قراءة القواعد + تشغيل الاختبارات الحالية وتسجيل العدد.
2. المرحلة 9: Domain/Data أولًا، ثم state، ثم UI/localization، ثم tests.
3. Gate المرحلة 9 كاملة وكتابة handoff.
4. المرحلة 10: constants/typed contracts، ثم parsing/repository، ثم state، ثم UI/localization، ثم tests.
5. Gate المرحلة 10 كاملة وكتابة handoff.
6. فحص نهائي لـP2 deferred registry والتأكد أنه لم يدخل أي كود غير مدعوم.

استخدم أوامر تحقق متناسبة مع الملفات الفعلية، مثل:

```powershell
C:\flutter\bin\cache\dart-sdk\bin\dart.exe format <exact-changed-files>
flutter analyze <exact-changed-files-or-relevant-scope>
flutter test test/features/owner/finance
flutter test test/features/owner/supervisors
flutter test
git diff --check
```

إذا كان بالمشروع اختبار scratch معروف غير تابع للمنتج، استخدم قائمة الاختبارات الموثقة في handoff السابق بدل حذف الملف أو تعديل الاختبارات لتجاوز الفشل. أي فشل جديد يجب إصلاح سببه، لا تعطيل الاختبار.

# 19. شروط التوقف والتصعيد

أوقف الجزئية المتأثرة واكتب تقريرًا واضحًا إذا حدث أحد الآتي:

- اختلف payload الحقيقي عن العقد المسجل هنا.
- احتاجت الواجهة عملية API غير موجودة.
- ظهر نوع بيانات جديد لا يمكن تمثيله دون `dynamic` أو تخمين.
- تعارض تغيير مطلوب مع تغييرات مستخدم غير مدمجة.
- فشلت اختبارات baseline قبل تعديلاتك ولم يكن السبب من نطاقك.

التقرير يجب أن يحتوي: الأمر/الطلب، status code إن وجد، response shape بعد إخفاء الأسرار، الملف المتأثر، ما تم تجربته، والقرار الآمن. لا تضع token أو بيانات شخصية في الخطة أو السجلات.

# 20. تعريف الإنجاز النهائي

تُعد المهمة مكتملة فقط عندما:

- تُنجز الحسابات المالية العامة ضمن العقود الأربعة المؤكدة.
- تُنجز إدارة مشرفي الصيانة ضمن list/form-data/create فقط.
- تمر جميع بوابات الجودة والاختبارات دون regression.
- تكون الترجمة والثيم والاستجابة وRTL/LTR وحالات الخطأ/الفراغ مكتملة.
- تكون ملفات handoff دقيقة وقابلة لإعادة التحقق.
- تبقى بقية P2 مؤجلة بلا كود تخميني أو واجهات مضللة.

في ردك النهائي، اعرض لكل مرحلة: ما نُفذ، ملفات رئيسية، العقود المستخدمة، عدد الاختبارات ونتائجها، أي انحراف مبرر، ثم قائمة P2 المؤجلة. لا تقل "تم بالكامل" قبل اجتياز full regression.
