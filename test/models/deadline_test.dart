import 'package:flutter_test/flutter_test.dart';
import 'package:deadline_tracker/models/deadline.dart';

void main() {
  group('Deadline Model Tests', () {
    late DateTime now;
    late DateTime futureDate;
    late DateTime pastDate;

    setUp(() {
      now = DateTime(2025, 12, 12, 12, 0, 0);
      futureDate = now.add(const Duration(days: 2, hours: 3, minutes: 30));
      pastDate = now.subtract(const Duration(days: 1, hours: 2));
    });

    test('Deadline creation with all required fields', () {
      final deadline = Deadline(
        id: '1',
        title: 'Test Deadline',
        description: 'Test Description',
        dueDate: futureDate,
        createdAt: now,
      );

      expect(deadline.id, '1');
      expect(deadline.title, 'Test Deadline');
      expect(deadline.description, 'Test Description');
      expect(deadline.dueDate, futureDate);
      expect(deadline.createdAt, now);
    });

    group('remainingTime getter', () {
      test('returns positive duration for future deadline', () {
        final deadline = Deadline(
          id: '1',
          title: 'Future Deadline',
          description: 'Test',
          dueDate: futureDate,
          createdAt: now,
        );

        final remaining = deadline.remainingTime;
        expect(remaining.isNegative, false);
        expect(remaining.inDays, greaterThanOrEqualTo(2));
      });

      test('returns negative duration for past deadline', () {
        final deadline = Deadline(
          id: '1',
          title: 'Past Deadline',
          description: 'Test',
          dueDate: pastDate,
          createdAt: now,
        );

        final remaining = deadline.remainingTime;
        expect(remaining.isNegative, true);
      });
    });

    group('remainingTimeString getter', () {
      test('returns days and hours for deadline more than a day away', () {
        final deadline = Deadline(
          id: '1',
          title: 'Test',
          description: 'Test',
          dueDate: now.add(const Duration(days: 2, hours: 5)),
          createdAt: now,
        );

        final timeString = deadline.remainingTimeString;
        expect(timeString, contains('d'));
        expect(timeString, contains('h'));
        expect(timeString, isNot(contains('overdue')));
      });

      test('returns hours and minutes for deadline less than a day away', () {
        final deadline = Deadline(
          id: '1',
          title: 'Test',
          description: 'Test',
          dueDate: now.add(const Duration(hours: 5, minutes: 30)),
          createdAt: now,
        );

        final timeString = deadline.remainingTimeString;
        expect(timeString, contains('h'));
        expect(timeString, contains('m'));
        expect(timeString, isNot(contains('overdue')));
      });

      test('returns minutes for deadline less than an hour away', () {
        final deadline = Deadline(
          id: '1',
          title: 'Test',
          description: 'Test',
          dueDate: now.add(const Duration(minutes: 45)),
          createdAt: now,
        );

        final timeString = deadline.remainingTimeString;
        expect(timeString, '45m');
      });

      test('returns "Due now!" for imminent deadline', () {
        final deadline = Deadline(
          id: '1',
          title: 'Test',
          description: 'Test',
          dueDate: now.add(const Duration(seconds: 30)),
          createdAt: now,
        );

        final timeString = deadline.remainingTimeString;
        expect(timeString, 'Due now!');
      });

      test('returns overdue message with days for past deadline', () {
        final deadline = Deadline(
          id: '1',
          title: 'Test',
          description: 'Test',
          dueDate: now.subtract(const Duration(days: 2)),
          createdAt: now,
        );

        final timeString = deadline.remainingTimeString;
        expect(timeString, contains('overdue'));
        expect(timeString, contains('d'));
      });

      test('returns overdue message with hours for recently past deadline', () {
        final deadline = Deadline(
          id: '1',
          title: 'Test',
          description: 'Test',
          dueDate: now.subtract(const Duration(hours: 3)),
          createdAt: now,
        );

        final timeString = deadline.remainingTimeString;
        expect(timeString, contains('overdue'));
        expect(timeString, contains('h'));
      });

      test('returns "Just overdue" for recently overdue deadline', () {
        final deadline = Deadline(
          id: '1',
          title: 'Test',
          description: 'Test',
          dueDate: now.subtract(const Duration(seconds: 30)),
          createdAt: now,
        );

        final timeString = deadline.remainingTimeString;
        expect(timeString, 'Just overdue');
      });
    });

    group('isOverdue getter', () {
      test('returns false for future deadline', () {
        final deadline = Deadline(
          id: '1',
          title: 'Test',
          description: 'Test',
          dueDate: futureDate,
          createdAt: now,
        );

        expect(deadline.isOverdue, false);
      });

      test('returns true for past deadline', () {
        final deadline = Deadline(
          id: '1',
          title: 'Test',
          description: 'Test',
          dueDate: pastDate,
          createdAt: now,
        );

        expect(deadline.isOverdue, true);
      });
    });

    group('JSON serialization', () {
      test('toJson converts deadline to map correctly', () {
        final deadline = Deadline(
          id: '123',
          title: 'Test Deadline',
          description: 'Test Description',
          dueDate: futureDate,
          createdAt: now,
        );

        final json = deadline.toJson();

        expect(json['id'], '123');
        expect(json['title'], 'Test Deadline');
        expect(json['description'], 'Test Description');
        expect(json['dueDate'], futureDate.toIso8601String());
        expect(json['createdAt'], now.toIso8601String());
      });

      test('fromJson creates deadline from map correctly', () {
        final json = {
          'id': '456',
          'title': 'JSON Deadline',
          'description': 'JSON Description',
          'dueDate': futureDate.toIso8601String(),
          'createdAt': now.toIso8601String(),
        };

        final deadline = Deadline.fromJson(json);

        expect(deadline.id, '456');
        expect(deadline.title, 'JSON Deadline');
        expect(deadline.description, 'JSON Description');
        expect(deadline.dueDate, futureDate);
        expect(deadline.createdAt, now);
      });

      test('toJson and fromJson are reversible', () {
        final original = Deadline(
          id: '789',
          title: 'Original',
          description: 'Original Description',
          dueDate: futureDate,
          createdAt: now,
        );

        final json = original.toJson();
        final restored = Deadline.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.title, original.title);
        expect(restored.description, original.description);
        expect(restored.dueDate, original.dueDate);
        expect(restored.createdAt, original.createdAt);
      });
    });
  });
}
