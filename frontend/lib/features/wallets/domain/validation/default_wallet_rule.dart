import 'package:monai/core/base/error/failure.dart';

/// The default wallet can't be archived or deleted: another wallet must become
/// the default first. Fails the same way as the server's 422.
abstract final class DefaultWalletRule {
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
