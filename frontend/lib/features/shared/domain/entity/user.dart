import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,

    /// IANA zone, e.g. `Asia/Jakarta`.
    required String timezone,
    required UserRole role,
    required Set<String> permissions,
    required DateTime createdAt,

    /// Presigned and short-lived.
    String? avatarUrl,
  }) = _User;

  const User._();

  bool hasPermission(String code) => permissions.contains(code);
}

@freezed
abstract class UserRole with _$UserRole {
  const factory UserRole({required String slug, required String name}) =
      _UserRole;
}
