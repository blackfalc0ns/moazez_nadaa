import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/dismissal_auth_repo.dart';
import 'dismissal_auth_state.dart';

class DismissalAuthCubit extends Cubit<DismissalAuthState> {
  DismissalAuthCubit({required DismissalAuthRepo repo})
    : _repo = repo,
      super(const DismissalAuthInitial());

  final DismissalAuthRepo _repo;

  Future<void> login({required String email, required String password}) async {
    emit(const DismissalAuthLoading());
    final result = await _repo.login(email: email, password: password);
    if (isClosed) return;
    result.fold(
      (failure) => emit(DismissalAuthFailure(failure)),
      (session) => emit(DismissalAuthSuccess(session)),
    );
  }
}
