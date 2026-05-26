import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../widgets/legal/disclaimer_checkbox.dart';
import '../../widgets/legal/disclaimer_footer.dart';

class DisclaimerModal extends StatelessWidget {
  const DisclaimerModal({
    required this.mandatory,
    required this.requireConsent,
    required this.checkboxValue,
    required this.onCheckboxChanged,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.onClose,
    super.key,
  });

  final bool mandatory;
  final bool requireConsent;
  final bool checkboxValue;
  final ValueChanged<bool> onCheckboxChanged;
  final String primaryLabel;
  final VoidCallback onPrimaryPressed;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Material(
      color: Colors.black.withValues(alpha: 0.54),
      child: SafeArea(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: 1,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            tween: Tween<double>(begin: 36, end: 0),
            builder: (context, offset, child) {
              return Transform.translate(
                offset: Offset(0, offset),
                child: child,
              );
            },
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FractionallySizedBox(
                    heightFactor: 0.96,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 28,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF7B3FCF), Color(0xFFE74C8C)],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.health_and_safety,
                                          color: Colors.white,
                                          size: 34,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Important Information',
                                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Educational use only',
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!mandatory && onClose != null)
                                        IconButton(
                                          onPressed: onClose,
                                          icon: const Icon(Icons.close),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Cycle Harmony is designed to provide general educational information about the menstrual cycle, cycle phases, fertility awareness, symptoms, wellness, and nutrition concepts.\n\n'
                                    'This application does NOT provide medical advice and is NOT a substitute for professional healthcare.\n\n'
                                    'Cycle Harmony does not diagnose, treat, cure, prevent, or monitor medical conditions.\n\n'
                                    'Always consult licensed healthcare professionals regarding symptoms, medications, pregnancy concerns, fertility questions, or medical treatment.\n\n'
                                    'Predictions, cycle calculations, reminders, and future AI features are informational estimates only.\n\n'
                                    'By continuing you acknowledge that:\n\n'
                                    '• You understand this is educational software\n'
                                    '• You accept responsibility for medical decisions\n'
                                    '• You agree not to rely solely on app information\n'
                                    '• You understand predictions may be inaccurate',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
                                  ),
                                  if (requireConsent) ...[
                                    const SizedBox(height: 24),
                                    DisclaimerCheckbox(
                                      value: checkboxValue,
                                      onChanged: onCheckboxChanged,
                                    ),
                                  ],
                                  const SizedBox(height: 16),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                          .withValues(alpha: 0.55),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      AppConstants.educationalUseNotice,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DisclaimerFooter(
                            enabled: requireConsent ? checkboxValue : true,
                            label: primaryLabel,
                            onPressed: onPrimaryPressed,
                          ),
                          SizedBox(height: bottomPadding > 0 ? bottomPadding : 8),
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
}
