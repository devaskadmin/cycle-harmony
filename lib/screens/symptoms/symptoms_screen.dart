import 'package:flutter/material.dart';

class SymptomsScreen extends StatelessWidget {
  const SymptomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood & Symptoms')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Symptom logging UI will be expanded in v0.02.\n'
            'Mood and symptom model/state are already scaffolded for local storage.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
