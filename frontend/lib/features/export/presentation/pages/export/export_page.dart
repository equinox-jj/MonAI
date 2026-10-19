import 'package:flutter/material.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExportUI();
  }
}

class ExportUI extends StatelessWidget {
  const ExportUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Export Page")));
  }
}
