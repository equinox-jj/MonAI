// The one place auth input is cleaned up. Use cases apply it once, then
// validate and send the same values. The backend does the same, so an email
// matches however it was typed. Passwords stay as typed: spaces may be part
// of them.

/// Auth input cleanup applied by the use cases.
extension AuthInput on String {
  /// The name without surrounding spaces.
  String get normalizedName => trim();

  /// The email without surrounding spaces, lowercased.
  String get normalizedEmail => trim().toLowerCase();
}
