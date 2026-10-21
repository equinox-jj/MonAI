import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/shared/domain/entity/user.dart';

part 'auth_session.freezed.dart';

@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String accessToken,
    required String tokenType,
    required Duration expiresIn,
    required User user,
  }) = _AuthSession;
}
