import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:deadline_tracker/screens/statistics_screen.dart';
import 'package:deadline_tracker/providers/deadline_provider.dart';
import 'package:deadline_tracker/models/deadline.dart';

void main() {
  group('StatisticsScreen Widget Tests', () {
    late DeadlineProvider provider;
    late DateTime now;

    setUp(() {
      provider = DeadlineProvider();
      now = DateTime.now();
    });

    Widget createTestWidget() {
      return ChangeNotifierProvider<DeadlineProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: StatisticsScreen(),
        ),
      );
    }

    testWidgets('renders app bar with correct title', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Statistics'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('shows empty state when no deadlines exist', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('No statistics yet'), findsOneWidget);
      expect(find.text('Add some deadlines to see statistics'), findsOneWidget);
      expect(find.byIcon(Icons.bar_chart), findsOneWidget);
    });

    testWidgets('displays overview section with deadlines', (tester) async {
      final deadline = Deadline(
        id: '1',
        title: 'Test',
        description: 'Test',
        dueDate: now.add(const Duration(days: 1)),
        createdAt: now,
      );

      provider.addDeadline(deadline);

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Overdue'), findsOneWidget);
      expect(find.text('Critical'), findsOneWidget);
    });

    testWidgets('shows correct total count', (tester) async {
      provider.addDeadline(
        Deadline(
          id: '1',
          title: 'Test 1',
          description: 'Test',
          dueDate: now.add(const Duration(days: 1)),
          createdAt: now,
        ),
      );
      provider.addDeadline(
        Deadline(
          id: '2',
          title: 'Test 2',
          description: 'Test',
          dueDate: now.add(const Duration(days: 2)),
          createdAt: now,
        ),
      );

      await tester.pumpWidget(createTestWidget());

      expect(find.text('2'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows correct active count', (tester) async {
      provider.addDeadline(
        Deadline(
          id: '1',
          title: 'Active',
          description: 'Test',
          dueDate: now.add(const Duration(days: 1)),
          createdAt: now,
        ),
      );

      await tester.pumpWidget(createTestWidget());

      expect(find.text('1'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows correct overdue count', (tester) async {
      provider.addDeadline(
        Deadline(
          id: '1',
          title: 'Overdue',
          description: 'Test',
          dueDate: now.subtract(const Duration(days: 1)),
          createdAt: now,
        ),
      );

      await tester.pumpWidget(createTestWidget());

      // Scroll to see overdue section
      await tester.dragUntilVisible(
        find.text('Overdue'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );

      expect(find.text('1'), findsAtLeastNWidgets(1));
    });

    testWidgets('displays status distribution section', (tester) async {
      provider.addDeadline(
        Deadline(
          id: '1',
          title: 'Test',
          description: 'Test',
          dueDate: now.add(const Duration(days: 1)),
          createdAt: now,
        ),
      );

      await tester.pumpWidget(createTestWidget());

      // Scroll to status distribution
      await tester.dragUntilVisible(
        find.text('Status Distribution'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );

      expect(find.text('Status Distribution'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNWidgets(2));
    });

    testWidgets('displays time analysis section', (tester) async {
      provider.addDeadline(
        Deadline(
          id: '1',
          title: 'Test',
          description: 'Test',
          dueDate: now.add(const Duration(days: 1)),
          createdAt: now,
        ),
      );

      await tester.pumpWidget(createTestWidget());

      await tester.dragUntilVisible(
        find.text('Time Analysis'),
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );

      expect(find.text('Time Analysis'), findsOneWidget);
      expect(find.text('Avg. Time Left'), findsOneWidget);
      expect(find.text('Upcoming (7d)'), findsOneWidget);
    });

    testWidgets('shows upcoming deadlines section when deadlines exist',
        (tester) async {
      provider.addDeadline(
        Deadline(
          id: '1',
          title: 'Upcoming Test',
          description: 'Test',
          dueDate: now.add(const Duration(days: 2)),
          createdAt: now,
        ),
      );

      await tester.pumpWidget(createTestWidget());

      await tester.dragUntilVisible(
        find.text('Upcoming (Next 7 Days)'),
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );

      expect(find.text('Upcoming (Next 7 Days)'), findsOneWidget);
      expect(find.text('Upcoming Test'), findsOneWidget);
    });

    testWidgets('hides upcoming section when no upcoming deadlines',
        (tester) async {
      provider.addDeadline(
        Deadline(
          id: '1',
          title: 'Far Future',
          description: 'Test',
          dueDate: now.add(const Duration(days: 30)),
          createdAt: now,
        ),
      );

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Upcoming (Next 7 Days)'), findsNothing);
    });

    testWidgets('shows recent activity section when recent deadlines exist',
        (tester) async {
      provider.addDeadline(
        Deadline(
          id: '1',
          title: 'Recent Deadline',
          description: 'Test',
          dueDate: now.add(const Duration(days: 1)),
          createdAt: now.subtract(const Duration(days: 1)),
        ),
      );

      await tester.pumpWidget(createTestWidget());

      await tester.dragUntilVisible(
        find.text('Recent Activity (Last 7 Days)'),
        find.byType(SingleChildScrollView),
        const Offset(0, -400),
      );

      expect(find.text('Recent Activity (Last 7 Days)'), findsOneWidget);
    });

    testWidgets('calculates critical deadlines correctly', (tester) async {
      // Add critical deadline (within 24 hours)
      provider.addDeadline(
        Deadline(
          id: '1',
          title: 'Critical',
          description: 'Test',
          dueDate: now.add(const Duration(hours: 12)),
          createdAt: now,
        ),
      );

      // Add non-critical deadline
      provider.addDeadline(
        Deadline(
          id: '2',
          title: 'Not Critical',
          description: 'Test',
          dueDate: now.add(const Duration(days: 5)),
          createdAt: now,
        ),
      );

      await tester.pumpWidget(createTestWidget());

      // Find the Critical card
      await tester.dragUntilVisible(
        find.text('Critical'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );

      expect(find.text('1'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows percentage in status distribution', (tester) async {
      provider.addDeadline(
        Deadline(
          id: '1',
          title: 'Active',
          description: 'Test',
          dueDate: now.add(const Duration(days: 1)),
          createdAt: now,
        ),
      );

      await tester.pumpWidget(createTestWidget());

      await tester.dragUntilVisible(
        find.text('Status Distribution'),
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );

      // Should show 100% active
      expect(find.textContaining('%'), findsAtLeastNWidgets(1));
    });

    testWidgets('handles mixed active and overdue deadlines', (tester) async {
      provider.addDeadline(
        Deadline(
          id: '1',
          title: 'Active',
          description: 'Test',
          dueDate: now.add(const Duration(days: 1)),
          createdAt: now,
        ),
      );
      provider.addDeadline(
        Deadline(
          id: '2',
          title: 'Overdue',
          description: 'Test',
          dueDate: now.subtract(const Duration(days: 1)),
          createdAt: now,
        ),
      );

      await tester.pumpWidget(createTestWidget());

      expect(find.text('2'), findsAtLeastNWidgets(1)); // Total
    });

    testWidgets('limits upcoming deadlines display to 5', (tester) async {
      // Add 7 upcoming deadlines
      for (int i = 1; i <= 7; i++) {
        provider.addDeadline(
          Deadline(
            id: '$i',
            title: 'Upcoming $i',
            description: 'Test',
            dueDate: now.add(Duration(days: i)),
            createdAt: now,
          ),
        );
      }

      await tester.pumpWidget(createTestWidget());

      await tester.dragUntilVisible(
        find.text('Upcoming (Next 7 Days)'),
        find.byType(SingleChildScrollView),
        const Offset(0, -400),
      );

      // Should show max 5
      expect(find.text('Upcoming 1'), findsOneWidget);
      expect(find.text('Upcoming 5'), findsOneWidget);
      expect(find.text('Upcoming 6'), findsNothing);
      expect(find.text('Upcoming 7'), findsNothing);
    });

    testWidgets('shows correct icons for each section', (tester) async {
      provider.addDeadline(
        Deadline(
          id: '1',
          title: 'Test',
          description: 'Test',
          dueDate: now.add(const Duration(days: 1)),
          createdAt: now,
        ),
      );

      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.list_alt), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);
      expect(find.byIcon(Icons.priority_high), findsOneWidget);
    });

    testWidgets('displays all cards in overview section', (tester) async {
      provider.addDeadline(
        Deadline(
          id: '1',
          title: 'Test',
          description: 'Test',
          dueDate: now.add(const Duration(days: 1)),
          createdAt: now,
        ),
      );

      await tester.pumpWidget(createTestWidget());

      expect(
        find.byType(Card),
        findsAtLeastNWidgets(4),
      ); // At least the 4 stat cards
    });
  });
}
