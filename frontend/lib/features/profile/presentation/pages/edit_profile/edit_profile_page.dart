import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/data/services/avatar_photo_service.dart';
import 'package:monai/features/profile/domain/validation/profile_input_validator.dart';
import 'package:monai/features/profile/presentation/model/profile_failure.dart';
import 'package:monai/features/profile/presentation/model/profile_field_error_text.dart';
import 'package:monai/features/profile/presentation/pages/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:monai/features/profile/presentation/pages/edit_profile/widgets/edit_profile_avatar.dart';
import 'package:monai/features/profile/presentation/pages/edit_profile/widgets/edit_profile_delete_card.dart';
import 'package:monai/features/profile/presentation/pages/edit_profile/widgets/edit_profile_photo_sheet.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({this.focusDelete = false, super.key});

  /// Opens scrolled to the delete-account card.
  final bool focusDelete;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<EditProfileBloc>()..add(const EditProfileEvent.started()),
      child: EditProfileUI(focusDelete: focusDelete),
    );
  }
}

/// The display name, the profile photo and deleting the account.
class EditProfileUI extends StatefulWidget {
  const EditProfileUI({this.focusDelete = false, super.key});

  final bool focusDelete;

  @override
  State<EditProfileUI> createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
  static const _readableWidth = 560.0;

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _deleteCard = GlobalKey();

  @override
  void initState() {
    super.initState();
    _fillName(context, _bloc.state);
    if (widget.focusDelete) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showDeleteCard());
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  EditProfileBloc get _bloc => context.read<EditProfileBloc>();

  void _showDeleteCard() {
    final target = _deleteCard.currentContext;
    if (target != null) Scrollable.ensureVisible(target);
  }

  /// The fields start with the saved name and email, once they are known.
  void _fillName(BuildContext context, EditProfileState state) {
    if (state.user case final user?) {
      if (_name.text.isEmpty) _name.text = user.name;
      _email.text = user.email;
    }
  }

  void _nameEdited(String text) => _bloc.add(EditProfileEvent.nameEdited(text));

  void _save() => _bloc.add(EditProfileEvent.saveRequested(_name.text));

  void _passwordEdited(String _) =>
      _bloc.add(const EditProfileEvent.passwordEdited());

  void _delete() => _bloc.add(EditProfileEvent.deleteRequested(_password.text));

  void _removePhoto() =>
      _bloc.add(const EditProfileEvent.removePhotoRequested());

  void _pickPhoto(AvatarPhotoSource source) {
    final l10n = context.l10n;
    _bloc.add(
      EditProfileEvent.photoSourcePicked(
        source,
        AvatarCropLabels(
          title: l10n.profileCropTitle,
          done: l10n.profileCropDone,
          cancel: l10n.profileCancel,
        ),
      ),
    );
  }

  void _openPhotoSheet() => showMonAIBottomSheet<void>(
    context,
    title: context.l10n.profilePhotoTitle,
    builder: (_) => EditProfilePhotoSheet(
      hasPhoto: _bloc.state.hasPhoto,
      onSource: _pickPhoto,
      onRemove: _removePhoto,
    ),
  );

  Future<void> _askDelete(BuildContext context, EditProfileState state) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => MonAIAlertDialog(
        title: l10n.profileDeleteConfirmTitle,
        message: l10n.profileDeleteConfirmMessage,
        icon: MonAIIcons.personRemove,
        tone: .error,
        destructive: true,
        confirmLabel: l10n.profileDeleteConfirm,
        onConfirm: () => Navigator.pop(dialogContext, true),
        dismissLabel: l10n.profileCancel,
        onDismiss: () => Navigator.pop(dialogContext, false),
      ),
    );
    if ((confirmed ?? false) && mounted) {
      _bloc.add(EditProfileEvent.deleteConfirmed(_password.text));
    }
  }

  void _showNotice(BuildContext context, EditProfileState state) {
    final l10n = context.l10n;
    if (state.notice case final notice?) {
      showMonAISnackBar(
        context,
        message: switch (notice) {
          ProfileNotice.nameSaved => l10n.profileSaved,
          ProfileNotice.photoUpdated => l10n.profilePhotoUpdated,
          ProfileNotice.photoRemoved => l10n.profilePhotoRemoved,
        },
        icon: MonAIIcons.checkCircle,
      );
    }
  }

  void _showFailure(BuildContext context, EditProfileState state) {
    if (state.failure case final failure?) {
      showMonAISnackBar(context, message: failure.message(context.l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    return MultiBlocListener(
      listeners: [
        BlocListener<EditProfileBloc, EditProfileState>(
          listenWhen: (previous, current) =>
              previous.user == null && current.user != null,
          listener: _fillName,
        ),
        BlocListener<EditProfileBloc, EditProfileState>(
          listenWhen: (previous, current) =>
              current.askDelete && !previous.askDelete,
          listener: _askDelete,
        ),
        BlocListener<EditProfileBloc, EditProfileState>(
          listenWhen: (previous, current) =>
              current.notice != null && previous.notice != current.notice,
          listener: _showNotice,
        ),
        BlocListener<EditProfileBloc, EditProfileState>(
          listenWhen: (previous, current) =>
              current.failure != null && previous.failure != current.failure,
          listener: _showFailure,
        ),
      ],
      child: Scaffold(
        backgroundColor: c.surface,
        appBar: MonAITopBar(
          title: l10n.profileTitle,
          actions: [_SaveAction(onSave: _save)],
        ),
        body: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _readableWidth),
              child: SingleChildScrollView(
                padding: const .fromLTRB(
                  MonAISpacing.screenHorizontal,
                  MonAISpacing.x2,
                  MonAISpacing.screenHorizontal,
                  MonAISpacing.x6,
                ),
                child: Column(
                  crossAxisAlignment: .stretch,
                  spacing: MonAISpacing.x5,
                  children: [
                    EditProfileAvatar(
                      onChangePhoto: _openPhotoSheet,
                      onRemovePhoto: _removePhoto,
                    ),
                    _NameField(controller: _name, onChanged: _nameEdited),
                    MonAITextField(
                      controller: _email,
                      label: l10n.profileEmail,
                      enabled: false,
                    ),
                    EditProfileDeleteCard(
                      key: _deleteCard,
                      password: _password,
                      onPasswordChanged: _passwordEdited,
                      onDelete: _delete,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SaveAction extends StatelessWidget {
  const _SaveAction({required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(right: MonAISpacing.x2),
      child: BlocSelector<EditProfileBloc, EditProfileState, (bool, bool)>(
        selector: (state) => (state.canSave, state.isSavingName),
        builder: (context, selected) {
          final (canSave, isSaving) = selected;
          return MonAIButton(
            label: context.l10n.profileSave,
            size: .small,
            loading: isSaving,
            onPressed: canSave ? onSave : null,
          );
        },
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<EditProfileBloc, EditProfileState, String?>(
      selector: (state) => state.nameError?.text(l10n),
      builder: (context, error) => MonAITextField(
        controller: controller,
        onChanged: onChanged,
        label: l10n.profileName,
        maxLength: ProfileInputValidator.nameMaxLength,
        inputFormatters: [
          LengthLimitingTextInputFormatter(ProfileInputValidator.nameMaxLength),
        ],
        autofillHints: const [AutofillHints.name],
        textInputAction: TextInputAction.done,
        supportingText: error,
        tone: error == null ? .neutral : .error,
      ),
    );
  }
}
