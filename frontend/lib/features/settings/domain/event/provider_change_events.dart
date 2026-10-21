import 'dart:async';

/// The id of each provider created, edited, (de)activated or deleted, so the
/// admin list reloads after the form closes. Emitted by the write use cases
/// after the change succeeds. Registered once, for the whole app; nothing is
/// replayed.
class ProviderChangeEvents {
  final _controller = StreamController<String>.broadcast();

  /// Each changed provider's id.
  Stream<String> get stream => _controller.stream;

  /// Announces that provider [providerId] changed.
  void emit(String providerId) => _controller.add(providerId);

  Future<void> dispose() => _controller.close();
}
