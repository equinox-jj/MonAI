import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/data/network/session_manager.dart';

abstract class SessionRepository {
  /// This device only: the token stays valid on the server until it expires.
  /// Fails only when the token couldn't be removed; the user is then still
  /// signed in.
  Future<Either<Failure, SessionStatus>> logout();

  Future<Either<Failure, SessionStatus>> logoutAllDevices();
}
