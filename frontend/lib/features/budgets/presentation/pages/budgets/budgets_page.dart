import 'package:flutter/material.dart';

class BudgetsPage extends StatelessWidget {
  const BudgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BudgetsUI();
  }
}

class BudgetsUI extends StatefulWidget {
  const BudgetsUI({super.key});

  @override
  State<BudgetsUI> createState() => _BudgetsUIState();
}

class _BudgetsUIState extends State<BudgetsUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Budgets Page")));
  }
}
