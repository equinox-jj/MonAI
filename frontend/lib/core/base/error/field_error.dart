/// One entry of `error.fields[]` in a 422 `validation_failed` response.
///
/// [code] (e.g. `required`, `min`, `email`) and [params] (e.g. `{"min": 8}`)
/// drive localized text; [message] is the server's English fallback.
class FieldError {
  const FieldError({
    required this.field,
    required this.code,
    required this.message,
    this.params = const {},
  });

  /// Parses one `fields[]` item. Missing keys fall back to empty values.
  factory FieldError.fromJson(Map<dynamic, dynamic> json) {
    final rawParams = json['params'];
    return FieldError(
      field: (json['field'] ?? '').toString(),
      code: (json['code'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      params: rawParams is Map
          ? rawParams.map((key, value) => MapEntry(key.toString(), value))
          : const {},
    );
  }

  /// The request field name (snake_case, as sent by the client).
  final String field;

  /// Machine-readable rule that failed.
  final String code;

  /// English fallback message.
  final String message;

  /// Rule parameters used to fill the localized message.
  final Map<String, dynamic> params;

  @override
  bool operator ==(Object other) =>
      other is FieldError &&
      other.field == field &&
      other.code == code &&
      other.message == message &&
      _mapEquals(other.params, params);

  @override
  int get hashCode => Object.hash(
    field,
    code,
    message,
    Object.hashAllUnordered(
      params.entries.map((e) => Object.hash(e.key, e.value)),
    ),
  );

  @override
  String toString() => 'FieldError($field, $code, $message, $params)';
}

/// Lookup helpers over a list of [FieldError]s.
extension FieldErrorList on List<FieldError> {
  /// Every error reported for [field].
  List<FieldError> forField(String field) =>
      where((e) => e.field == field).toList();

  /// The first error reported for [field], or null if none.
  FieldError? firstForField(String field) {
    for (final e in this) {
      if (e.field == field) return e;
    }
    return null;
  }
}

bool _mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (!b.containsKey(entry.key) || b[entry.key] != entry.value) return false;
  }
  return true;
}
