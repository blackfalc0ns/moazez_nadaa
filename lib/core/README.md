# التطبيق المعماري لطبقة الـ Core (Enterprise Architecture)

هذا الملف يمثل الدليل الشامل والمفصل لطبقة الـ `core` الخاصة بالتطبيق. تم تصميم هذه الطبقة لتكون **قلب التطبيق النابض**، بحيث تحتوي على كل الأساسيات (Infrastructure)، الأدوات المشتركة (Shared Utilities)، والمكونات العالمية (Global Components) التي تعتمد عليها باقي الـ Features، وذلك وفقاً لمعايير **Clean Architecture** ومبادئ **SOLID**.

---

## 📋 الأهداف الرئيسية (Core Objectives)

1. **الاستقلالية التامة (Loose Coupling):** لا تعتمد طبقة الـ `core` على أي Feature، بل الـ Features هي من تعتمد عليها.
2. **قابلية التوسع (High Scalability):** مبنية لتحمل إضافة مئات الفيتشرات دون التأثير على استقرار التطبيق.
3. **عدم التكرار (DRY Principle):** تجميع جميع المكونات القابلة لإعادة الاستخدام في مكان مركزي واحد.
4. **جودة الإنتاج (Production-Ready):** تتضمن أنظمة متقدمة للـ Networking، الـ Caching، معالجة الأخطاء (Error Handling)، والـ UI المرن.

---

## 📂 الهيكلة العامة للمجلدات (Folder Structure Breakdown)

```text
lib/core/
├── api/             # إعدادات واجهات برمجة التطبيقات (API Configs)
├── config/          # إعدادات بيئات العمل (Development, Staging, Production)
├── constants/       # الثوابت العامة (مثل Storage Keys)
├── di/              # حقن الاعتمادات (Dependency Injection / Service Locator)
├── error_widgets/   # مكونات واجهة المستخدم الخاصة بالأخطاء (مثل No Internet Widget)
├── errors/          # نظام معالجة الأخطاء (Exceptions, Failures, Error Mappers)
├── extensions/      # الإضافات البرمجية لتسهيل الكود (String, Context extensions)
├── helpers/         # دوال مساعدة (مثل Location Helper)
├── mixins/          # الـ Mixins المشتركة (مثل Validation Mixin)
├── network/         # نظام الاتصال بالإنترنت والـ Dio (Interceptors, Token Managers)
├── routing/         # إدارة مسارات التطبيق والتنقل (Routes, Routing Service)
├── services/        # الخدمات العالمية (Global Services مثل التنبيهات المحلية)
├── storage/         # أدوات التخزين المحلي (Local/Secure Storage)
├── theme/           # إدارة الثيمات (Dark/Light Mode, Colors, Typography)
└── utils/           # الأدوات والمكونات المرئية المشتركة (Shared Widgets, Feedback Services)
```

---

## 🌐 نظام الاتصال (Networking System)

نظام الشبكات مبني على مكتبة `Dio` ليكون قوياً وموثوقاً:
- **`DioFactory`:** مصنع مخصص لإنشاء وإعداد `Dio` بناءً على البيئة الحالية (`Environment`) وإضافة الـ Interceptors المناسبة (يوجد نُسخ مخصصة للتحميل والرفع).
- **Interceptors:**
  - `LoggingInterceptor`: لطباعة تفاصيل الطلبات والردود (Headers, Body, Status) في وضع التطوير فقط لتسهيل التتبع.
  - `AuthInterceptor`: يقوم بحقن الـ Token تلقائياً في كل طلب وإدارة عملية تحديثه إذا انتهت صلاحيته.
  - `ErrorInterceptor`: لاصطياد أخطاء الشبكة، تحليل استجابة الخادم (Server Response)، وتحويلها إلى Exceptions واضحة.
  - `RetryInterceptor`: محاولة إعادة إرسال الطلب تلقائياً في حالة الفشل (مثلاً: 3 محاولات مع تأخير تصاعدي).

---

## 🚨 إدارة الأخطاء (Error Handling Architecture)

تم اتباع نهج احترافي يعزل أخطاء قواعد البيانات أو السيرفر عن المستخدم النهائي:
1. **`Exceptions` (طبقة البيانات):**
   - أخطاء مثل `ServerException`، `NetworkException`، و `CacheException`.
   - يتم اصطيادها في طبقة الـ Repository.
2. **`Failures` (طبقة الأعمال):**
   - تحويل الـ `Exceptions` السابقة إلى `Failure` (مثلاً: `ServerFailure`).
3. **`ErrorMapper` & `ErrorHandler`:**
   - مهمته أخذ الـ `Failure` أو كود الخطأ (مثل 401، 500) وتحويله إلى **رسالة نصية مقروءة للمستخدم** (بناءً على لغة التطبيق الحالية - Localization).
   - يتم التأكد من عدم عرض أي أخطاء JSON خام (Raw errors) للمستخدم النهائي.

---

## 🎨 نظام الثيم (Theme Architecture)

نظام مرن جداً يدعم الـ **Dark / Light Mode**:
- **`AppColors`:** المرجع الوحيد لكل ألوان التطبيق. تم تقسيمه إلى الألوان الأساسية، الخلفيات، النصوص، وألوان الأخطاء لكل وضع (Light/Dark).
- **`light_theme.dart` & `dark_theme.dart`:** تعريف كامل ومفصل لـ `ThemeData` يغطي (AppBar, Buttons, Cards, Inputs, Dialogs).
- **Typography & Radius:** استخراج المقاسات والخطوط في `font_manger.dart` و `app_radius.dart` لتوحيد المسافات والهوية البصرية.

---

## 🧩 الواجهات والتنبيهات (UI & Feedback Systems)

يحتوي مجلد `utils/` على كافة الأدوات التي تمنع التكرار (Boilerplate):
- **المكونات المشتركة (`common/` و `widgets/`):**
  - `CustomButton` و `CompactButton`: أزرار متكيفة تلقائياً مع الثيم وحالة التحميل.
  - `CustomTextField`: حقول إدخال موحدة مع إعدادات الـ Validation.
  - `LoadingWidget` و `EmptyStateWidget` و `ErrorStateWidget`: لتوحيد عرض حالات الشاشة المختلفة.
- **التنبيهات (Feedback):**
  - أنظمة تم بناؤها خصيصاً للتنبيهات العائمة:
  - `CustomSnackbar`، `ToastService`، `DialogService`.
  - تدعم الـ Animations، الأيقونات الدلالية (نجاح، خطأ، تحذير)، والتوافق الكامل مع اتجاه اللغة (RTL/LTR).

---

## 💾 التخزين المحلي (Storage)

- **`StorageKeys`:** مرجع (Constants) لجميع مفاتيح التخزين لتجنب الأخطاء الإملائية.
- **`SecureStorage` / `LocalStorage`:** كلاسات مُجردة (Wrappers) للتعامل مع الذاكرة المحلية بأمان (مثل تشفير الـ Token) وحفظ التفضيلات (Preferences).

---

## 🛠️ إرشادات المطورين (Developer Guidelines)

للحفاظ على جودة هذه الطبقة، يرجى الالتزام بالآتي:
1. **لا تعتمد على الـ Features هنا:** يمنع منعاً باتاً عمل `import` لأي ملف يقع خارج الـ `core` (عدا الـ generated files).
2. **عزل المكتبات (Wrappers):** أي مكتبة خارجية يجب أن يتم بناء Wrapper لها في الـ `core` بدلاً من استخدامها المباشر في الفيتشرات.
3. **Localization:** أي نص (String) يُعرض للمستخدم داخل الـ `core` (كالأخطاء والتنبيهات) يجب أن يكون مرتبطاً بنظام الترجمة لدعم اللغتين العربية والإنجليزية.
4. **التوحيد (Consistency):** عند بناء زر، كارت، أو حقل إدخال جديد في الفيتشرات، يجب استخدام المكونات المتوفرة في `core/utils` بدلاً من اختراع مكونات جديدة.

---
*تمت المراجعة والتحديث ليتوافق مع المعايير المعمارية النظيفة (Clean Architecture & SOLID).*
