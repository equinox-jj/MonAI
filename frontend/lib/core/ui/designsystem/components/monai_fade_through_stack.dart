import 'package:flutter/material.dart';

/// An [IndexedStack] that fades and scales the newly selected child in.
/// Every child stays mounted, so each keeps its state while hidden.
class MonAIFadeThroughStack extends StatefulWidget {
  const MonAIFadeThroughStack({
    required this.index,
    required this.children,
    super.key,
  });

  final int index;
  final List<Widget> children;

  @override
  State<MonAIFadeThroughStack> createState() => _MonAIFadeThroughStackState();
}

class _MonAIFadeThroughStackState extends State<MonAIFadeThroughStack>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
    value: 1,
  );
  late final _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  late final _scale = Tween<double>(begin: 0.96, end: 1).animate(_curve);

  @override
  void didUpdateWidget(MonAIFadeThroughStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index == oldWidget.index) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _curve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curve,
      child: ScaleTransition(
        scale: _scale,
        child: IndexedStack(index: widget.index, children: widget.children),
      ),
    );
  }
}
