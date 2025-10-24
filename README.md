# Flutter Cupertino

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

A Flutter package that provides native Cupertino components for iOS and macOS using platform views and platform channels.

## Installation 💻

**❗ In order to start using Flutter Cupertino you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Install via `flutter pub add`:

```sh
dart pub add flutter_cupertino
```

---

## Features ✨

### FCButton

A native button widget that renders platform-specific UI components:
- **iOS**: Uses UIKit's `UIButton`
- **macOS**: Uses AppKit's `NSButton`

The button automatically adapts to the platform's native look and feel while providing a consistent Flutter API.

## Usage 🚀

### Basic FCButton

Import the package and use the `FCButton` widget:

```dart
import 'package:flutter_cupertino/flutter_cupertino.dart';

FCButton(
  title: 'Tap Me',
  onPressed: () {
    print('Button pressed!');
  },
)
```

### Button Styles

The `FCButton` widget supports multiple native button styles through the `CNButtonStyle` enum:

```dart
// Plain style (minimal, text-only)
FCButton(
  title: 'Plain Button',
  style: CNButtonStyle.plain,
  onPressed: () {},
)

// Gray style (subtle gray background)
FCButton(
  title: 'Gray Button',
  style: CNButtonStyle.gray,
  onPressed: () {},
)

// Tinted style (tinted/filled text)
FCButton(
  title: 'Tinted Button',
  style: CNButtonStyle.tinted,
  onPressed: () {},
)

// Bordered style
FCButton(
  title: 'Bordered Button',
  style: CNButtonStyle.bordered,
  onPressed: () {},
)

// Bordered Prominent style (accent-colored border)
FCButton(
  title: 'Prominent Button',
  style: CNButtonStyle.borderedProminent,
  onPressed: () {},
)

// Filled style (default - filled background)
FCButton(
  title: 'Filled Button',
  style: CNButtonStyle.filled, // This is the default
  onPressed: () {},
)

// Glass style (translucent background with vibrancy)
FCButton(
  title: 'Glass Button',
  style: CNButtonStyle.glass,
  onPressed: () {},
)

// Prominent Glass style (more visible translucent background)
FCButton(
  title: 'Prominent Glass Button',
  style: CNButtonStyle.prominentGlass,
  onPressed: () {},
)
```

### Customization

The `FCButton` widget supports extensive customization:

```dart
FCButton(
  title: 'Custom Button',
  style: CNButtonStyle.filled,
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
  fontSize: 18,
  cornerRadius: 12,
  width: 200,
  height: 50,
  onPressed: () {
    // Handle button press
  },
)
```

### Disabled Button

Buttons can be disabled in two ways:

```dart
// Using the isEnabled property
FCButton(
  title: 'Disabled',
  isEnabled: false,
  onPressed: () {},
)

// Using null callback
FCButton(
  title: 'Disabled',
  onPressed: null,
)
```

### Examples

Check out the [example](example) directory for a complete demo app showing various button configurations:
- All 8 button styles (plain, gray, tinted, bordered, borderedProminent, filled, glass, prominentGlass)
- Custom colors with different styles
- Disabled states
- Press event handling

### Architecture

The FCButton widget uses Flutter's platform view mechanism to embed native UI components:

1. **Platform View**: Embeds native UIButton (iOS) or NSButton (macOS) into the Flutter widget tree
2. **Method Channel**: Communicates button events from native code back to Flutter
3. **Creation Parameters**: Passes styling and configuration from Flutter to native code

The implementation consists of:
- **Dart**: `FCButton` widget that wraps the platform view
- **Swift (iOS)**: `FCButtonView` and `FCButtonFactory` for UIKit integration
- **Swift (macOS)**: `FCButtonView` and `FCButtonFactory` for AppKit integration

---

## Continuous Integration 🤖

Flutter Cupertino comes with a built-in [GitHub Actions workflow][github_actions_link] powered by [Very Good Workflows][very_good_workflows_link] but you can also add your preferred CI/CD solution.

Out of the box, on each pull request and push, the CI `formats`, `lints`, and `tests` the code. This ensures the code remains consistent and behaves correctly as you add functionality or make changes. The project uses [Very Good Analysis][very_good_analysis_link] for a strict set of analysis options used by our team. Code coverage is enforced using the [Very Good Workflows][very_good_coverage_link].

---

## Running Tests 🧪

For first time users, install the [very_good_cli][very_good_cli_link]:

```sh
dart pub global activate very_good_cli
```

To run all unit tests:

```sh
very_good test --coverage
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
