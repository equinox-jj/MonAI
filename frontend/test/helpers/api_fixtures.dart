import 'package:dio/dio.dart';

// Server JSON as the backend sends it, for data source and repository tests.

const timestampJson = '2026-10-01T08:00:00Z';

Map<String, dynamic> walletJson({
  String id = 'w1',
  String name = 'Cash',
  bool isDefault = false,
  bool isArchived = false,
}) => {
  'id': id,
  'provider_id': null,
  'name': name,
  'type': 'CASH',
  'logo_url': null,
  'initial_balance': 0,
  'current_balance': 100000,
  'icon': null,
  'color': null,
  'is_default': isDefault,
  'is_archived': isArchived,
  'created_at': timestampJson,
  'updated_at': timestampJson,
};

Map<String, dynamic> transactionJson({
  String id = 't1',
  String type = 'EXPENSE',
  String date = '2026-10-01',
  String? categoryId = 'c1',
}) => {
  'id': id,
  'type': type,
  'amount': 10000,
  'wallet_id': 'w1',
  'to_wallet_id': null,
  'category_id': categoryId,
  'date': date,
  'note': 'Kopi',
  'merchant': null,
  'receipt_url': null,
  'source': 'MANUAL',
  'created_at': timestampJson,
  'updated_at': timestampJson,
};

Map<String, dynamic> categoryJson({
  String id = 'c1',
  String type = 'EXPENSE',
  bool isHidden = false,
}) => {
  'id': id,
  'name': 'Food',
  'type': type,
  'icon': 'food',
  'color': '#FF0000',
  'is_default': true,
  'is_system': false,
  'is_hidden': isHidden,
  'created_at': timestampJson,
  'updated_at': timestampJson,
};

Map<String, dynamic> providerJson({String id = 'p1', String name = 'BCA'}) => {
  'id': id,
  'slug': name.toLowerCase(),
  'name': name,
  'type': 'BANK',
  'logo_url': null,
  'aliases': ['bank central asia'],
  'sort_order': 0,
};

Map<String, dynamic> budgetJson({String month = '2026-10'}) => {
  'month': month,
  'limit_amount': 1000000,
  'spent': 850000,
  'remaining': 150000,
  'progress_percent': 85,
  'status': 'WARNING',
};

Map<String, dynamic> monthlyReportJson({String month = '2026-10'}) => {
  'month': month,
  'income_total': 500000,
  'expense_total': 200000,
  'net': 300000,
  'previous': {
    'month': '2026-09',
    'income_total': 400000,
    'expense_total': 100000,
  },
  'expense_change_percent': 100.0,
  'categories': [
    {
      'category_id': 'c2',
      'name': 'Transport',
      'icon': null,
      'color': null,
      'amount': 150000,
      'share_percent': 75.0,
      'previous_amount': 0,
      'change_percent': null,
    },
    {
      'category_id': 'c1',
      'name': 'Food',
      'icon': 'food',
      'color': '#FF0000',
      'amount': 50000,
      'share_percent': 25.0,
      'previous_amount': 100000,
      'change_percent': -50.0,
    },
  ],
};

Map<String, dynamic> meJson() => {
  'id': 'u1',
  'name': 'Budi',
  'email': 'budi@example.com',
  'avatar_url': null,
  'timezone': 'Asia/Jakarta',
  'role': {'slug': 'user', 'name': 'User'},
  'permissions': ['wallet.update', 'transactions.read'],
  'created_at': timestampJson,
};

/// The success envelope around [data], with [meta] when given.
Map<String, dynamic> envelope(Object? data, {Map<String, dynamic>? meta}) => {
  'success': true,
  'message': 'OK',
  'data': data,
  'meta': ?meta,
};

/// A 2xx response to [path] carrying [data].
Response<Map<String, dynamic>> okResponse(
  String path,
  Map<String, dynamic>? data, {
  int statusCode = 200,
  Map<String, List<String>> headers = const {},
}) => Response(
  requestOptions: RequestOptions(path: path),
  statusCode: statusCode,
  data: data,
  headers: Headers.fromMap(headers),
);

/// What Dio throws for an error response to [path].
DioException errorResponse(String path, int statusCode, String code) {
  final options = RequestOptions(path: path);
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: options,
      statusCode: statusCode,
      data: {
        'success': false,
        'message': 'error',
        'data': null,
        'error': {'code': code},
      },
    ),
  );
}
