import 'package:monai/features/auth/presentation/pages/change_password/bloc/change_password_bloc.dart';

extension ChangePasswordStateX on ChangePasswordState {
  bool get canSubmit =>
      hasCurrentPassword && hasNewPassword && !status.isSubmitting;
}
