import 'package:get_it/get_it.dart';

import '../../presentation/cubits/dismissal_auth_cubit.dart';
import '../repositories/dismissal_auth_repo.dart';

class DismissalAuthDI {
  const DismissalAuthDI._();

  static void init(GetIt sl) {
    if (!sl.isRegistered<DismissalAuthRepo>()) {
      sl.registerLazySingleton<DismissalAuthRepo>(() => DismissalAuthRepo());
    }
    if (!sl.isRegistered<DismissalAuthCubit>()) {
      sl.registerFactory<DismissalAuthCubit>(
        () => DismissalAuthCubit(repo: sl()),
      );
    }
  }
}
