import 'models/app_notification.dart';

class NotificationsDummyData {
  const NotificationsDummyData._();

  static const notifications = [
    AppNotification(
      id: 'NTF-501',
      title: 'طلب نداء عاجل',
      body: 'ولي أمر سلمان أحمد ينتظر في المسار السريع منذ 16 دقيقة.',
      time: 'الآن',
      type: AppNotificationType.urgentCall,
      priority: AppNotificationPriority.critical,
      isRead: false,
      relatedStudent: 'سلمان أحمد',
      gate: 'البوابة الرئيسية',
      actionLabel: 'فتح الطلب',
    ),
    AppNotification(
      id: 'NTF-500',
      title: 'تأخر في التسليم',
      body: 'ريان ماجد تجاوز حد الانتظار المسموح ويحتاج متابعة من المشرفة.',
      time: 'منذ 4 د',
      type: AppNotificationType.delayedPickup,
      priority: AppNotificationPriority.high,
      isRead: false,
      relatedStudent: 'ريان ماجد',
      gate: 'بوابة الروضة',
      actionLabel: 'تصعيد',
    ),
    AppNotification(
      id: 'NTF-499',
      title: 'تم تسليم طالب',
      body: 'تم تسليم فهد ناصر بعد مطابقة كود الاستلام وهوية ولي الأمر.',
      time: 'منذ 12 د',
      type: AppNotificationType.delivered,
      priority: AppNotificationPriority.normal,
      isRead: true,
      relatedStudent: 'فهد ناصر',
      gate: 'بوابة رقم 2',
      actionLabel: 'عرض السجل',
    ),
    AppNotification(
      id: 'NTF-498',
      title: 'تحويل بوابة مؤقت',
      body:
          'بوابة رقم 2 تحت الصيانة، يتم تحويل طلبات المتوسط للبوابة الرئيسية.',
      time: 'منذ 25 د',
      type: AppNotificationType.gate,
      priority: AppNotificationPriority.high,
      isRead: false,
      relatedStudent: 'المتوسط',
      gate: 'بوابة رقم 2',
      actionLabel: 'عرض البوابات',
    ),
    AppNotification(
      id: 'NTF-497',
      title: 'تحديث صلاحيات',
      body: 'تم تحديث صلاحيات مراجعة أولياء الأمور المعتمدين لمشرف البوابة.',
      time: '9:30 ص',
      type: AppNotificationType.system,
      priority: AppNotificationPriority.normal,
      isRead: true,
      relatedStudent: 'النظام',
      gate: 'كل البوابات',
      actionLabel: 'مراجعة',
    ),
  ];
}
