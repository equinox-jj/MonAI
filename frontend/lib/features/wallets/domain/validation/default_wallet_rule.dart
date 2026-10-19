import 'package:monai/core/error/failure.dart';

/// The default wallet can't be archived or deleted: the user must make
/// another wallet the default first. Fails the same way as the server's 422.
abstract final class DefaultWalletRule {
  /// The server's `error.code` for this rule.
  static const code = 'default_wallet_required';

  static const archiveFailure = Failure.validation(
    [],
    message: 'The default wallet cannot be archived',
    code: code,
  );

  static const deleteFailure = Failure.validation(
    [],
    message: 'The default wallet cannot be deleted',
    code: code,
  );
}
