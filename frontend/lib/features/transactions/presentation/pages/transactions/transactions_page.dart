import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionsUI();
  }
}

class TransactionsUI extends StatefulWidget {
  const TransactionsUI({super.key});

  @override
  State<TransactionsUI> createState() => _TransactionsUIState();
}

class _TransactionsUIState extends State<TransactionsUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Transactions Page")));
  }
}
