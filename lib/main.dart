import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/models/disclaimer_state.dart';
import 'core/theme/app_theme.dart';
import 'providers/cycle_provider.dart';
import 'providers/mood_provider.dart';
import 'providers/reminder_provider.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/legal/disclaimer_modal.dart';
import 'screens/onboarding/cycle_setup_screen.dart';
import 'screens/reminders/reminders_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/tracker/tracker_screen.dart';
import 'services/disclaimer_state_service.dart';
import 'services/local_storage_service.dart';

void main() {
  runApp(const CycleAIApp());
}

class CycleAIApp extends StatelessWidget {
  const CycleAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CycleProvider>(
          create: (_) => CycleProvider(LocalStorageService())..init(),
        ),
        ChangeNotifierProvider<ReminderProvider>(
          create: (_) => ReminderProvider(LocalStorageService())..init(),
        ),
        ChangeNotifierProvider<MoodProvider>(
          create: (_) => MoodProvider(LocalStorageService())..init(),
        ),
      ],
      child: Consumer<CycleProvider>(
        builder: (context, cycle, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: cycle.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomeShell(),
          );
        },
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  final DisclaimerStateService _disclaimerStateService =
      DisclaimerStateService();
  DisclaimerState? _disclaimerState;
  bool _startupReady = false;
  bool _disclaimerDialogVisible = false;
  bool _consentChecked = false;

  @override
  void initState() {
    super.initState();
    _initializeStartup();
  }

  @override
  Widget build(BuildContext context) {
    final cycle = context.watch<CycleProvider>();
    final cycleLoaded = cycle.isLoaded;
    final reminderLoaded = context.watch<ReminderProvider>().isLoaded;
    final moodLoaded = context.watch<MoodProvider>().isLoaded;

    if (!cycleLoaded ||
        !reminderLoaded ||
        !moodLoaded ||
        !_startupReady ||
        _disclaimerState == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_requiresCycleSetup(cycle)) {
      return CycleSetupScreen(onComplete: _handleCycleSetupComplete);
    }

    final pages = <Widget>[
      DashboardScreen(onSelectBottomTab: _onBottomTabSelected),
      const TrackerScreen(),
      const CalendarScreen(),
      const RemindersScreen(),
      SettingsScreen(
        onViewDisclaimer: _openDisclaimerFromSettings,
        onResetDisclaimer: _resetDisclaimer,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _onBottomTabSelected,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.grid_view), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.water_drop), label: 'Tracker'),
          NavigationDestination(
              icon: Icon(Icons.calendar_month), label: 'Calendar'),
          NavigationDestination(
              icon: Icon(Icons.notifications), label: 'Reminders'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  void _onBottomTabSelected(int index) {
    setState(() {
      _index = index;
    });
  }

  Future<void> _initializeStartup() async {
    final state = await _disclaimerStateService.readState(
      currentVersion: AppConstants.disclaimerVersion,
    );
    if (!mounted) {
      return;
    }

    setState(() {
      _disclaimerState = state;
      _startupReady = true;
      _consentChecked = state.accepted;
    });

    if (state.needsDisplay(AppConstants.disclaimerVersion)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showMandatoryDisclaimer();
      });
    }
  }

  bool _requiresCycleSetup(CycleProvider cycle) {
    return _disclaimerState?.accepted == true && !cycle.hasCycleSetup;
  }

  Future<void> _showMandatoryDisclaimer() async {
    if (!mounted || _disclaimerDialogVisible) {
      return;
    }

    _disclaimerDialogVisible = true;
    _consentChecked = false;
    await _disclaimerStateService.markShown(
      currentVersion: AppConstants.disclaimerVersion,
    );

    if (!mounted) {
      return;
    }

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Mandatory disclaimer',
      barrierColor: Colors.transparent,
      pageBuilder: (context, _, __) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return PopScope(
              canPop: false,
              child: DisclaimerModal(
                mandatory: true,
                requireConsent: true,
                checkboxValue: _consentChecked,
                onCheckboxChanged: (value) {
                  setModalState(() {
                    _consentChecked = value;
                  });
                },
                primaryLabel: 'I Understand and Continue',
                onPrimaryPressed: _consentChecked
                    ? () async {
                        await _acceptDisclaimer();
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.of(context).pop();
                      }
                    : () {},
              ),
            );
          },
        );
      },
    );

    _disclaimerDialogVisible = false;
    await _refreshDisclaimerState();
  }

  Future<void> _openDisclaimerFromSettings() async {
    await _disclaimerStateService.markShown(
      currentVersion: AppConstants.disclaimerVersion,
    );

    if (!mounted) {
      return;
    }

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Disclaimer',
      barrierColor: Colors.transparent,
      pageBuilder: (context, _, __) {
        return DisclaimerModal(
          mandatory: false,
          requireConsent: false,
          checkboxValue: true,
          onCheckboxChanged: (_) {},
          primaryLabel: 'Close',
          onPrimaryPressed: () => Navigator.of(context).pop(),
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );

    await _refreshDisclaimerState();
  }

  Future<void> _refreshDisclaimerState() async {
    final state = await _disclaimerStateService.readState(
      currentVersion: AppConstants.disclaimerVersion,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _disclaimerState = state;
      _consentChecked = state.accepted;
    });
  }

  Future<void> _acceptDisclaimer() async {
    final state = await _disclaimerStateService.accept(
      currentVersion: AppConstants.disclaimerVersion,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _disclaimerState = state;
      _consentChecked = true;
    });
  }

  Future<void> _resetDisclaimer() async {
    final state = await _disclaimerStateService.reset(
      currentVersion: AppConstants.disclaimerVersion,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _disclaimerState = state;
      _consentChecked = false;
    });
  }

  void _handleCycleSetupComplete() {
    if (!mounted) {
      return;
    }

    setState(() {
      _index = 0;
    });
  }
}
