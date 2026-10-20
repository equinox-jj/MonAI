import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';

/// Confirms signing out here, or everywhere when [allDevices]. Show it with
/// [showDialog]; it pops `true` when confirmed.
class SettingsSignOutDialog extends StatelessWidget {
  const SettingsSignOutDialog({required this.allDevices, super.key});

  final bool allDevices;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MonAIAlertDialog(
      title: allDevices
          ? l10n.settingsSignOutAllTitle
          : l10n.settingsSignOutTitle,
      message: allDevices
          ? l10n.settingsSignOutAllMessage
          : l10n.settingsSignOutMessage,
      confirmLabel: allDevices ? l10n.settingsSignOutAll : l10n.settingsSignOut,
      onConfirm: () => Navigator.pop(context, true),
      dismissLabel: l10n.settingsCancel,
      icon: allDevices ? MonAIIcons.devices : MonAIIcons.logout,
      tone: allDevices ? .warning : .info,
      destructive: allDevices,
    );
  }
}
