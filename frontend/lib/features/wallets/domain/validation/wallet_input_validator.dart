import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/features/shared/domain/entity/wallet_input.dart';

/// The one place wallet input is cleaned up: use cases apply it once, then
/// validate and send the same values.
extension WalletInputCleanup on WalletInput {
  WalletInput get normalized => copyWith(name: name.trim());
}

/// Mirrors the backend's rules (`backend/internal/wallet/dto.go`). Errors use
/// the server's field names, codes and params. Takes input already cleaned up
/// by `normalized`.
abstract final class WalletInputValidator {
  static const nameMax = 30;
  static const initialBalanceMax = 999999999999999;

  static final _color = RegExp(r'^#[0-9A-Fa-f]{6}$');
  static const nameField = 'name';
  static const typeField = 'type';
  static const initialBalanceField = 'initial_balance';
  static const colorField = 'color';

  /// In field order; empty when valid. A wallet linked to a provider may leave
  /// its name and type to the provider.
  static List<FieldError> validate(WalletInput input) {
    final custom = input.providerId == null;
    return [
      ?_nameError(input.name, required: custom),
      if (custom && input.type == null) _required(typeField),
      ?_initialBalanceError(input.initialBalance),
      if (input.color case final color? when !_color.hasMatch(color))
        const FieldError(
          field: colorField,
          code: 'invalid_format',
          message: 'must be a #RRGGBB color',
        ),
    ];
  }

  static FieldError? _nameError(String name, {required bool required}) {
    if (name.isEmpty) return required ? _required(nameField) : null;
    if (name.runes.length > nameMax) {
      return const FieldError(
        field: nameField,
        code: 'max_length',
        message: 'must be at most $nameMax characters',
        params: {'max': nameMax},
      );
    }
    return null;
  }

  static FieldError? _initialBalanceError(int balance) {
    if (balance < 0) {
      return const FieldError(
        field: initialBalanceField,
        code: 'min',
        message: 'must be at least 0',
        params: {'min': 0},
      );
    }
    if (balance > initialBalanceMax) {
      return const FieldError(
        field: initialBalanceField,
        code: 'max',
        message: 'must be at most $initialBalanceMax',
        params: {'max': initialBalanceMax},
      );
    }
    return null;
  }

  static FieldError _required(String field) =>
      FieldError(field: field, code: 'required', message: 'is required');
}
