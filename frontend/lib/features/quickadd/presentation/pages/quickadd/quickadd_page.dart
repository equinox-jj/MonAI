import 'package:flutter/material.dart';

class QuickaddPage extends StatelessWidget {
  const QuickaddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const QuickaddUI();
  }
}

class QuickaddUI extends StatefulWidget {
  const QuickaddUI({super.key});

  @override
  State<QuickaddUI> createState() => _QuickaddUIState();
}

class _QuickaddUIState extends State<QuickaddUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Quickadd Page")));
  }
}
