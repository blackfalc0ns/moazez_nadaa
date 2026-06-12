# Container Theme Guide

## نظرة عامة
تم إضافة `ContainerThemeExtension` إلى الـ Theme لتحديد لون الـ Container تلقائياً بناءً على الوضع الحالي (فاتح/داكن).

## الألوان المستخدمة

### الوضع الفاتح (Light Mode)
```dart
containerColor: AppColors.surfaceLight
```

### الوضع الداكن (Dark Mode)
```dart
containerColor: AppColors.surfaceDark
```

## كيفية الاستخدام

### الطريقة الأولى: استخدام Theme Extension
```dart
final containerColor = Theme.of(context).extension<ContainerThemeExtension>()?.containerColor;

Container(
  color: containerColor,
  padding: EdgeInsets.all(16),
  child: Text('محتوى الحاوية'),
)
```

### الطريقة الثانية: استخدام Theme.of(context).cardColor
يمكنك أيضاً استخدام `Theme.of(context).cardColor` مباشرة:
```dart
Container(
  color: Theme.of(context).cardColor,
  padding: EdgeInsets.all(16),
  child: Text('محتوى الحاوية'),
)
```

### الطريقة الثالثة: استخدام AppColors مباشرة مع isDark
```dart
final isDark = Theme.of(context).brightness == Brightness.dark;

Container(
  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
  padding: EdgeInsets.all(16),
  child: Text('محتوى الحاوية'),
)
```

## أمثلة عملية

### مثال 1: Container بسيط
```dart
Widget buildContainer(BuildContext context) {
  final containerColor = Theme.of(context).extension<ContainerThemeExtension>()?.containerColor;
  
  return Container(
    color: containerColor,
    padding: EdgeInsets.all(AppSpacing.md),
    child: Text('نص داخل الحاوية'),
  );
}
```

### مثال 2: Container مع BoxDecoration
```dart
Widget buildDecoratedContainer(BuildContext context) {
  final containerColor = Theme.of(context).extension<ContainerThemeExtension>()?.containerColor;
  
  return Container(
    decoration: BoxDecoration(
      color: containerColor,
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      boxShadow: AppShadows.small,
    ),
    padding: EdgeInsets.all(AppSpacing.md),
    child: Text('نص داخل الحاوية'),
  );
}
```

### مثال 3: Container مع Gradient
```dart
Widget buildGradientContainer(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: isDark 
          ? [AppColors.surfaceDark, AppColors.backgroundDark]
          : [AppColors.surfaceLight, AppColors.backgroundLight],
      ),
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
    ),
    padding: EdgeInsets.all(AppSpacing.md),
    child: Text('نص داخل الحاوية'),
  );
}
```

## الفوائد

✅ **تلقائي**: يتغير لون الـ Container تلقائياً عند تغيير الوضع (فاتح/داكن)
✅ **متسق**: جميع الـ Containers تستخدم نفس الألوان من Core Design System
✅ **سهل الاستخدام**: طريقة واحدة للحصول على اللون المناسب
✅ **قابل للتخصيص**: يمكن تعديل الألوان من مكان واحد في `app_theme.dart`

## ملاحظات مهمة

1. **استخدم `Theme.of(context)`**: دائماً استخدم `Theme.of(context)` للحصول على اللون الصحيح بناءً على الوضع الحالي
2. **تجنب الألوان الثابتة**: لا تستخدم `Colors.white` أو `Colors.black` مباشرة في الـ Containers
3. **استخدم Core Colors**: دائماً استخدم `AppColors` من Core Design System
4. **اختبر في الوضعين**: تأكد من أن الـ Container يظهر بشكل صحيح في الوضعين الفاتح والداكن

## التكامل مع Core Design System

يمكنك دمج Container Theme مع باقي ثوابت Core:

```dart
Widget buildCoreContainer(BuildContext context) {
  final containerColor = Theme.of(context).extension<ContainerThemeExtension>()?.containerColor;
  
  return Container(
    decoration: BoxDecoration(
      color: containerColor,
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      boxShadow: AppShadows.medium,
    ),
    padding: EdgeInsets.all(AppSpacing.lg),
    margin: EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    child: Text(
      'نص مع Core Typography',
      style: AppTypography.bodyLarge,
    ),
  );
}
```

## الخلاصة

الآن يمكنك استخدام `ContainerThemeExtension` للحصول على لون الـ Container المناسب تلقائياً في كلا الوضعين الفاتح والداكن، مما يضمن تجربة مستخدم متسقة وجميلة! 🎨
