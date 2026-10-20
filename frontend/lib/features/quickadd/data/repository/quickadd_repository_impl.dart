import 'package:fpdart/fpdart.dart';
import 'package:monai/core/data/base_repository.dart';
import 'package:monai/core/error/failure.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/quickadd/data/datasources/quickadd_local_datasource.dart';
import 'package:monai/features/quickadd/data/datasources/quickadd_remote_datasource.dart';
import 'package:monai/features/quickadd/data/mapper/quickadd_mapper.dart';
import 'package:monai/features/quickadd/data/model/parse_transaction_request.dart';
import 'package:monai/features/quickadd/domain/entity/ai_draft.dart';
import 'package:monai/features/quickadd/domain/repository/quickadd_repository.dart';
import 'package:monai/features/shared/data/mapper/api_values.dart';

class QuickaddRepositoryImpl extends QuickaddRepository with BaseRepository {
  QuickaddRepositoryImpl({required this._remote, required this._local});

  final QuickaddRemoteDataSource _remote;
  final QuickaddLocalDataSource _local;

  @override
  Future<Either<Failure, List<AiDraft>>> parse(
    String text, {
    required DateTime today,
    required String timezone,
  }) => safeCall(() async {
    final response = await _remote.parseTransaction(
      ParseTransactionRequest(
        text: text,
        today: formatApiDate(today),
        timezone: timezone,
      ),
    );
    final drafts = requireField(response.data?.drafts);
    return [for (final draft in drafts) draft.toEntity()];
  });

  @override
  Future<Either<Failure, String?>> categoryForNote(
    String note,
    TransactionType type,
  ) => safeCall(() => _local.categoryForText(note.trim().toLowerCase(), type));
}
