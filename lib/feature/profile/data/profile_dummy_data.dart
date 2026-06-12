import 'models/staff_profile.dart';

class ProfileDummyData {
  const ProfileDummyData._();

  static const profile = StaffProfile(
    name: 'ماجد الحربي',
    role: 'مشرف النداء والبوابة',
    employeeId: 'EMP-0421',
    schoolName: 'مدارس معزز الأهلية',
    primaryGate: 'البوابة الرئيسية',
    currentShift: 'مناوبة خروج الطلاب • 12:00 م - 2:30 م',
    phone: '050 880 1122',
    email: 'm.alharbi@moazez.school',
    permissions: [
      'إدارة طلبات النداء',
      'تأكيد تسليم الطلاب',
      'تصعيد الطلبات المتأخرة',
      'مراسلة أولياء الأمور',
      'عرض سجل النداءات',
    ],
    safetyChecks: [
      'مطابقة كود الاستلام قبل التسليم',
      'التحقق من ولي الأمر المعتمد',
      'إغلاق الطلب بعد التسليم مباشرة',
      'تصعيد الانتظار أعلى من 15 دقيقة',
    ],
    todayStats: ProfileStats(
      handledCalls: 24,
      deliveredStudents: 18,
      escalatedCalls: 3,
      averageWaitMinutes: 8,
    ),
  );
}
