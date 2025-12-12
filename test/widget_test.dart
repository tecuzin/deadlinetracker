// This is a basic test file that comes with Flutter projects.
// It serves as a simple smoke test to ensure the test environment is working.

import 'package:flutter_test/flutter_test.dart';
import 'package:deadline_tracker/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app renders without crashing.
    expect(find.text('Deadline Tracker'), findsOneWidget);
  });
}
