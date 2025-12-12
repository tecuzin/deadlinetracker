# Contributing to Deadline Tracker

Thank you for your interest in contributing to Deadline Tracker! This document provides guidelines and instructions for contributing.

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the project
- Show empathy towards other contributors

## Getting Started

1. **Fork the repository**
2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/deadline-tracker.git
   cd deadline-tracker
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   ```
4. **Create a branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Workflow

### Before Making Changes

1. **Run tests**:
   ```bash
   ./test_runner.sh
   ```

2. **Ensure linter passes**:
   ```bash
   flutter analyze
   ```

### Making Changes

1. **Write code** following our style guide
2. **Add tests** for new functionality
3. **Update documentation** if needed
4. **Run tests locally**:
   ```bash
   flutter test
   ```

### Committing Changes

1. **Format your code**:
   ```bash
   dart format .
   ```

2. **Run linter**:
   ```bash
   flutter analyze
   ```

3. **Commit with a descriptive message**:
   ```bash
   git commit -m "feat: add feature X"
   ```

**Commit Message Format**:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes
- `refactor:` - Code refactoring
- `test:` - Test additions or modifications
- `chore:` - Build process or auxiliary tool changes

### Submitting a Pull Request

1. **Push your changes**:
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create a Pull Request** on GitHub

3. **Fill out the PR template** completely

4. **Wait for CI checks** to pass

5. **Address review feedback**

## Testing Requirements

All PRs must include appropriate tests:

### Test Types Required

- **Unit Tests**: For new models and business logic
- **Widget Tests**: For new UI components
- **Integration Tests**: For new features spanning multiple components
- **E2E Tests**: For critical user workflows (optional but recommended)

### Test Guidelines

- Tests must pass before PR approval
- Aim for 80%+ code coverage
- Write clear, descriptive test names
- Follow the Arrange-Act-Assert pattern
- Use appropriate test types

### Running Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/models/deadline_test.dart

# With coverage
flutter test --coverage
```

## Code Style

### Flutter/Dart Style

We follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style):

- Use `lowerCamelCase` for variables, methods, and parameters
- Use `UpperCamelCase` for classes and types
- Use `lowercase_with_underscores` for file names
- Prefer single quotes for strings
- Use trailing commas for better formatting

### Linting

Our project uses strict linting rules defined in `analysis_options.yaml`:

```bash
# Check for linting errors
flutter analyze

# Auto-fix some issues
dart fix --apply
```

### Code Formatting

Always format your code:

```bash
dart format .
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/                # Data models
├── providers/             # State management
└── screens/               # UI screens

test/
├── models/                # Unit tests for models
├── providers/             # Unit tests for providers
├── screens/               # Widget tests
└── integration/           # Integration tests

integration_test/
└── app_test.dart         # E2E tests
```

## Adding New Features

### Checklist

- [ ] Create feature branch
- [ ] Implement feature
- [ ] Add unit tests
- [ ] Add widget tests (if UI)
- [ ] Add integration tests (if needed)
- [ ] Update documentation
- [ ] Run all tests locally
- [ ] Format code
- [ ] Run linter
- [ ] Create PR
- [ ] Address review feedback

### Feature Development Process

1. **Design**: Plan your feature
2. **Model**: Create/update data models
3. **Provider**: Add state management if needed
4. **UI**: Build user interface
5. **Test**: Write comprehensive tests
6. **Document**: Update README and docs
7. **Review**: Submit for code review

## Bug Fixes

### Reporting Bugs

Include:
- Clear description
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Environment details

### Fixing Bugs

1. Create an issue (if not exists)
2. Reference issue in PR: "Fixes #123"
3. Add test that reproduces the bug
4. Fix the bug
5. Verify test passes
6. Submit PR

## Documentation

### When to Update Docs

- New features
- API changes
- Configuration changes
- Installation steps
- Usage examples

### Documentation Files

- `README.md`: Project overview and quick start
- `TESTING.md`: Testing guide
- `CONTRIBUTING.md`: This file
- Code comments: For complex logic

## CI/CD Pipeline

### Automated Checks

Every PR triggers:
1. Code formatting check
2. Static analysis
3. Unit tests
4. Integration tests
5. Build verification
6. Coverage report

### Status Checks

All checks must pass:
- ✅ Analyze Code
- ✅ Run Tests
- ✅ Integration Tests
- ✅ Build Application
- ✅ Quality Gate

### If CI Fails

1. Check the error logs
2. Fix the issue locally
3. Run tests locally
4. Push the fix
5. Wait for CI to re-run

## Code Review Process

### Review Timeline

- Initial review: Within 2-3 days
- Follow-up reviews: Within 1-2 days
- Urgent fixes: Same day

### Review Criteria

Reviewers check for:
- Code quality and style
- Test coverage
- Documentation updates
- Performance implications
- Security concerns
- Breaking changes

### Addressing Feedback

- Be responsive to comments
- Ask questions if unclear
- Make requested changes
- Mark conversations as resolved
- Request re-review when ready

## Release Process

1. Version bump in `pubspec.yaml`
2. Update CHANGELOG
3. Create release tag
4. Build artifacts
5. Deploy (if applicable)

## Getting Help

- **Questions**: Open a discussion
- **Bugs**: Create an issue
- **Features**: Propose in discussions first
- **Security**: Email maintainers directly

## Recognition

Contributors are recognized in:
- PR descriptions
- Release notes
- Contributors section

Thank you for contributing! 🎉
