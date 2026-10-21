import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/features/shared/domain/entity/user.dart';

/// Every change is cached, so screens watching the user update.
abstract class ProfileRepository {
  Future<Either<Failure, User>> updateName(String name);

  Future<Either<Failure, Uint8List>> compressAvatar(String path);

  Future<Either<Failure, User>> uploadAvatar(
    Uint8List bytes, {
    void Function(double progress)? onProgress,
  });

  Future<Either<Failure, Unit>> removeAvatar();

  /// Confirmed with the user's [password]. The session is not ended here.
  Future<Either<Failure, Unit>> deleteAccount(String password);
}
