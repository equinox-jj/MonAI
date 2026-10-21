import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/profile/domain/repository/profile_repository.dart';
import 'package:monai/features/shared/domain/entity/user.dart';

/// Makes the cropped photo the profile photo: shrinks it to a 512×512 WebP
/// without location or camera data, then uploads it.
class ChangeAvatarUseCase implements UseCase<User, ChangeAvatarParams> {
  ChangeAvatarUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, User>> call(ChangeAvatarParams params) async {
    final compressed = await _repository.compressAvatar(params.path);
    return switch (compressed) {
      Left(value: final failure) => Left(failure),
      Right(value: final bytes) => _repository.uploadAvatar(
        bytes,
        onProgress: params.onProgress,
      ),
    };
  }
}

class ChangeAvatarParams {
  const ChangeAvatarParams({required this.path, this.onProgress});

  /// The square photo as cropped.
  final String path;

  /// Gets the share uploaded, 0 to 1.
  final void Function(double progress)? onProgress;
}
