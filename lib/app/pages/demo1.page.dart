import 'package:flutter/material.dart';

import '../../features/animated_button/widgets/animated_button.widget.dart';

@immutable
class Demo1Page extends StatelessWidget {
  const Demo1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: AnimatedButtonWidget(
        buttons: [
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.menu),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Option 1'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Option 2'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Option 3'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Experimental Page'),
            const SizedBox(
              height: 24.0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
