/// One `error.fields[]` entry of a 422 response. [code] and [params] (e.g.
/// `min`, `{"min": 8}`) drive the localized text; [message] is the English
/// fallback.
class FieldError {
  const FieldError({
    required this.field,
    required this.code,
    required this.message,
    this.params = const {},
  });

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

  final String field;
  final String code;
  final String message;
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

extension FieldErrorList on List<FieldError> {
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
