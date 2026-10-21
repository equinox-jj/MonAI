import 'package:fpdart/fpdart.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/event/provider_change_events.dart';

/// The id of each provider as it changes from now on, so the admin list can
/// reload.
class WatchProviderChangesUseCase implements StreamUseCase<String, NoParams> {
  WatchProviderChangesUseCase(this._events);

  final ProviderChangeEvents _events;

  @override
  Stream<Either<Failure, String>> call(NoParams params) =>
      _events.stream.map(Right.new);
}
