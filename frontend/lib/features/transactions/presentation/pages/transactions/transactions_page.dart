import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionsUI();
  }
}

class TransactionsUI extends StatelessWidget {
  const TransactionsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Transactions Page")));
  }
}
