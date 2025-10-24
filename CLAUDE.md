# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter package created using Very Good CLI. It follows Very Good Ventures' standards and practices, including strict linting with `very_good_analysis` and enforced code coverage requirements.

## Development Commands

### Testing

Run all tests with coverage:
```sh
very_good test --coverage
```

Run tests without coverage:
```sh
flutter test
```

Generate and view coverage report:
```sh
genhtml coverage/lcov.info -o coverage/
open coverage/index.html
```

### Analysis and Linting

Format code:
```sh
dart format .
```

Run static analysis:
```sh
flutter analyze
```

### Dependencies

Add a new dependency:
```sh
flutter pub add <package_name>
```

Add a dev dependency:
```sh
flutter pub add --dev <package_name>
```

Get dependencies:
```sh
flutter pub get
```

## Code Architecture

### Package Structure

- `lib/flutter_cupertino.dart` - Main library export file that re-exports from `src/`
- `lib/src/` - Contains implementation files
- `test/` - Mirrors the `lib/` structure for test files

### Code Quality Standards

- Uses `very_good_analysis` for strict linting rules (configured in `analysis_options.yaml`)
- Code coverage is enforced via CI (Very Good Workflows)
- All code must pass formatting, linting, and testing before merge

### CI/CD

GitHub Actions workflow (`.github/workflows/main.yaml`) runs on PRs to `main`:
- Semantic PR validation (requires conventional commit format)
- Spell checking on markdown files
- Flutter package build, format, analyze, and test with coverage enforcement

### Testing Practices

- Test files should mirror the structure of `lib/` in the `test/` directory
- Uses `mocktail` for mocking in tests
- Tests use the `flutter_test` package

## Flutter Environment

- Dart SDK: ^3.9.0
- Flutter SDK: ^3.35.0
