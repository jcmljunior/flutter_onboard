import 'package:flutter/material.dart';

class TestePage extends StatelessWidget {
  const TestePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste'),
      ),
      body: const Center(
        child: Text('Teste'),
      ),
    );
  }
}
