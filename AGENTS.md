# AGENTS.md

## Cursor Cloud specific instructions

This is a **Flutter (Dart) app** — the "Deadline Tracker". Standard commands live in `README.md` / `TESTING.md`; only the non-obvious cloud caveats are captured here.

### Environment
- The **Flutter 3.16.0 stable** SDK (Dart 3.2.0) is preinstalled at `~/flutter` and symlinked into `/usr/local/bin`, so `flutter` / `dart` are on `PATH` in fresh shells. This matches the version pinned in `.github/workflows/ci.yml`.
- The startup/update script only runs `flutter pub get`. Do not add SDK installation or build/run steps to it.

### Run the app (web)
- Web platform scaffolding (`web/`, `.metadata`) is committed, so the app runs without regenerating it.
- Run the dev server with: `flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0`
  - Use `-d web-server` (not `-d chrome`): there is no interactive display for Flutter to launch a browser itself. Open `http://localhost:8080` in Chrome (preinstalled) to interact with it.
  - The first load compiles the debug build and can take ~15-20s before the UI renders; be patient.
- Long-running commands (dev server) should be started in a `tmux` session so they survive across tool calls.

### Lint / test / build
- Lint: `flutter analyze` (there is one pre-existing info-level `require_trailing_commas` warning in `test/screens/add_deadline_screen_test.dart`; CI's quality-gate uses `--fatal-infos` which would flag it).
- Tests: `flutter test`. NOTE: a number of tests currently **fail on `main`** (several widget tests and time-dependent `Deadline` model tests). These are pre-existing failures in the repo, not environment problems — the test runner itself works. The `test/providers` suite passes cleanly.
- Build web: `flutter build web --release`.
