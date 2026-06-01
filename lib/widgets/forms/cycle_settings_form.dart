import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CycleSettingsForm extends StatefulWidget {
  const CycleSettingsForm({
    required this.initialFirstName,
    required this.initialLastPeriodStart,
    required this.initialCycleLength,
    required this.initialPeriodLength,
    required this.submitLabel,
    required this.onSubmitted,
    super.key,
  });

  final String initialFirstName;
  final DateTime initialLastPeriodStart;
  final int initialCycleLength;
  final int initialPeriodLength;
  final String submitLabel;
  final Future<void> Function({
    required String firstName,
    required DateTime lastPeriodStart,
    required int cycleLength,
    required int periodLength,
  }) onSubmitted;

  @override
  State<CycleSettingsForm> createState() => _CycleSettingsFormState();
}

class _CycleSettingsFormState extends State<CycleSettingsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _cycleLengthController;
  late final TextEditingController _periodLengthController;
  late DateTime _lastPeriodStart;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.initialFirstName);
    _lastPeriodStart = widget.initialLastPeriodStart;
    _cycleLengthController = TextEditingController(
      text: widget.initialCycleLength.toString(),
    );
    _periodLengthController = TextEditingController(
      text: widget.initialPeriodLength.toString(),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _cycleLengthController.dispose();
    _periodLengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _firstNameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'First name',
              helperText: 'Used in your dashboard greeting',
            ),
            validator: (value) {
              final trimmed = value?.trim() ?? '';
              if (trimmed.isEmpty) {
                return 'Please enter your first name.';
              }
              if (trimmed.length > 30) {
                return 'Keep it under 30 characters.';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Last period start date',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _isSubmitting ? null : _pickLastPeriodStart,
            child: InputDecorator(
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(DateFormat.yMMMMd().format(_lastPeriodStart)),
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
            validator: (value) => _validateNumber(value, min: 21, max: 40),
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
            validator: (value) => _validateNumber(value, min: 2, max: 10),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Text(widget.submitLabel),
            ),
          ),
        ],
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cycleLength = int.parse(_cycleLengthController.text.trim());
    final periodLength = int.parse(_periodLengthController.text.trim());

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSubmitted(
        firstName: _firstNameController.text.trim(),
        lastPeriodStart: _lastPeriodStart,
        cycleLength: cycleLength,
        periodLength: periodLength,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
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
