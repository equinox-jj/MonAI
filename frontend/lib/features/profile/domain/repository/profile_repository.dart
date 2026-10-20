import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/features/shared/domain/entity/user.dart';

/// The signed-in user's own profile. Every change is cached, so screens
/// watching the user update.
abstract class ProfileRepository {
  /// Renames the user to a validated [name].
  Future<Either<Failure, User>> updateName(String name);

  /// The square photo at [path] as an upload-ready 512×512 WebP without
  /// EXIF data.
  Future<Either<Failure, Uint8List>> compressAvatar(String path);

  /// Uploads [bytes] as the profile photo, replacing the old one.
  /// [onProgress] gets the share sent, 0 to 1.
  Future<Either<Failure, User>> uploadAvatar(
    Uint8List bytes, {
    void Function(double progress)? onProgress,
  });

  /// Removes the profile photo; the initials show instead.
  Future<Either<Failure, Unit>> removeAvatar();

  /// Deletes the account and all its data on the server, confirmed with
  /// the user's [password]. The session is not ended here.
  Future<Either<Failure, Unit>> deleteAccount(String password);
}
