import '../../../../core/errors/failures/typed_failure.dart';
import '../../data/models/dismissal_auth_session.dart';

sealed class DismissalAuthState {
  const DismissalAuthState();
}

class DismissalAuthInitial extends DismissalAuthState {
  const DismissalAuthInitial();
}

class DismissalAuthLoading extends DismissalAuthState {
  const DismissalAuthLoading();
}

class DismissalAuthSuccess extends DismissalAuthState {
  const DismissalAuthSuccess(this.session);

  final DismissalAuthSession session;
}

class DismissalAuthPasswordChanged extends DismissalAuthState {
  const DismissalAuthPasswordChanged();
}

class DismissalAuthFailure extends DismissalAuthState {
  const DismissalAuthFailure(this.failure);

  final TypedFailure failure;
}
