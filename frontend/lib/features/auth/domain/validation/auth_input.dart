// The one place auth input is cleaned up. Use cases apply it once, then
// validate and send the same values. The backend does the same, so an email
// matches however it was typed. Passwords stay as typed: spaces may be part
// of them.

extension AuthInput on String {
  String get normalizedName => trim();

  String get normalizedEmail => trim().toLowerCase();
}
