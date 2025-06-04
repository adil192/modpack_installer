import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('adil192\'s modpack installer')),
      body: Center(
        child: Text(
          'Welcome to adil192\'s modpack installer!',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
