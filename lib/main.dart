import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'providers/cycle_provider.dart';
import 'providers/mood_provider.dart';
import 'providers/reminder_provider.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/legal/disclaimer_modal.dart';
import 'screens/reminders/reminders_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/tracker/tracker_screen.dart';
import 'services/disclaimer_service.dart';
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
  final DisclaimerService _disclaimerService = DisclaimerService();
  bool? _disclaimerAccepted;
  bool _consentChecked = false;

  @override
  void initState() {
    super.initState();
    _loadDisclaimerStatus();
  }

  @override
  Widget build(BuildContext context) {
    final cycleLoaded = context.watch<CycleProvider>().isLoaded;
    final reminderLoaded = context.watch<ReminderProvider>().isLoaded;
    final moodLoaded = context.watch<MoodProvider>().isLoaded;

    if (!cycleLoaded || !reminderLoaded || !moodLoaded || _disclaimerAccepted == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pages = <Widget>[
      DashboardScreen(onSelectBottomTab: _onBottomTabSelected),
      const TrackerScreen(),
      const CalendarScreen(),
      const RemindersScreen(),
      const SettingsScreen(),
    ];

    final showDisclaimer = _disclaimerAccepted == false;

    return PopScope(
      canPop: !showDisclaimer,
      child: Stack(
        children: [
          Scaffold(
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
          ),
          if (showDisclaimer)
            Positioned.fill(
              child: DisclaimerModal(
                mandatory: true,
                requireConsent: true,
                checkboxValue: _consentChecked,
                onCheckboxChanged: (value) {
                  setState(() {
                    _consentChecked = value;
                  });
                },
                primaryLabel: 'I Understand and Continue',
                onPrimaryPressed: _consentChecked ? _acceptDisclaimer : () {},
              ),
            ),
        ],
      ),
    );
  }

  void _onBottomTabSelected(int index) {
    setState(() {
      _index = index;
    });
  }

  Future<void> _loadDisclaimerStatus() async {
    final accepted = await _disclaimerService.isAccepted();
    if (!mounted) {
      return;
    }
    setState(() {
      _disclaimerAccepted = accepted;
      _consentChecked = accepted;
    });
  }

  Future<void> _acceptDisclaimer() async {
    await _disclaimerService.accept();
    if (!mounted) {
      return;
    }
    setState(() {
      _disclaimerAccepted = true;
      _consentChecked = true;
    });
  }
}
