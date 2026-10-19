import 'package:flutter/material.dart';

class ReceiptPage extends StatelessWidget {
  const ReceiptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReceiptUI();
  }
}

class ReceiptUI extends StatefulWidget {
  const ReceiptUI({super.key});

  @override
  State<ReceiptUI> createState() => _ReceiptUIState();
}

class _ReceiptUIState extends State<ReceiptUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Receipt Page")));
  }
}
