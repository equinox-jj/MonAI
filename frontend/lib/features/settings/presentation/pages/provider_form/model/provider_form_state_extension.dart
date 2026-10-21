import 'package:monai/features/settings/presentation/pages/provider_form/bloc/provider_form_bloc.dart';

extension ProviderFormStateX on ProviderFormState {
  bool get isWorking => isSaving || isDeleting || isChangingStatus;

  bool get isSystem => original?.isSystem ?? false;

  bool get isReady =>
      canSave &&
      status == .success &&
      !isWorking &&
      hasName &&
      type != null &&
      sortOrderValid;
}
