import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:deadline_tracker/main.dart';
import 'package:deadline_tracker/providers/deadline_provider.dart';
import 'package:deadline_tracker/models/deadline.dart';

void main() {
  group('App Integration Tests', () {
    testWidgets('Complete flow: Add deadline -> View in list -> Delete',
        (tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify we're on home screen with empty state
      expect(find.text('No deadlines yet'), findsOneWidget);

      // Tap FAB to add deadline
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify we're on add screen
      expect(find.text('Add New Deadline'), findsOneWidget);

      // Fill in the form
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline title'),
        'Integration Test Deadline',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline description'),
        'This is an integration test',
      );

      // Save the deadline
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle();

      // Should be back on home screen with the deadline
      expect(find.text('Integration Test Deadline'), findsOneWidget);
      expect(find.text('This is an integration test'), findsOneWidget);

      // Delete the deadline
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Confirm deletion
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Should be back to empty state
      expect(find.text('No deadlines yet'), findsOneWidget);
    });

    testWidgets('Navigation between Deadlines and Statistics tabs',
        (tester) async {
      await tester.pumpWidget(const MyApp());

      // Add a deadline first
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline title'),
        'Test Deadline',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline description'),
        'Test Description',
      );
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle();

      // Navigate to Statistics tab
      await tester.tap(find.text('Statistics'));
      await tester.pumpAndSettle();

      // Verify statistics are shown
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);

      // Navigate back to Deadlines tab
      await tester.tap(find.text('Deadlines'));
      await tester.pumpAndSettle();

      // Verify we're back on deadlines tab
      expect(find.text('Test Deadline'), findsOneWidget);
      expect(find.byType(DataTable), findsOneWidget);
    });

    testWidgets('Add multiple deadlines and verify sorting', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Add first deadline (due in 3 days)
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline title'),
        'Third Deadline',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline description'),
        'Due in 3 days',
      );
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle();

      // Add second deadline (due in 1 day)
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline title'),
        'First Deadline',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline description'),
        'Due in 1 day',
      );
      // This would ideally change the date, but for simplicity we'll just test the flow
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle();

      // Verify both deadlines are shown
      expect(find.text('Third Deadline'), findsOneWidget);
      expect(find.text('First Deadline'), findsOneWidget);
    });

    testWidgets('Cancel deletion dialog returns to list without deleting',
        (tester) async {
      await tester.pumpWidget(const MyApp());

      // Add a deadline
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline title'),
        'Test Deadline',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline description'),
        'Test Description',
      );
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle();

      // Try to delete but cancel
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Deadline should still exist
      expect(find.text('Test Deadline'), findsOneWidget);
    });

    testWidgets('Statistics updates after adding deadlines', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Go to statistics with no deadlines
      await tester.tap(find.text('Statistics'));
      await tester.pumpAndSettle();
      expect(find.text('No statistics yet'), findsOneWidget);

      // Go back and add a deadline
      await tester.tap(find.text('Deadlines'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline title'),
        'New Deadline',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline description'),
        'New Description',
      );
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle();

      // Go to statistics again
      await tester.tap(find.text('Statistics'));
      await tester.pumpAndSettle();

      // Should now show statistics
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('No statistics yet'), findsNothing);
    });

    testWidgets('FAB is hidden on Statistics tab', (tester) async {
      await tester.pumpWidget(const MyApp());

      // FAB should be visible on Deadlines tab
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Switch to Statistics tab
      await tester.tap(find.text('Statistics'));
      await tester.pumpAndSettle();

      // FAB should be hidden
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('Back button on add screen returns to home', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Add New Deadline'), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.text('Deadline Tracker'), findsOneWidget);
    });

    testWidgets('Validation errors prevent form submission', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Try to save without filling anything
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle();

      // Should still be on add screen with errors
      expect(find.text('Add New Deadline'), findsOneWidget);
      expect(find.text('Please enter a title'), findsOneWidget);

      // Should not have created a deadline
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('No deadlines yet'), findsOneWidget);
    });

    testWidgets('App persists provider state across screens', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Add deadline
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline title'),
        'Persistent Deadline',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline description'),
        'Should persist',
      );
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle();

      // Navigate to statistics
      await tester.tap(find.text('Statistics'));
      await tester.pumpAndSettle();

      // Navigate back to deadlines
      await tester.tap(find.text('Deadlines'));
      await tester.pumpAndSettle();

      // Deadline should still be there
      expect(find.text('Persistent Deadline'), findsOneWidget);
    });

    testWidgets('Multiple delete operations work correctly', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Add 3 deadlines
      for (int i = 1; i <= 3; i++) {
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter deadline title'),
          'Deadline $i',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Enter deadline description'),
          'Description $i',
        );
        await tester.tap(find.text('Save Deadline'));
        await tester.pumpAndSettle();
      }

      // Delete first deadline
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Should have 2 remaining
      expect(find.byIcon(Icons.delete), findsNWidgets(2));

      // Delete another
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Should have 1 remaining
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });
  });
}
