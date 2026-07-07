import 'package:get_it/get_it.dart';

import '../../presentation/cubits/dismissal_cubit.dart';
import '../repositories/dismissal_repo.dart';

class DismissalDI {
  static void init(GetIt sl) {
    if (!sl.isRegistered<DismissalRepo>()) {
      sl.registerLazySingleton<DismissalRepo>(() => DismissalRepo());
    }

    if (!sl.isRegistered<DismissalCubit>()) {
      sl.registerFactory<DismissalCubit>(
        () => DismissalCubit(repo: sl(), realtimeService: sl()),
      );
    }
  }
}
