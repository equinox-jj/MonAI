import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/profile/presentation/model/profile_field_error_text.dart';
import 'package:monai/features/profile/presentation/pages/edit_profile/bloc/edit_profile_bloc.dart';

class EditProfileDeleteCard extends StatelessWidget {
  const EditProfileDeleteCard({
    required this.password,
    required this.onPasswordChanged,
    required this.onDelete,
    super.key,
  });

  final TextEditingController password;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.colors;
    final t = context.textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.errorContainer,
        borderRadius: MonAIRadius.lgAll,
        border: Border.all(color: c.errorContainerBorder),
      ),
      child: Padding(
        padding: const .all(MonAISpacing.x4),
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: MonAISpacing.x3,
          children: [
            Row(
              spacing: MonAISpacing.x2,
              children: [
                MonAIIcon(MonAIIcons.personRemove, color: c.errorText),
                Text(
                  l10n.profileDeleteTitle,
                  style: t.titleMedium?.copyWith(color: c.errorText),
                ),
              ],
            ),
            Text(
              l10n.profileDeleteBody,
              style: t.bodySmall?.copyWith(color: c.onErrorContainer),
            ),
            BlocSelector<EditProfileBloc, EditProfileState, (String?, bool)>(
              selector: (state) =>
                  (state.passwordError?.text(l10n), state.isDeleting),
              builder: (context, selected) {
                final (error, isDeleting) = selected;
                return Column(
                  crossAxisAlignment: .stretch,
                  spacing: MonAISpacing.x3,
                  children: [
                    MonAIPasswordField(
                      controller: password,
                      onChanged: onPasswordChanged,
                      onSubmitted: (_) => onDelete(),
                      placeholder: l10n.profileDeletePassword,
                      showPasswordLabel: l10n.authShowPassword,
                      hidePasswordLabel: l10n.authHidePassword,
                      supportingText: error,
                      tone: error == null ? .neutral : .error,
                      enabled: !isDeleting,
                      textInputAction: TextInputAction.done,
                    ),
                    MonAIButton(
                      label: l10n.profileDeleteButton,
                      variant: .destructive,
                      size: .medium,
                      expand: true,
                      loading: isDeleting,
                      onPressed: isDeleting ? null : onDelete,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
