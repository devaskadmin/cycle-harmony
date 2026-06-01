import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cycle_provider.dart';
import '../../widgets/forms/cycle_settings_form.dart';

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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cycle = context.read<CycleProvider>();

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
                        CycleSettingsForm(
                          initialFirstName: cycle.firstName,
                          initialLastPeriodStart: DateTime.now(),
                          initialCycleLength: cycle.defaultCycleLength,
                          initialPeriodLength: cycle.defaultPeriodLength,
                          submitLabel: 'Save and Continue',
                          onSubmitted: ({
                            required firstName,
                            required lastPeriodStart,
                            required cycleLength,
                            required periodLength,
                          }) async {
                            await context
                                .read<CycleProvider>()
                                .saveInitialCycleSetup(
                                  lastPeriodStart: lastPeriodStart,
                                  cycleLength: cycleLength,
                                  periodLength: periodLength,
                                  firstName: firstName,
                                );
                            if (!context.mounted) {
                              return;
                            }
                            widget.onComplete();
                          },
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
    );
  }
}
