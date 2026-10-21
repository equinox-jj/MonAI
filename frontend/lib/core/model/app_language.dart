enum AppLanguage {
  system(null),
  indonesian('id'),
  english('en');

  const AppLanguage(this.tag);
  final String? tag;
}
