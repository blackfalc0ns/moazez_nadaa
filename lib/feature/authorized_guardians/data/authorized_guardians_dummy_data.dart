import 'models/authorized_guardian.dart';

class AuthorizedGuardiansDummyData {
  const AuthorizedGuardiansDummyData._();

  static const gates = [
    'الكل',
    'البوابة الرئيسية',
    'بوابة الحضانة',
    'بوابة البنات',
    'بوابة الروضة',
    'بوابة رقم 2',
  ];

  static const guardians = [
    AuthorizedGuardian(
      id: 'GDN-401',
      name: 'أحمد محمد',
      relation: 'الأب',
      nationalIdMasked: '********4821',
      phone: '050 123 4499',
      allowedGate: 'البوابة الرئيسية',
      allowedStudents: ['سلمان أحمد'],
      status: GuardianTrustStatus.verified,
      lastVerifiedAt: 'اليوم 10:40 ص',
      expiryLabel: 'مستمر',
      notes: 'مخول دائم، تم التحقق من الهوية والكود.',
    ),
    AuthorizedGuardian(
      id: 'GDN-402',
      name: 'خالد عبدالله',
      relation: 'الأب',
      nationalIdMasked: '********9134',
      phone: '055 771 2201',
      allowedGate: 'بوابة الحضانة',
      allowedStudents: ['لينا خالد', 'مريم خالد'],
      status: GuardianTrustStatus.verified,
      lastVerifiedAt: 'اليوم 10:35 ص',
      expiryLabel: 'مستمر',
      notes: 'مخول لأطفال الحضانة فقط.',
    ),
    AuthorizedGuardian(
      id: 'GDN-403',
      name: 'نورة علي',
      relation: 'الأم',
      nationalIdMasked: '********2088',
      phone: '056 442 9900',
      allowedGate: 'بوابة الروضة',
      allowedStudents: ['ريان ماجد'],
      status: GuardianTrustStatus.reviewNeeded,
      lastVerifiedAt: 'أمس 1:20 م',
      expiryLabel: 'تحتاج تحديث',
      notes: 'يوجد اختلاف في رقم الهاتف المسجل، يلزم مراجعة الإدارة.',
    ),
    AuthorizedGuardian(
      id: 'GDN-404',
      name: 'سامي فهد',
      relation: 'الأب',
      nationalIdMasked: '********5570',
      phone: '053 884 2120',
      allowedGate: 'بوابة البنات',
      allowedStudents: ['جود سامي'],
      status: GuardianTrustStatus.temporary,
      lastVerifiedAt: 'اليوم 9:15 ص',
      expiryLabel: 'ينتهي اليوم',
      notes: 'تصريح خروج مبكر لليوم فقط.',
    ),
    AuthorizedGuardian(
      id: 'GDN-405',
      name: 'ناصر صالح',
      relation: 'الأب',
      nationalIdMasked: '********7712',
      phone: '054 300 1010',
      allowedGate: 'بوابة رقم 2',
      allowedStudents: ['فهد ناصر'],
      status: GuardianTrustStatus.suspended,
      lastVerifiedAt: 'الأسبوع الماضي',
      expiryLabel: 'موقوف',
      notes: 'لا يتم التسليم لهذا الحساب قبل موافقة الإدارة.',
    ),
  ];
}
