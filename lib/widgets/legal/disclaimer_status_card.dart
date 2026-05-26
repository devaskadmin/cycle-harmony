import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/models/disclaimer_state.dart';

class DisclaimerStatusCard extends StatelessWidget {
  const DisclaimerStatusCard({
    required this.state,
    super.key,
  });

  final DisclaimerState state;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Disclaimer Debug',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            _StatusRow(label: 'Accepted', value: state.accepted ? 'Yes' : 'No'),
            _StatusRow(
              label: 'Acceptance Date',
              value: state.acceptedDate == null
                  ? 'Not accepted yet'
                  : DateFormat.yMMMd().add_jm().format(state.acceptedDate!),
            ),
            _StatusRow(
              label: 'Last Shown',
              value: state.lastShown == null
                  ? 'Not shown yet'
                  : DateFormat.yMMMd().add_jm().format(state.lastShown!),
            ),
            _StatusRow(
              label: 'Version',
              value: state.version.isEmpty ? 'None' : state.version,
            ),
            _StatusRow(
              label: 'First Launch Complete',
              value: state.firstLaunchComplete ? 'Yes' : 'No',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 148,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
