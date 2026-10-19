import 'package:monai/features/auth/data/model/auth_response.dart' as model;
import 'package:monai/features/auth/domain/entity/auth_session.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/domain/entity/user.dart';

extension AuthResponseMapper on model.AuthResponse {
  /// Fails as a malformed response when the session is incomplete, so a bad
  /// payload never starts a half-made session.
  AuthSession toEntity() => requireField(data).toEntity();
}

extension AuthDataMapper on model.Data {
  AuthSession toEntity() {
    final token = requireField(accessToken);
    if (token.isEmpty) malformed();
    return AuthSession(
      accessToken: token,
      tokenType: requireField(tokenType),
      expiresIn: Duration(seconds: requireField(expiresIn)),
      user: requireField(user).toEntity(),
    );
  }
}

extension AuthUserMapper on model.User {
  User toEntity() {
    final roleData = requireField(role);
    return User(
      id: requireField(id),
      name: requireField(name),
      email: requireField(email),
      avatarUrl: avatarUrl,
      timezone: requireField(timezone),
      role: UserRole(
        slug: requireField(roleData.slug),
        name: requireField(roleData.name),
      ),
      permissions: {...?permissions},
      createdAt: requireField(createdAt),
    );
  }
}
