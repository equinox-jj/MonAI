import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignInUI();
  }
}

class SignInUI extends StatelessWidget {
  const SignInUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Sign In Page')));
  }
}
