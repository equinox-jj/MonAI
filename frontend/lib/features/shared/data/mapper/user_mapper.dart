import 'package:monai/core/database/monai_database.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';
import 'package:monai/features/shared/data/model/me_response.dart';
import 'package:monai/features/shared/domain/entity/user.dart';

extension MeDataMapper on MeData {
  UserRow toRow() {
    final roleData = requireField(role);
    return UserRow(
      id: requireField(id),
      name: requireField(name),
      email: requireField(email),
      avatarUrl: avatarUrl,
      timezone: requireField(timezone),
      roleSlug: requireField(roleData.slug),
      roleName: requireField(roleData.name),
      permissions: [...?permissions]..sort(),
      createdAt: requireField(createdAt),
    );
  }
}

extension UserMapper on User {
  UserRow toRow() => UserRow(
    id: id,
    name: name,
    email: email,
    avatarUrl: avatarUrl,
    timezone: timezone,
    roleSlug: role.slug,
    roleName: role.name,
    permissions: permissions.toList()..sort(),
    createdAt: createdAt,
  );
}

extension UserRowMapper on UserRow {
  User toEntity() => User(
    id: id,
    name: name,
    email: email,
    avatarUrl: avatarUrl,
    timezone: timezone,
    role: UserRole(slug: roleSlug, name: roleName),
    permissions: permissions.toSet(),
    createdAt: createdAt,
  );
}
