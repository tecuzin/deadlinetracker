# Quick Reference Guide

## Common Commands

### Development

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Hot reload (press 'r' in terminal)
# Hot restart (press 'R' in terminal)

# Clean build
flutter clean && flutter pub get
```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/models/deadline_test.dart

# Run test suite
./test_runner.sh

# Watch mode (requires fswatch on macOS)
fswatch -o lib test | xargs -n1 -I{} flutter test
```

### Code Quality

```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Fix auto-fixable issues
dart fix --apply

# Check for outdated packages
flutter pub outdated
```

### Building

```bash
# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Build for Web
flutter build web

# Build for Desktop
flutter build linux
flutter build macos
flutter build windows
```

## File Structure

```
lib/
├── main.dart                    # Entry point
├── models/
│   └── deadline.dart            # Data model
├── providers/
│   └── deadline_provider.dart   # State management
└── screens/
    ├── home_screen.dart         # Main screen with navigation
    ├── add_deadline_screen.dart # Add deadline form
    └── statistics_screen.dart   # Analytics dashboard

test/
├── models/                      # Unit tests
├── providers/                   # Provider tests
├── screens/                     # Widget tests
└── integration/                 # Integration tests
```

## Git Workflow

```bash
# Create feature branch
git checkout -b feature/my-feature

# Make changes and commit
git add .
git commit -m "feat: add my feature"

# Push to remote
git push origin feature/my-feature

# Create PR on GitHub
```

## Commit Message Types

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `style:` Formatting
- `refactor:` Code restructuring
- `test:` Add/modify tests
- `chore:` Maintenance

## Testing Checklist

Before submitting PR:
- [ ] All tests pass (`flutter test`)
- [ ] Code formatted (`dart format .`)
- [ ] No linter errors (`flutter analyze`)
- [ ] Coverage maintained
- [ ] Tests added for new code
- [ ] Documentation updated

## Debugging

```bash
# Run with debug logging
flutter run --verbose

# Debug specific test
flutter test --plain-name="test name"

# Generate and view coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Common Issues

### Tests Failing

1. Run `flutter clean && flutter pub get`
2. Check test output for specific errors
3. Verify mocks and test data
4. Check for async issues

### Linter Errors

1. Run `dart format .` first
2. Then `flutter analyze`
3. Use `dart fix --apply` for auto-fixes
4. Manually fix remaining issues

### Build Issues

1. `flutter clean`
2. `flutter pub get`
3. Delete build folder
4. Restart IDE
5. `flutter pub cache repair` (if needed)

## Useful Resources

- [Flutter Docs](https://docs.flutter.dev/)
- [Dart API](https://api.dart.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [Testing Guide](./TESTING.md)
- [Contributing Guide](./CONTRIBUTING.md)

## Environment Setup

### Required Tools

- Flutter SDK (3.16.0+)
- Dart SDK (included with Flutter)
- IDE (VS Code or Android Studio)
- Git

### VS Code Extensions

- Flutter
- Dart
- Flutter Widget Snippets
- Bracket Pair Colorizer

### Recommended Settings

```json
{
  "editor.formatOnSave": true,
  "dart.lineLength": 80,
  "dart.showTodos": true,
  "dart.previewFlutterUiGuides": true
}
```

## Performance Tips

- Use `const` constructors where possible
- Profile with DevTools
- Avoid rebuilds with `const` widgets
- Use `ListView.builder` for long lists
- Optimize images and assets

## Quick Fixes

```bash
# Fix formatting issues
dart format .

# Update dependencies
flutter pub upgrade

# Repair pub cache
flutter pub cache repair

# Reset Flutter
flutter clean
flutter pub get
flutter doctor

# Clear derived data (macOS)
rm -rf ~/Library/Developer/Xcode/DerivedData
```

## CI/CD

### GitHub Actions

- Runs automatically on push/PR
- Checks: format, analyze, test, build
- View status in PR checks
- Fix issues before merging

### Required Checks

✅ Code formatting  
✅ Static analysis  
✅ Unit tests  
✅ Integration tests  
✅ Build succeeds  

## Support

- Issues: GitHub Issues
- Discussions: GitHub Discussions
- Documentation: /docs folder

---

**Pro Tip**: Use `./test_runner.sh` before every commit to catch issues early!
