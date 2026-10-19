import 'package:flutter/material.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExportUI();
  }
}

class ExportUI extends StatefulWidget {
  const ExportUI({super.key});

  @override
  State<ExportUI> createState() => _ExportUIState();
}

class _ExportUIState extends State<ExportUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Export Page")));
  }
}
