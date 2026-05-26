import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/models/disclaimer_state.dart';
import '../../providers/cycle_provider.dart';
import '../../services/disclaimer_state_service.dart';
import '../../widgets/legal/disclaimer_status_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.onViewDisclaimer,
    required this.onResetDisclaimer,
    super.key,
  });

  final Future<void> Function() onViewDisclaimer;
  final Future<void> Function() onResetDisclaimer;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final DisclaimerStateService _disclaimerStateService =
      DisclaimerStateService();
  DisclaimerState? _disclaimerState;

  @override
  void initState() {
    super.initState();
    _loadDisclaimerState();
  }

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
                          const ListTile(
                            title: Text('Legal & Safety'),
                            subtitle: Text(
                                'Educational use, consent, version, and debug details'),
                            leading: Icon(Icons.gavel),
                          ),
                          ListTile(
                            title: const Text('View Disclaimer'),
                            subtitle: const Text(
                                'Manually reopen the disclaimer modal'),
                            leading: const Icon(Icons.shield_outlined),
                            onTap: _handleViewDisclaimer,
                          ),
                          ListTile(
                            title: const Text('Reset Disclaimer'),
                            subtitle: const Text(
                                'Require the disclaimer again on next launch'),
                            leading: const Icon(Icons.restart_alt),
                            onTap: () => _handleResetDisclaimer(context),
                          ),
                          ListTile(
                            title: const Text('Show Acceptance Status'),
                            subtitle: Text(_disclaimerState?.accepted == true
                                ? 'Accepted'
                                : 'Pending'),
                            leading: const Icon(Icons.verified_user_outlined),
                          ),
                          ListTile(
                            title: const Text('Show Acceptance Date'),
                            subtitle: Text(
                              _disclaimerState?.acceptedDate == null
                                  ? 'Not accepted yet'
                                  : DateFormat.yMMMd()
                                      .add_jm()
                                      .format(_disclaimerState!.acceptedDate!),
                            ),
                            leading: const Icon(Icons.event_available_outlined),
                          ),
                          ListTile(
                            title: const Text('Show Disclaimer Version'),
                            subtitle: Text(
                              _disclaimerState?.version.isNotEmpty == true
                                  ? _disclaimerState!.version
                                  : AppConstants.disclaimerVersion,
                            ),
                            leading: const Icon(Icons.new_releases_outlined),
                          ),
                          const ListTile(
                            title: Text('App Version'),
                            subtitle: Text(AppConstants.appVersion),
                            leading: Icon(Icons.info_outline),
                          ),
                          const ListTile(
                            title: Text('Educational Use Notice'),
                            subtitle: Text(AppConstants.educationalUseNotice),
                            leading: Icon(Icons.menu_book_outlined),
                          ),
                        ],
                      ),
                    ),
                    if (_disclaimerState != null) ...[
                      const SizedBox(height: 12),
                      DisclaimerStatusCard(state: _disclaimerState!),
                    ],
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

  Future<void> _loadDisclaimerState() async {
    final state = await _disclaimerStateService.readState(
      currentVersion: AppConstants.disclaimerVersion,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _disclaimerState = state;
    });
  }

  Future<void> _handleViewDisclaimer() async {
    await widget.onViewDisclaimer();
    await _loadDisclaimerState();
  }

  Future<void> _handleResetDisclaimer(BuildContext context) async {
    await widget.onResetDisclaimer();
    await _loadDisclaimerState();
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Disclaimer reset. It will be required on next launch.'),
      ),
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
