import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReportsUI();
  }
}

class ReportsUI extends StatefulWidget {
  const ReportsUI({super.key});

  @override
  State<ReportsUI> createState() => _ReportsUIState();
}

class _ReportsUIState extends State<ReportsUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Reports Page")));
  }
}
