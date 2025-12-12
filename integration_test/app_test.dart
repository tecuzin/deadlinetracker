import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:deadline_tracker/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Tests', () {
    testWidgets('Complete user journey: Add, view, and delete deadline',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify app starts with empty state
      expect(find.text('No deadlines yet'), findsOneWidget);
      expect(find.text('Deadline Tracker'), findsOneWidget);

      // Navigate to add deadline screen
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify navigation succeeded
      expect(find.text('Add New Deadline'), findsOneWidget);

      // Fill in deadline information
      final titleField =
          find.widgetWithText(TextFormField, 'Enter deadline title');
      final descriptionField =
          find.widgetWithText(TextFormField, 'Enter deadline description');

      await tester.enterText(titleField, 'E2E Test Deadline');
      await tester.pumpAndSettle();

      await tester.enterText(descriptionField, 'Testing the complete flow');
      await tester.pumpAndSettle();

      // Save the deadline
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify deadline appears in list
      expect(find.text('E2E Test Deadline'), findsOneWidget);
      expect(find.text('Testing the complete flow'), findsOneWidget);
      expect(find.byType(DataTable), findsOneWidget);

      // Verify navigation back to home screen
      expect(find.text('Deadline Tracker'), findsOneWidget);

      // Navigate to Statistics tab
      await tester.tap(find.text('Statistics'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify statistics are displayed
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('1'), findsAtLeastNWidgets(1));

      // Navigate back to Deadlines tab
      await tester.tap(find.text('Deadlines'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Delete the deadline
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Verify delete confirmation dialog
      expect(find.text('Delete Deadline'), findsOneWidget);
      expect(find.text('Are you sure you want to delete "E2E Test Deadline"?'),
          findsOneWidget,);

      // Confirm deletion
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify return to empty state
      expect(find.text('No deadlines yet'), findsOneWidget);
      expect(find.text('E2E Test Deadline'), findsNothing);
    });

    testWidgets('Validation prevents saving incomplete deadline',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to add screen
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Try to save without filling form
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle();

      // Verify validation errors
      expect(find.text('Please enter a title'), findsOneWidget);
      expect(find.text('Please enter a description'), findsOneWidget);

      // Still on add screen
      expect(find.text('Add New Deadline'), findsOneWidget);

      // Go back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Should be back on home with no deadlines
      expect(find.text('No deadlines yet'), findsOneWidget);
    });

    testWidgets('Cancel deletion keeps deadline intact', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Add a deadline
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline title'),
        'Keep This Deadline',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline description'),
        'Should not be deleted',
      );
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Try to delete but cancel
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify deadline still exists
      expect(find.text('Keep This Deadline'), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('Multiple deadlines can be managed', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Add multiple deadlines
      for (int i = 1; i <= 3; i++) {
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter deadline title'),
          'Deadline $i',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter deadline description'),
          'Description $i',
        );
        await tester.tap(find.text('Save Deadline'));
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }

      // Verify all deadlines are shown
      expect(find.text('Deadline 1'), findsOneWidget);
      expect(find.text('Deadline 2'), findsOneWidget);
      expect(find.text('Deadline 3'), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsNWidgets(3));

      // Check statistics
      await tester.tap(find.text('Statistics'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('3'), findsAtLeastNWidgets(1)); // Total count

      // Go back to deadlines
      await tester.tap(find.text('Deadlines'));
      await tester.pumpAndSettle();

      // Delete one deadline
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify only 2 delete buttons remain
      expect(find.byIcon(Icons.delete), findsNWidgets(2));
    });

    testWidgets('Date and time pickers can be opened', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Test date picker
      await tester.tap(find.text('Date'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);

      // Close date picker
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Test time picker
      await tester.tap(find.text('Time'));
      await tester.pumpAndSettle();
      expect(find.byType(TimePickerDialog), findsOneWidget);

      // Close time picker
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Back to home
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
    });

    testWidgets('App maintains state during tab switches', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Add a deadline
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline title'),
        'State Test',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline description'),
        'Testing state persistence',
      );
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Switch tabs multiple times
      await tester.tap(find.text('Statistics'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.text('Deadlines'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.text('Statistics'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.text('Deadlines'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify deadline still exists
      expect(find.text('State Test'), findsOneWidget);
    });
  });
}
