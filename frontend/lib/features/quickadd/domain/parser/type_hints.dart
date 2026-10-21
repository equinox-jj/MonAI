import 'package:monai/core/model/transaction_type.dart';

abstract final class TypeHints {
  static const _hinted = 0.85;
  static const _expense = 0.9;

  static final _income = _words([
    'gaji', 'gajian', 'salary', 'terima', 'nerima', 'diterima', 'dapat', //
    'dapet', 'dpt', 'dikasih', 'bonus', 'thr', 'refund', 'cashback',
    'pemasukan', 'income', 'receive', 'received',
  ]);

  static final _transfer = _words([
    'top ?up', 'isi saldo', 'pindah', 'pindahin', 'tarik tunai', 'setor', //
    'nabung',
  ]);

  static (TransactionType, double) detect(String text) {
    if (_transfer.hasMatch(text)) return (TransactionType.transfer, _hinted);
    if (_income.hasMatch(text)) return (TransactionType.income, _hinted);
    return (TransactionType.expense, _expense);
  }

  static RegExp _words(List<String> patterns) =>
      RegExp('(?<!\\w)(${patterns.join('|')})(?!\\w)');
}
