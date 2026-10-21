import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/network/session_manager.dart';

/// Ends the user's session; navigation follows the session to Sign in.
abstract class SessionRepository {
  /// Signs out of this device only; the token stays valid on the server
  /// until it expires. Fails only when the token could not be removed, and
  /// the user is then still signed in. Gives [SessionStatus.signedOut].
  Future<Either<Failure, SessionStatus>> logout();

  /// Revokes the account's tokens on every device, then signs out here.
  /// Gives [SessionStatus.signedOut].
  Future<Either<Failure, SessionStatus>> logoutAllDevices();
}
