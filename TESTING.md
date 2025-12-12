# Testing Guide

This document provides comprehensive information about the testing strategy and practices for the Deadline Tracker application.

## Table of Contents

1. [Testing Philosophy](#testing-philosophy)
2. [Test Structure](#test-structure)
3. [Running Tests](#running-tests)
4. [Writing Tests](#writing-tests)
5. [CI/CD Integration](#cicd-integration)
6. [Code Coverage](#code-coverage)

## Testing Philosophy

Our testing strategy follows the testing pyramid:

```
       /\
      /E2E\         <- Few, high-level tests
     /------\
    /  INT   \      <- Medium number of integration tests
   /----------\
  /    UNIT    \    <- Many, fast unit tests
 /--------------\
```

- **Unit Tests**: Test individual components in isolation
- **Widget Tests**: Test UI components and their interactions
- **Integration Tests**: Test multiple components working together
- **E2E Tests**: Test complete user workflows

## Test Structure

### Unit Tests

Located in `test/models/` and `test/providers/`

**What we test:**
- Data model behavior (Deadline)
- State management (DeadlineProvider)
- Business logic
- Data transformations (JSON serialization)

**Example:**
```dart
test('Deadline creation with all required fields', () {
  final deadline = Deadline(
    id: '1',
    title: 'Test',
    description: 'Test',
    dueDate: futureDate,
    createdAt: now,
  );
  expect(deadline.id, '1');
});
```

### Widget Tests

Located in `test/screens/`

**What we test:**
- Widget rendering
- User interactions
- Navigation
- State updates
- Form validation

**Example:**
```dart
testWidgets('shows delete confirmation dialog', (tester) async {
  await tester.pumpWidget(createTestWidget());
  await tester.tap(find.byIcon(Icons.delete));
  await tester.pumpAndSettle();
  expect(find.text('Delete Deadline'), findsOneWidget);
});
```

### Integration Tests

Located in `test/integration/`

**What we test:**
- Complete user workflows
- Multiple screens working together
- State persistence across navigation
- Real-world scenarios

**Example:**
```dart
testWidgets('Complete flow: Add -> View -> Delete', (tester) async {
  // Test the entire user journey
});
```

### E2E Tests

Located in `integration_test/`

**What we test:**
- Real device/simulator behavior
- Platform-specific features
- Performance
- Full application flow

## Running Tests

### Quick Commands

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/models/deadline_test.dart

# Run tests with verbose output
flutter test --verbose

# Run tests in a specific directory
flutter test test/models

# Run integration tests
flutter test test/integration

# Run E2E tests
flutter test integration_test
```

### Using the Test Runner Script

The recommended way to run tests:

```bash
./test_runner.sh
```

This script:
1. ✓ Cleans build artifacts
2. ✓ Installs dependencies
3. ✓ Checks code formatting
4. ✓ Runs static analysis
5. ✓ Executes all test suites
6. ✓ Generates coverage report
7. ✓ Displays results

### Watching Tests

For development, you can watch tests and re-run on changes:

```bash
# Using fswatch (macOS)
fswatch -o lib test | xargs -n1 -I{} flutter test

# Using inotifywait (Linux)
while inotifywait -r -e modify lib test; do flutter test; done
```

## Writing Tests

### Best Practices

1. **Test Naming**: Use descriptive test names
   ```dart
   // Good
   test('returns overdue message with days for past deadline', () {});
   
   // Bad
   test('test1', () {});
   ```

2. **Arrange-Act-Assert Pattern**:
   ```dart
   test('addDeadline adds deadline to list', () {
     // Arrange
     final provider = DeadlineProvider();
     final deadline = Deadline(...);
     
     // Act
     provider.addDeadline(deadline);
     
     // Assert
     expect(provider.deadlines.length, 1);
   });
   ```

3. **Use setUp and tearDown**:
   ```dart
   late DeadlineProvider provider;
   
   setUp(() {
     provider = DeadlineProvider();
   });
   
   tearDown(() {
     provider.dispose();
   });
   ```

4. **Group Related Tests**:
   ```dart
   group('DeadlineProvider Tests', () {
     group('addDeadline', () {
       test('adds deadline to list', () {});
       test('notifies listeners', () {});
     });
   });
   ```

5. **Mock External Dependencies**:
   ```dart
   // Use mocking when testing components with dependencies
   ```

### Widget Test Utilities

Create reusable test widgets:

```dart
Widget createTestWidget({Widget? child}) {
  return ChangeNotifierProvider<DeadlineProvider>.value(
    value: provider,
    child: MaterialApp(
      home: child ?? const HomeScreen(),
    ),
  );
}
```

### Test Coverage Guidelines

Aim for:
- **Unit Tests**: 90%+ coverage
- **Widget Tests**: 80%+ coverage
- **Integration Tests**: Key user flows
- **E2E Tests**: Critical paths

## CI/CD Integration

### GitHub Actions Workflows

#### Main CI Workflow (`.github/workflows/ci.yml`)

Runs on every push and PR:
- Code analysis
- Unit tests with coverage
- Integration tests
- Build verification
- Artifact upload

#### PR Validation (`.github/workflows/pr-validation.yml`)

Runs on every PR:
- Formatting checks
- Linter validation
- All test suites
- Coverage verification
- PR quality checks

### PR Requirements

All PRs must pass:
- ✓ Code formatting (`dart format`)
- ✓ Static analysis (`flutter analyze`)
- ✓ Unit tests
- ✓ Widget tests
- ✓ Integration tests
- ✓ Build succeeds

### Status Checks

GitHub will show status checks:
- ✅ Analyze Code
- ✅ Run Tests
- ✅ Integration Tests
- ✅ Build Application
- ✅ Quality Gate

## Code Coverage

### Generating Coverage Reports

```bash
# Generate coverage data
flutter test --coverage

# Generate HTML report (requires lcov)
genhtml coverage/lcov.info -o coverage/html

# View report
open coverage/html/index.html
```

### Coverage Tools

1. **Local Coverage**:
   - Use `./test_runner.sh` for automatic HTML reports

2. **CI Coverage**:
   - Automatically uploaded to Codecov
   - Available in PR comments

### Coverage Thresholds

Minimum requirements:
- Overall: 80%
- New code: 90%
- Critical paths: 100%

## Debugging Tests

### Common Issues

1. **Test Timeout**:
   ```dart
   testWidgets('my test', (tester) async {
     // ...
   }, timeout: const Timeout(Duration(seconds: 60)));
   ```

2. **Pump Issues**:
   ```dart
   await tester.pump();           // Single frame
   await tester.pumpAndSettle();  // Until animations complete
   ```

3. **Finding Widgets**:
   ```dart
   expect(find.text('Hello'), findsOneWidget);
   expect(find.byType(Button), findsNWidgets(2));
   expect(find.byKey(Key('myKey')), findsOneWidget);
   ```

### Debugging Commands

```bash
# Run single test with debugging
flutter test --plain-name="test name"

# Run with verbose output
flutter test --verbose

# Debug in IDE
# Use breakpoints and debug configuration
```

## Test Maintenance

### Regular Tasks

- [ ] Run full test suite weekly
- [ ] Update tests when features change
- [ ] Review and improve coverage monthly
- [ ] Refactor flaky tests
- [ ] Update test dependencies

### Performance

- Keep unit tests fast (< 1s each)
- Use mocks to avoid slow operations
- Parallelize where possible
- Run integration tests less frequently

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)

## Questions?

For testing questions or issues:
1. Check this guide
2. Review existing tests
3. Consult Flutter documentation
4. Ask the team

---

**Remember**: Good tests are:
- Fast
- Isolated
- Repeatable
- Self-validating
- Timely

Happy Testing! 🧪✨
