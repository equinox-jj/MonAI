/// The app language the user picked; [system] follows the device.
enum AppLanguage {
  system(null),
  indonesian('id'),
  english('en');

  const AppLanguage(this.tag);

  /// The language tag, or null for [system].
  final String? tag;
}
