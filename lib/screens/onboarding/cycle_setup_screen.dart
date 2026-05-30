import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/cycle_provider.dart';

class CycleSetupScreen extends StatefulWidget {
  const CycleSetupScreen({
    required this.onComplete,
    super.key,
  });

  final VoidCallback onComplete;

  @override
  State<CycleSetupScreen> createState() => _CycleSetupScreenState();
}

class _CycleSetupScreenState extends State<CycleSetupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _cycleLengthController;
  late final TextEditingController _periodLengthController;

  late DateTime _lastPeriodStart;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final cycle = context.read<CycleProvider>();
    _lastPeriodStart = DateTime.now();
    _cycleLengthController = TextEditingController(
      text: cycle.defaultCycleLength.toString(),
    );
    _periodLengthController = TextEditingController(
      text: cycle.defaultPeriodLength.toString(),
    );
  }

  @override
  void dispose() {
    _cycleLengthController.dispose();
    _periodLengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Set up your cycle',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Before you reach the dashboard, enter the date your last period started and your usual cycle defaults.',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Last period start date',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: _isSaving ? null : _pickLastPeriodStart,
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              child: Text(
                                DateFormat.yMMMMd().format(_lastPeriodStart),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _cycleLengthController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Average cycle length',
                              helperText: 'Default: 28 days',
                            ),
                            validator: (value) =>
                                _validateNumber(value, min: 21, max: 40),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _periodLengthController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: 'Period length',
                              helperText: 'Default: 5 days',
                            ),
                            validator: (value) =>
                                _validateNumber(value, min: 2, max: 10),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _isSaving ? null : _saveSetup,
                              child: _isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Save and Continue'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickLastPeriodStart() async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _lastPeriodStart,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _lastPeriodStart = selectedDate;
    });
  }

  Future<void> _saveSetup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cycleLength = int.parse(_cycleLengthController.text.trim());
    final periodLength = int.parse(_periodLengthController.text.trim());

    setState(() {
      _isSaving = true;
    });

    try {
      await context.read<CycleProvider>().saveInitialCycleSetup(
            lastPeriodStart: _lastPeriodStart,
            cycleLength: cycleLength,
            periodLength: periodLength,
          );
      if (!mounted) {
        return;
      }
      widget.onComplete();
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String? _validateNumber(String? value, {required int min, required int max}) {
    final parsedValue = int.tryParse(value?.trim() ?? '');
    if (parsedValue == null) {
      return 'Enter a number.';
    }
    if (parsedValue < min || parsedValue > max) {
      return 'Enter a value from $min to $max.';
    }
    return null;
  }
}