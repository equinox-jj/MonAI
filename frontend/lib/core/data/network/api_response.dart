/// Generic success envelope `{success, message, data}` for a single-object
/// response.
///
/// Decoupled from json_serializable so the generic `T` can be deserialized
/// through a caller-supplied [fromJsonT] converter.
class ApiResponse<T> {
  const ApiResponse({required this.success, this.message, this.data});

  /// Parses [json], decoding the `data` field with [fromJsonT].
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final rawData = json['data'];
    return ApiResponse<T>(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
      data: rawData == null ? null : fromJsonT(rawData),
    );
  }

  /// Whether the server reported success.
  final bool success;

  /// Server message (English fallback text).
  final String? message;

  /// The decoded payload, or null when `data` was null (e.g. deletes).
  final T? data;
}

/// Envelope for an offset-paginated list:
/// `{data: [...], meta: {page, per_page, total, total_pages}}`.
class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.items,
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
  });

  /// Parses [json], decoding each element of `data` with [fromJsonT].
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final rawList = json['data'] as List<dynamic>? ?? <dynamic>[];
    final meta = json['meta'] as Map<String, dynamic>? ?? const {};
    return PaginatedResponse<T>(
      items: rawList.map(fromJsonT).toList(),
      page: meta['page'] as int? ?? 1,
      perPage: meta['per_page'] as int? ?? rawList.length,
      total: meta['total'] as int? ?? rawList.length,
      totalPages: meta['total_pages'] as int? ?? 1,
    );
  }

  /// Decoded page items.
  final List<T> items;

  /// Current 1-based page number.
  final int page;

  /// Items per page.
  final int perPage;

  /// Total items across all pages.
  final int total;

  /// Total number of pages.
  final int totalPages;

  /// True when [page] is not the last page.
  bool get hasNextPage => page < totalPages;
}

/// Envelope for a cursor-paginated list:
/// `{data: [...], meta: {next_cursor, has_more, limit}}`.
class CursorPaginatedResponse<T> {
  const CursorPaginatedResponse({
    required this.items,
    required this.nextCursor,
    required this.hasMore,
    required this.limit,
  });

  /// Parses [json], decoding each element of `data` with [fromJsonT].
  factory CursorPaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final rawList = json['data'] as List<dynamic>? ?? <dynamic>[];
    final meta = json['meta'] as Map<String, dynamic>? ?? const {};
    return CursorPaginatedResponse<T>(
      items: rawList.map(fromJsonT).toList(),
      nextCursor: meta['next_cursor'] as String?,
      hasMore: meta['has_more'] as bool? ?? false,
      limit: meta['limit'] as int? ?? rawList.length,
    );
  }

  /// Decoded items.
  final List<T> items;

  /// Cursor for the next page; null on the last page.
  final String? nextCursor;

  /// Whether more items exist after this page.
  final bool hasMore;

  /// Page size the server applied.
  final int limit;
}
