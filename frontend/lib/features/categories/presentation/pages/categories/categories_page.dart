import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoriesUI();
  }
}

class CategoriesUI extends StatefulWidget {
  const CategoriesUI({super.key});

  @override
  State<CategoriesUI> createState() => _CategoriesUIState();
}

class _CategoriesUIState extends State<CategoriesUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Categories Page")));
  }
}
