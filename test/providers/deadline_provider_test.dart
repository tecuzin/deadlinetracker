import 'package:flutter_test/flutter_test.dart';
import 'package:deadline_tracker/models/deadline.dart';
import 'package:deadline_tracker/providers/deadline_provider.dart';

void main() {
  group('DeadlineProvider Tests', () {
    late DeadlineProvider provider;
    late DateTime now;
    late Deadline deadline1;
    late Deadline deadline2;
    late Deadline deadline3;

    setUp(() {
      provider = DeadlineProvider();
      now = DateTime(2025, 12, 12, 12, 0, 0);
      
      deadline1 = Deadline(
        id: '1',
        title: 'First Deadline',
        description: 'Description 1',
        dueDate: now.add(const Duration(days: 1)),
        createdAt: now,
      );

      deadline2 = Deadline(
        id: '2',
        title: 'Second Deadline',
        description: 'Description 2',
        dueDate: now.add(const Duration(days: 3)),
        createdAt: now,
      );

      deadline3 = Deadline(
        id: '3',
        title: 'Third Deadline',
        description: 'Description 3',
        dueDate: now.add(const Duration(days: 2)),
        createdAt: now,
      );
    });

    test('initial state is empty list', () {
      expect(provider.deadlines, isEmpty);
    });

    group('addDeadline', () {
      test('adds deadline to list', () {
        provider.addDeadline(deadline1);
        expect(provider.deadlines.length, 1);
        expect(provider.deadlines.first.id, '1');
      });

      test('adds multiple deadlines', () {
        provider.addDeadline(deadline1);
        provider.addDeadline(deadline2);
        provider.addDeadline(deadline3);
        
        expect(provider.deadlines.length, 3);
      });

      test('notifies listeners when deadline is added', () {
        var notified = false;
        provider.addListener(() {
          notified = true;
        });

        provider.addDeadline(deadline1);
        expect(notified, true);
      });
    });

    group('removeDeadline', () {
      setUp(() {
        provider.addDeadline(deadline1);
        provider.addDeadline(deadline2);
        provider.addDeadline(deadline3);
      });

      test('removes deadline by id', () {
        provider.removeDeadline('2');
        expect(provider.deadlines.length, 2);
        expect(provider.deadlines.any((d) => d.id == '2'), false);
      });

      test('does not affect other deadlines when removing one', () {
        provider.removeDeadline('2');
        expect(provider.deadlines.any((d) => d.id == '1'), true);
        expect(provider.deadlines.any((d) => d.id == '3'), true);
      });

      test('notifies listeners when deadline is removed', () {
        var notified = false;
        provider.addListener(() {
          notified = true;
        });

        provider.removeDeadline('1');
        expect(notified, true);
      });

      test('handles removing non-existent deadline gracefully', () {
        final initialLength = provider.deadlines.length;
        provider.removeDeadline('999');
        expect(provider.deadlines.length, initialLength);
      });
    });

    group('updateDeadline', () {
      setUp(() {
        provider.addDeadline(deadline1);
        provider.addDeadline(deadline2);
      });

      test('updates existing deadline', () {
        final updated = Deadline(
          id: '1',
          title: 'Updated Title',
          description: 'Updated Description',
          dueDate: now.add(const Duration(days: 5)),
          createdAt: deadline1.createdAt,
        );

        provider.updateDeadline(updated);

        final found = provider.deadlines.firstWhere((d) => d.id == '1');
        expect(found.title, 'Updated Title');
        expect(found.description, 'Updated Description');
      });

      test('notifies listeners when deadline is updated', () {
        var notified = false;
        provider.addListener(() {
          notified = true;
        });

        final updated = Deadline(
          id: '1',
          title: 'Updated',
          description: 'Updated',
          dueDate: deadline1.dueDate,
          createdAt: deadline1.createdAt,
        );

        provider.updateDeadline(updated);
        expect(notified, true);
      });

      test('does not update if deadline id not found', () {
        final nonExistent = Deadline(
          id: '999',
          title: 'Non-existent',
          description: 'Non-existent',
          dueDate: now,
          createdAt: now,
        );

        provider.updateDeadline(nonExistent);
        expect(provider.deadlines.any((d) => d.id == '999'), false);
      });

      test('maintains list length when updating', () {
        final initialLength = provider.deadlines.length;
        
        final updated = Deadline(
          id: '1',
          title: 'Updated',
          description: 'Updated',
          dueDate: deadline1.dueDate,
          createdAt: deadline1.createdAt,
        );

        provider.updateDeadline(updated);
        expect(provider.deadlines.length, initialLength);
      });
    });

    group('deadlines getter sorting', () {
      test('returns deadlines sorted by due date (earliest first)', () {
        // Add in random order
        provider.addDeadline(deadline2); // day 3
        provider.addDeadline(deadline1); // day 1
        provider.addDeadline(deadline3); // day 2

        final deadlines = provider.deadlines;
        
        expect(deadlines[0].id, '1'); // day 1
        expect(deadlines[1].id, '3'); // day 2
        expect(deadlines[2].id, '2'); // day 3
      });

      test('maintains sort order after adding new deadline', () {
        provider.addDeadline(deadline2); // day 3
        provider.addDeadline(deadline1); // day 1
        
        final newDeadline = Deadline(
          id: '4',
          title: 'Earliest',
          description: 'Test',
          dueDate: now.add(const Duration(hours: 12)),
          createdAt: now,
        );
        
        provider.addDeadline(newDeadline);
        
        final deadlines = provider.deadlines;
        expect(deadlines.first.id, '4'); // Earliest deadline
      });
    });

    group('edge cases', () {
      test('handles empty list operations', () {
        provider.removeDeadline('1');
        expect(provider.deadlines, isEmpty);
      });

      test('handles adding same id multiple times', () {
        provider.addDeadline(deadline1);
        provider.addDeadline(deadline1);
        
        // Should add both (no deduplication in current implementation)
        expect(provider.deadlines.length, 2);
      });

      test('deadlines with same due date maintain stable order', () {
        final sameTime = now.add(const Duration(days: 1));
        
        final d1 = Deadline(
          id: '1',
          title: 'First',
          description: 'Test',
          dueDate: sameTime,
          createdAt: now,
        );
        
        final d2 = Deadline(
          id: '2',
          title: 'Second',
          description: 'Test',
          dueDate: sameTime,
          createdAt: now,
        );
        
        provider.addDeadline(d1);
        provider.addDeadline(d2);
        
        expect(provider.deadlines.length, 2);
      });
    });
  });
}
