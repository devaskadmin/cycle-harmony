import 'package:flutter/material.dart';

class FertilityScreen extends StatelessWidget {
  const FertilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fertility Plan')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Fertility planning details are planned for v0.02.\n'
            'Core fertility predictions are active in Tracker and Calendar.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
