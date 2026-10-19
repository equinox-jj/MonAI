import 'package:monai/core/error/field_error.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/shared/domain/entity/transaction_input.dart';

/// The one place transaction input is cleaned up. Use cases apply it once,
/// then validate and send the same values.
extension TransactionInputCleanup on TransactionInput {
  /// Drops the destination wallet unless it is a transfer and the category
  /// on a transfer, trims the note and merchant (blank becomes null), and
  /// drops the time of day.
  TransactionInput get normalized {
    final isTransfer = type == TransactionType.transfer;
    return copyWith(
      toWalletId: isTransfer ? toWalletId : null,
      categoryId: isTransfer ? null : categoryId,
      note: _clean(note),
      merchant: _clean(merchant),
      date: DateTime(date.year, date.month, date.day),
    );
  }

  static String? _clean(String? text) {
    final trimmed = text?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}

/// Checks a transaction form on the device with the backend's rules
/// (`backend/internal/transaction/dto.go`), so a form shows the same errors
/// offline as the server would send. Errors use the server's field names,
/// codes and params. Takes input already cleaned up by `normalized`.
abstract final class TransactionInputValidator {
  /// The largest amount the server accepts, in rupiah.
  static const amountMax = 999999999999;

  static const _noteMax = 200;
  static const _merchantMax = 100;

  /// Field names as the API sends them in `error.fields[].field`.
  static const amountField = 'amount';
  static const walletField = 'wallet_id';
  static const toWalletField = 'to_wallet_id';
  static const categoryField = 'category_id';
  static const dateField = 'date';
  static const noteField = 'note';
  static const merchantField = 'merchant';

  /// The problems with [input], in field order; empty when valid. [today] is
  /// the user's current date: a later date is rejected.
  static List<FieldError> validate(
    TransactionInput input, {
    required DateTime today,
  }) => [
    ?_amountError(input.amount),
    if (input.walletId == null) _required(walletField),
    if (input.type == TransactionType.transfer)
      ?_toWalletError(input)
    else if (input.categoryId == null)
      _required(categoryField),
    if (input.date.isAfter(DateTime(today.year, today.month, today.day)))
      const FieldError(
        field: dateField,
        code: 'future_date',
        message: 'cannot be in the future',
      ),
    ?_tooLong(noteField, input.note, _noteMax),
    ?_tooLong(merchantField, input.merchant, _merchantMax),
  ];

  static FieldError? _amountError(int amount) {
    if (amount < 1) {
      return const FieldError(
        field: amountField,
        code: 'min',
        message: 'must be at least 1',
        params: {'min': 1},
      );
    }
    if (amount > amountMax) {
      return const FieldError(
        field: amountField,
        code: 'max',
        message: 'must be at most $amountMax',
        params: {'max': amountMax},
      );
    }
    return null;
  }

  static FieldError? _toWalletError(TransactionInput input) {
    final toWalletId = input.toWalletId;
    if (toWalletId == null) return _required(toWalletField);
    if (toWalletId == input.walletId) {
      return const FieldError(
        field: toWalletField,
        code: 'not_equal',
        message: 'must differ from wallet_id',
        params: {'other': walletField},
      );
    }
    return null;
  }

  static FieldError? _tooLong(String field, String? text, int max) {
    if (text == null || text.runes.length <= max) return null;
    return FieldError(
      field: field,
      code: 'max_length',
      message: 'must be at most $max characters',
      params: {'max': max},
    );
  }

  static FieldError _required(String field) =>
      FieldError(field: field, code: 'required', message: 'is required');
}
