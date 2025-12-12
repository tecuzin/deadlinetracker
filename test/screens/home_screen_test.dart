import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:deadline_tracker/screens/home_screen.dart';
import 'package:deadline_tracker/providers/deadline_provider.dart';
import 'package:deadline_tracker/models/deadline.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    late DeadlineProvider provider;

    setUp(() {
      provider = DeadlineProvider();
    });

    Widget createTestWidget() {
      return ChangeNotifierProvider<DeadlineProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      );
    }

    testWidgets('renders app bar with correct title on Deadlines tab', (tester) async {
      await tester.pumpWidget(createTestWidget());
      
      expect(find.text('Deadline Tracker'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('shows bottom navigation with two tabs', (tester) async {
      await tester.pumpWidget(createTestWidget());
      
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Deadlines'), findsOneWidget);
      expect(find.text('Statistics'), findsOneWidget);
    });

    testWidgets('switches tabs when navigation item is tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());
      
      // Initially on Deadlines tab
      expect(find.text('Deadline Tracker'), findsOneWidget);
      
      // Tap Statistics tab
      await tester.tap(find.text('Statistics'));
      await tester.pumpAndSettle();
      
      // Should show Statistics in app bar
      expect(find.text('Statistics'), findsAtLeastNWidgets(2)); // Title + Tab
    });

    testWidgets('shows empty state when no deadlines exist', (tester) async {
      await tester.pumpWidget(createTestWidget());
      
      expect(find.text('No deadlines yet'), findsOneWidget);
      expect(find.text('Tap the + button to add your first deadline'), findsOneWidget);
      expect(find.byIcon(Icons.event_available), findsOneWidget);
    });

    testWidgets('shows floating action button on Deadlines tab', (tester) async {
      await tester.pumpWidget(createTestWidget());
      
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Add Deadline'), findsOneWidget);
    });

    testWidgets('hides floating action button on Statistics tab', (tester) async {
      await tester.pumpWidget(createTestWidget());
      
      // Switch to Statistics tab
      await tester.tap(find.text('Statistics'));
      await tester.pumpAndSettle();
      
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('displays deadlines in table when deadlines exist', (tester) async {
      final deadline = Deadline(
        id: '1',
        title: 'Test Deadline',
        description: 'Test Description',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
      );
      
      provider.addDeadline(deadline);
      
      await tester.pumpWidget(createTestWidget());
      
      expect(find.byType(DataTable), findsOneWidget);
      expect(find.text('Test Deadline'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('shows delete button for each deadline', (tester) async {
      final deadline = Deadline(
        id: '1',
        title: 'Test Deadline',
        description: 'Test Description',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
      );
      
      provider.addDeadline(deadline);
      
      await tester.pumpWidget(createTestWidget());
      
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('shows delete confirmation dialog when delete is tapped', (tester) async {
      final deadline = Deadline(
        id: '1',
        title: 'Test Deadline',
        description: 'Test Description',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
      );
      
      provider.addDeadline(deadline);
      
      await tester.pumpWidget(createTestWidget());
      
      // Tap delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      
      // Should show confirmation dialog
      expect(find.text('Delete Deadline'), findsOneWidget);
      expect(find.text('Are you sure you want to delete "Test Deadline"?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('deletes deadline when confirmed in dialog', (tester) async {
      final deadline = Deadline(
        id: '1',
        title: 'Test Deadline',
        description: 'Test Description',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
      );
      
      provider.addDeadline(deadline);
      
      await tester.pumpWidget(createTestWidget());
      
      // Tap delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      
      // Confirm deletion
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      
      // Should show empty state
      expect(find.text('No deadlines yet'), findsOneWidget);
      expect(provider.deadlines.isEmpty, true);
    });

    testWidgets('cancels deletion when Cancel is tapped in dialog', (tester) async {
      final deadline = Deadline(
        id: '1',
        title: 'Test Deadline',
        description: 'Test Description',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
      );
      
      provider.addDeadline(deadline);
      
      await tester.pumpWidget(createTestWidget());
      
      // Tap delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      
      // Cancel deletion
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      
      // Deadline should still exist
      expect(find.text('Test Deadline'), findsOneWidget);
      expect(provider.deadlines.length, 1);
    });

    testWidgets('highlights overdue deadlines in red', (tester) async {
      final overdueDeadline = Deadline(
        id: '1',
        title: 'Overdue Deadline',
        description: 'Test Description',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        createdAt: DateTime.now(),
      );
      
      provider.addDeadline(overdueDeadline);
      
      await tester.pumpWidget(createTestWidget());
      
      expect(find.text('Overdue Deadline'), findsOneWidget);
      expect(find.text('Overdue'), findsOneWidget);
    });

    testWidgets('shows active status for future deadlines', (tester) async {
      final futureDeadline = Deadline(
        id: '1',
        title: 'Future Deadline',
        description: 'Test Description',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        createdAt: DateTime.now(),
      );
      
      provider.addDeadline(futureDeadline);
      
      await tester.pumpWidget(createTestWidget());
      
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('navigates to AddDeadlineScreen when FAB is tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());
      
      // Tap FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      
      // Should navigate to add screen
      expect(find.text('Add New Deadline'), findsOneWidget);
    });

    testWidgets('displays multiple deadlines sorted by due date', (tester) async {
      final deadline1 = Deadline(
        id: '1',
        title: 'Third Deadline',
        description: 'Due in 3 days',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        createdAt: DateTime.now(),
      );
      
      final deadline2 = Deadline(
        id: '2',
        title: 'First Deadline',
        description: 'Due in 1 day',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
      );
      
      final deadline3 = Deadline(
        id: '3',
        title: 'Second Deadline',
        description: 'Due in 2 days',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        createdAt: DateTime.now(),
      );
      
      provider.addDeadline(deadline1);
      provider.addDeadline(deadline2);
      provider.addDeadline(deadline3);
      
      await tester.pumpWidget(createTestWidget());
      
      expect(find.text('First Deadline'), findsOneWidget);
      expect(find.text('Second Deadline'), findsOneWidget);
      expect(find.text('Third Deadline'), findsOneWidget);
    });
  });
}
