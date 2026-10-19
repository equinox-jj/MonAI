import 'package:flutter/material.dart';

class WalletsPage extends StatelessWidget {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WalletsUI();
  }
}

class WalletsUI extends StatefulWidget {
  const WalletsUI({super.key});

  @override
  State<WalletsUI> createState() => _WalletsUIState();
}

class _WalletsUIState extends State<WalletsUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Wallets Page")));
  }
}
