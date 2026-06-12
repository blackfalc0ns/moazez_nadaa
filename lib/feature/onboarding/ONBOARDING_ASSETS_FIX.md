# Onboarding Assets Fix

## المشكلة
```
FlutterError (Unable to load asset: "assets/images/onboarding/on_1.png". Exception: Asset not found)
```

## السبب
في ملف `pubspec.yaml`، كان مجلد `assets/images/onboarding/` غير معرّف بشكل صريح في قسم `assets`.

## الحل
تم إضافة المجلد الفرعي `assets/images/onboarding/` إلى قسم `assets` في ملف `pubspec.yaml`:

```yaml
assets:
  - assets/images/
  - assets/icons/
  - assets/images/rank/
  - assets/images/onboarding/  # ✅ تم إضافة هذا السطر
  - assets/fonts/
```

## الملفات الموجودة
✅ `assets/images/onboarding/on_1.png`
✅ `assets/images/onboarding/on_2.png`
✅ `assets/images/onboarding/on_3.jpg`

## الخطوات المتبعة
1. ✅ إضافة `assets/images/onboarding/` إلى `pubspec.yaml`
2. ✅ تشغيل `flutter clean` لمسح الـ cache
3. ✅ تشغيل `flutter pub get` لتحديث التبعيات

## النتيجة
✅ تم حل المشكلة - الآن يمكن للتطبيق تحميل صور الـ onboarding بنجاح

## ملاحظة
عند إضافة مجلدات فرعية جديدة داخل `assets/images/`، يجب تعريفها بشكل صريح في `pubspec.yaml` أو استخدام:
```yaml
assets:
  - assets/images/  # هذا يشمل الملفات في المجلد الرئيسي فقط
  - assets/images/onboarding/  # يجب تعريف المجلدات الفرعية بشكل صريح
```

أو يمكن استخدام:
```yaml
assets:
  - assets/  # هذا يشمل جميع الملفات والمجلدات الفرعية
```
