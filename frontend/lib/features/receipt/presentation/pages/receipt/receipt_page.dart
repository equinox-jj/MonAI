import 'package:flutter/material.dart';

class ReceiptPage extends StatelessWidget {
  const ReceiptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReceiptUI();
  }
}

class ReceiptUI extends StatelessWidget {
  const ReceiptUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Receipt Page")));
  }
}
