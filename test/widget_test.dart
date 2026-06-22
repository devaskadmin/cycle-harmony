import 'package:cycle_harmony/main.dart';
import 'package:cycle_harmony/services/disclaimer_state_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      DisclaimerStateService.disclaimerAcceptedKey: true,
      DisclaimerStateService.appFirstLaunchKey: true,
      DisclaimerStateService.disclaimerVersionKey: '0.01.1b',
    });
  });

  testWidgets('boots into the cycle setup flow', (tester) async {
    await tester.pumpWidget(const CycleAIApp());
    await tester.pumpAndSettle();

    expect(find.text('Set up your cycle'), findsOneWidget);
    expect(find.text('Save and Continue'), findsOneWidget);
  });
}
