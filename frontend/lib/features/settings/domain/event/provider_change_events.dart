import 'dart:async';

/// Lets the admin list reload after the form closes. Emitted by the write use
/// cases after a change succeeds; registered once for the whole app, and
/// nothing is replayed.
class ProviderChangeEvents {
  final _controller = StreamController<String>.broadcast();

  Stream<String> get stream => _controller.stream;

  void emit(String providerId) => _controller.add(providerId);

  Future<void> dispose() => _controller.close();
}
