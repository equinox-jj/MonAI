enum UiStatus {
  initial,
  empty,
  success,
  failure,
  loading;

  /// `success` counts as submitting: the screen leaves right after it, so the
  /// form must not become submittable again in between.
  bool get isSubmitting => this == loading || this == success;
}
