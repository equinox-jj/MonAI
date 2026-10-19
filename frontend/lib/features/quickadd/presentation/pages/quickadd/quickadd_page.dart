import 'package:flutter/material.dart';

class QuickaddPage extends StatelessWidget {
  const QuickaddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const QuickaddUI();
  }
}

class QuickaddUI extends StatelessWidget {
  const QuickaddUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Quickadd Page")));
  }
}
