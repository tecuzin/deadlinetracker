# Deadline Tracker

![CI](https://github.com/YOUR_USERNAME/deadline-tracker/workflows/CI/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.16.0-blue.svg)](https://flutter.dev/)

A beautiful Flutter application to help you track and manage deadlines with real-time countdown.

## Features

- ✅ **Add Deadlines**: Create new deadlines with title, description, and due date/time
- 📊 **Visual Table**: View all deadlines in a clean, organized table format
- ⏰ **Remaining Time**: See exactly how much time is left for each deadline
- 🔴 **Overdue Alerts**: Overdue deadlines are highlighted in red
- 📅 **Smart Sorting**: Deadlines are automatically sorted from earliest to latest
- 🗑️ **Delete Deadlines**: Remove completed or cancelled deadlines
- 📈 **Statistics Dashboard**: Comprehensive analytics and insights
  - Overview cards showing total, active, overdue, and critical deadlines
  - Status distribution with visual progress bars
  - Time analysis with average time remaining
  - Upcoming deadlines (next 7 days) list
  - Recent activity tracker
- 🎨 **Modern UI**: Beautiful Material Design 3 interface with bottom navigation

## Screenshots

The app displays:

**Deadlines Tab:**
- A table with columns: Title, Description, Due Date, Remaining Time, Status, and Actions
- Color-coded status indicators (green for active, red for overdue)
- Real-time countdown that updates automatically
- Floating action button to add new deadlines

**Statistics Tab:**
- Overview section with key metrics (total, active, overdue, critical deadlines)
- Status distribution with percentage breakdown
- Time analysis showing average time remaining
- Upcoming deadlines for the next 7 days
- Recent activity showing deadlines created in the last week

## Installation & Setup

1. **Install Flutter** (if not already installed):
   - Follow the official Flutter installation guide: https://flutter.dev/docs/get-started/install

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run tests** (recommended before running the app):
   ```bash
   ./test_runner.sh
   # or
   flutter test
   ```

4. **Run the application**:
   
   For Android/iOS:
   ```bash
   flutter run
   ```
   
   For Web:
   ```bash
   flutter run -d chrome
   ```
   
   For Desktop (Linux/macOS/Windows):
   ```bash
   flutter run -d linux
   flutter run -d macos
   flutter run -d windows
   ```

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   └── deadline.dart              # Deadline data model
├── providers/
│   └── deadline_provider.dart     # State management
└── screens/
    ├── home_screen.dart           # Main screen with bottom navigation
    ├── add_deadline_screen.dart   # Screen to add new deadlines
    └── statistics_screen.dart     # Statistics and analytics dashboard
```

## Usage

1. **Adding a Deadline**:
   - Navigate to the "Deadlines" tab (first tab in bottom navigation)
   - Tap the "Add Deadline" floating action button
   - Fill in the title and description
   - Select the due date and time
   - Tap "Save Deadline"

2. **Viewing Deadlines**:
   - All deadlines are displayed in a table on the Deadlines tab
   - Sorted automatically from earliest to latest
   - Remaining time is calculated and displayed in real-time
   - Overdue deadlines are highlighted in red

3. **Viewing Statistics**:
   - Tap the "Statistics" tab in the bottom navigation
   - View comprehensive analytics including:
     - Total, active, overdue, and critical deadlines count
     - Status distribution with percentage breakdown
     - Average time remaining for active deadlines
     - List of upcoming deadlines (next 7 days)
     - Recent activity showing newly created deadlines

4. **Deleting a Deadline**:
   - Go to the Deadlines tab
   - Click the delete icon (trash can) in the Actions column
   - Confirm the deletion in the dialog

## Testing

This project includes comprehensive testing at multiple levels:

### Test Structure

```
test/
├── models/                    # Unit tests for data models
│   └── deadline_test.dart
├── providers/                 # Unit tests for state management
│   └── deadline_provider_test.dart
├── screens/                   # Widget tests for UI components
│   ├── home_screen_test.dart
│   ├── add_deadline_screen_test.dart
│   └── statistics_screen_test.dart
└── integration/               # Integration tests
    └── app_integration_test.dart

integration_test/
└── app_test.dart             # End-to-end tests
```

### Running Tests

**Run all tests:**
```bash
flutter test
```

**Run specific test suites:**
```bash
# Unit tests only
flutter test test/models test/providers

# Widget tests only
flutter test test/screens

# Integration tests
flutter test test/integration

# E2E tests
flutter test integration_test
```

**Run tests with coverage:**
```bash
flutter test --coverage
```

**Use the test runner script (recommended):**
```bash
./test_runner.sh
```

This script will:
- Run code formatting checks
- Run static analysis
- Execute all test suites
- Generate coverage reports
- Display results with colored output

### Test Coverage

The project aims for high test coverage across:
- **Unit Tests**: Models and business logic (Deadline, DeadlineProvider)
- **Widget Tests**: All screens and UI components
- **Integration Tests**: Complete user workflows
- **E2E Tests**: Real device/simulator testing

### Continuous Integration

All tests are automatically run on every pull request via GitHub Actions:
- Code formatting validation
- Static analysis (flutter analyze)
- Unit tests
- Integration tests
- Build verification
- Code coverage reporting

Tests must pass before PRs can be merged.

## Linting

This project uses strict linting rules defined in `analysis_options.yaml`.

**Run linter:**
```bash
flutter analyze
```

**Format code:**
```bash
dart format .
```

The linter enforces:
- Type safety
- Code style consistency
- Best practices
- Flutter-specific guidelines

## Dependencies

- **flutter**: SDK for building the app
- **provider**: State management solution
- **intl**: Internationalization and date formatting
- **integration_test**: E2E testing framework

## Technologies Used

- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language
- **Material Design 3**: Modern UI design system
- **Provider Pattern**: For state management
- **GitHub Actions**: CI/CD pipeline
- **Flutter Test**: Testing framework

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Quick Start for Contributors

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `./test_runner.sh`
5. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## Documentation

- [Testing Guide](TESTING.md) - Comprehensive testing documentation
- [Contributing Guide](CONTRIBUTING.md) - How to contribute
- [Quick Reference](QUICK_REFERENCE.md) - Common commands and workflows
- [Changelog](CHANGELOG.md) - Version history

## Future Enhancements

Potential features for future versions:
- Persistent storage (local database)
- Push notifications for upcoming deadlines
- Categories/tags for deadlines
- Search and filter functionality
- Edit existing deadlines
- Dark mode toggle
- Export deadlines to calendar
- More advanced charts and visualizations
- Deadline completion tracking
- Weekly/monthly statistics reports

## License

This project is open source and available for educational purposes.

## Acknowledgments

- Flutter team for the amazing framework
- Contributors who help improve this project
- The open-source community
