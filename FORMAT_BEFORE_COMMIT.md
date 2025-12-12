# Important: Format Code Before Committing

## Quick Fix

Before committing your changes, always run:

```bash
dart format .
```

Or if you have Flutter installed:

```bash
flutter format .
```

## Why This Matters

The CI/CD pipeline checks code formatting. If your code isn't properly formatted, some checks may warn or fail.

## Automated Formatting

A GitHub Action has been added that will automatically format your code when you push to a PR. However, it's still better practice to format locally before pushing.

## VS Code Users

Add this to your `.vscode/settings.json`:

```json
{
  "editor.formatOnSave": true,
  "[dart]": {
    "editor.formatOnSave": true
  }
}
```

## Android Studio / IntelliJ Users

1. Go to Settings/Preferences
2. Navigate to Editor → Code Style → Dart
3. Enable "Format code on save"

## Pre-commit Hook (Optional)

Create `.git/hooks/pre-commit`:

```bash
#!/bin/sh
dart format .
git add -u
```

Make it executable:

```bash
chmod +x .git/hooks/pre-commit
```
