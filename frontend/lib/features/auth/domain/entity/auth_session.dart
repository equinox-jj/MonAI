import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/shared/domain/entity/user.dart';

part 'auth_session.freezed.dart';

/// A session the server opened on login or register.
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String accessToken,

    /// Always `Bearer`.
    required String tokenType,

    /// How long [accessToken] stays valid from when it was issued.
    required Duration expiresIn,
    required User user,
  }) = _AuthSession;
}
