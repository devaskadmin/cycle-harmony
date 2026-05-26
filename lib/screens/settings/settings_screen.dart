import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../providers/cycle_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CycleProvider>(
      builder: (context, cycle, _) {
        return CustomScrollView(
          slivers: [
            const SliverAppBar(
              pinned: true,
              expandedHeight: 100,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                title: Text('Settings', style: TextStyle(color: Colors.white)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          SwitchListTile(
                            value: cycle.isDarkMode,
                            title: const Text('Theme toggle'),
                            subtitle: const Text('Enable dark theme'),
                            onChanged: (value) => cycle.setDarkMode(value),
                          ),
                          ListTile(
                            title: const Text('Cycle length default'),
                            subtitle: Text('${cycle.defaultCycleLength} days'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _editIntSetting(
                              context,
                              title: 'Cycle length',
                              current: cycle.defaultCycleLength,
                              min: 21,
                              max: 40,
                              onSave: (value) =>
                                  cycle.updateDefaults(cycleLength: value),
                            ),
                          ),
                          ListTile(
                            title: const Text('Period length default'),
                            subtitle: Text('${cycle.defaultPeriodLength} days'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _editIntSetting(
                              context,
                              title: 'Period length',
                              current: cycle.defaultPeriodLength,
                              min: 2,
                              max: 10,
                              onSave: (value) =>
                                  cycle.updateDefaults(periodLength: value),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text('Export (placeholder)'),
                            subtitle:
                                const Text('Local export planned in v0.02'),
                            leading: const Icon(Icons.ios_share),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Export is a placeholder in v0.01.')),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text('Future AI (placeholder)'),
                            subtitle: const Text('No AI calls in v0.01'),
                            leading: const Icon(Icons.auto_awesome),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'AI features are disabled in v0.01.')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppConstants.appVersion,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editIntSetting(
    BuildContext context, {
    required String title,
    required int current,
    required int min,
    required int max,
    required ValueChanged<int> onSave,
  }) async {
    final controller = TextEditingController(text: current.toString());

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: '$min - $max'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final value = int.tryParse(controller.text.trim());
                if (value != null && value >= min && value <= max) {
                  onSave(value);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
