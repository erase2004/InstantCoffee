abstract class PasswordResetState {}

class PasswordResetInitState extends PasswordResetState {}

class PasswordResetLoading extends PasswordResetState {}

class PasswordResetSuccess extends PasswordResetState {}

class PasswordResetFail extends PasswordResetState {}

class PasswordResetError extends PasswordResetState {
  final error;
  PasswordResetError({this.error});
}
