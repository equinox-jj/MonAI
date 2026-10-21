import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/profile/domain/repository/profile_repository.dart';
import 'package:monai/features/shared/domain/entity/user.dart';

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
  final String path;
  final void Function(double progress)? onProgress;
}
