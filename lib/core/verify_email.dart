import 'package:flutter/material.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {

  return Scaffold(
    body: Center(
    child: AlertDialog(
      title: const Text('Email Verification Required'),
      content: const Text('Please verify your email to ensure your account is saved.'),
      actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('OK'),
      ),
      ],
    ),
    ),
  );
  }
}