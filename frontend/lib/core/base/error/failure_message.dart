import 'package:monai/core/base/error/failure.dart';

/// Human-readable message for any [Failure] variant.
///
/// Every variant shares `message` and `code`, so freezed exposes both directly
/// on [Failure]; `code` is the backend `error.code` for localized text.
extension FailureMessage on Failure {
  /// The display message carried by this failure (English fallback).
  String get displayMessage => message;
}
