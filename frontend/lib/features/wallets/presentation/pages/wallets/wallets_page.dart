import 'package:flutter/material.dart';

class WalletsPage extends StatelessWidget {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WalletsUI();
  }
}

class WalletsUI extends StatelessWidget {
  const WalletsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Wallets Page")));
  }
}
