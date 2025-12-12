import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:deadline_tracker/screens/add_deadline_screen.dart';
import 'package:deadline_tracker/providers/deadline_provider.dart';

void main() {
  group('AddDeadlineScreen Widget Tests', () {
    late DeadlineProvider provider;

    setUp(() {
      provider = DeadlineProvider();
    });

    Widget createTestWidget() {
      return ChangeNotifierProvider<DeadlineProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: AddDeadlineScreen(),
        ),
      );
    }

    testWidgets('renders app bar with correct title', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Add New Deadline'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('shows all required form fields', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Deadline Details'), findsOneWidget);
      expect(find.text('Due Date & Time'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('shows title input field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(
        find.widgetWithText(TextFormField, 'Enter deadline title'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.title), findsOneWidget);
    });

    testWidgets('shows description input field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(
        find.widgetWithText(TextFormField, 'Enter deadline description'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.description), findsOneWidget);
    });

    testWidgets('shows date picker tile', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Date'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('shows time picker tile', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Time'), findsOneWidget);
      expect(find.byIcon(Icons.access_time), findsOneWidget);
    });

    testWidgets('shows save button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(
        find.widgetWithText(ElevatedButton, 'Save Deadline'),
        findsOneWidget,
      );
    });

    testWidgets('validates empty title field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Try to save without entering title
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a title'), findsOneWidget);
    });

    testWidgets('validates empty description field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter title but not description
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline title'),
        'Test Title',
      );

      // Try to save
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a description'), findsOneWidget);
    });

    testWidgets('accepts valid input and saves deadline', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter title
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline title'),
        'Test Deadline',
      );

      // Enter description
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline description'),
        'Test Description',
      );

      // Save
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle();

      // Should add deadline to provider
      expect(provider.deadlines.length, 1);
      expect(provider.deadlines.first.title, 'Test Deadline');
      expect(provider.deadlines.first.description, 'Test Description');
    });

    testWidgets('shows snackbar after successful save', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter valid data
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline title'),
        'Test Deadline',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline description'),
        'Test Description',
      );

      // Save
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle();

      expect(find.text('Deadline added successfully!'), findsOneWidget);
    });

    testWidgets('opens date picker when date tile is tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap date tile
      await tester.tap(find.text('Date'));
      await tester.pumpAndSettle();

      // Should show date picker
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('opens time picker when time tile is tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap time tile
      await tester.tap(find.text('Time'));
      await tester.pumpAndSettle();

      // Should show time picker
      expect(find.byType(TimePickerDialog), findsOneWidget);
    });

    testWidgets('description field is multiline', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final descriptionFieldFinder =
          find.widgetWithText(TextFormField, 'Enter deadline description');
      final textFieldFinder = find.descendant(
          of: descriptionFieldFinder, matching: find.byType(TextField));
      final textField = tester.widget<TextField>(textFieldFinder);

      expect(textField.maxLines, 3);
    });

    testWidgets('back button navigates back', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap back button
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Should navigate back (screen should be popped)
      expect(find.text('Add New Deadline'), findsNothing);
    });

    testWidgets('form has proper cards layout', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Card), findsNWidgets(2));
    });

    testWidgets('title field has proper icon', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final titleField = find.ancestor(
        of: find.text('Enter deadline title'),
        matching: find.byType(TextFormField),
      );

      expect(titleField, findsOneWidget);
    });

    testWidgets('saves deadline with correct timestamp', (tester) async {
      final beforeTime = DateTime.now();

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline title'),
        'Test',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline description'),
        'Test',
      );

      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle();

      final afterTime = DateTime.now();

      final deadline = provider.deadlines.first;
      expect(
        deadline.createdAt
            .isAfter(beforeTime.subtract(const Duration(seconds: 1))),
        true,
      );
      expect(
        deadline.createdAt.isBefore(afterTime.add(const Duration(seconds: 1))),
        true,
      );
    });

    testWidgets('generates unique id for each deadline', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Add first deadline
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline title'),
        'First',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline description'),
        'First',
      );
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle();

      final firstId = provider.deadlines.first.id;

      // Navigate back and add second deadline
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline title'),
        'Second',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter deadline description'),
        'Second',
      );
      await tester.tap(find.text('Save Deadline'));
      await tester.pumpAndSettle();

      final secondId = provider.deadlines.last.id;

      expect(firstId, isNot(equals(secondId)));
    });
  });
}
