# Flutter Cupertino

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

A Flutter package that provides native Cupertino components for iOS and macOS using platform views and platform channels. This package allows you to use authentic native UI controls in your Flutter applications, giving your app a truly native look and feel on Apple platforms.

## Installation 💻

**❗ In order to start using Flutter Cupertino you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Install via `flutter pub add`:

```sh
dart pub add flutter_cupertino
```

---

## Features ✨

This package provides the following native Cupertino components:

### FCButton

A native button widget that renders platform-specific UI components:

- **iOS**: Uses SwiftUI's native `Button` with 8 distinct button styles
- **macOS**: Uses SwiftUI's native `Button` with matching visual styles

The button automatically adapts to the platform's native look and feel while providing a consistent Flutter API.

### FCSlider

A native slider widget that provides continuous value selection:

- **iOS**: Uses SwiftUI's native `Slider`
- **macOS**: Uses SwiftUI's native `Slider`

Supports customizable track colors, thumb tint, continuous/discrete updates, and min/max value ranges.

### FCSwitchButton

A native switch/toggle widget for binary state controls:

- **iOS**: Uses SwiftUI's native `Toggle` with full accessibility support
- **macOS**: Uses SwiftUI's native `Toggle`

Features customizable on-color, optional label text, and full accessibility support.

### FCTabBar

A native tab bar widget for bottom navigation:

- **iOS**: Uses SwiftUI's native `TabView` with support for iOS 18+ features
- **macOS**: Uses SwiftUI's native tab presentation

Supports multiple tab bar styles, custom colors, badges, SF Symbols icons, and special roles (like search tabs on iOS 18+).

## Usage 🚀

### Using FCButton

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

#### Button Styles

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

#### Button Customization

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

#### Disabled Button

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

### Using FCSlider

A native slider for selecting values from a continuous range:

```dart
import 'package:flutter_cupertino/flutter_cupertino.dart';

FCSlider(
  value: 0.5,
  minimumValue: 0.0,
  maximumValue: 1.0,
  onChanged: (double value) {
    print('Slider value: $value');
  },
)
```

#### Slider Customization

```dart
FCSlider(
  value: currentValue,
  minimumValue: 0.0,
  maximumValue: 100.0,
  minimumTrackTintColor: Colors.blue,
  maximumTrackTintColor: Colors.grey,
  thumbTintColor: Colors.white,
  isContinuous: true, // Send updates while dragging
  width: 300,
  height: 44,
  onChanged: (value) {
    setState(() => currentValue = value);
  },
)
```

### Using FCSwitchButton

A native switch for binary on/off states:

```dart
import 'package:flutter_cupertino/flutter_cupertino.dart';

FCSwitchButton(
  isOn: isEnabled,
  onToggle: (bool value) {
    setState(() => isEnabled = value);
  },
)
```

#### Switch Customization

```dart
FCSwitchButton(
  label: 'Enable Notifications',
  isOn: notificationsEnabled,
  onColor: Colors.green,
  isEnabled: true,
  width: 200,
  height: 44,
  onToggle: (value) {
    setState(() => notificationsEnabled = value);
  },
)
```

### Using FCTabBar

A native tab bar for bottom navigation:

```dart
import 'package:flutter_cupertino/flutter_cupertino.dart';

FCTabBar(
  items: const [
    FCTabItem(label: 'Home', icon: 'house.fill'),
    FCTabItem(label: 'Search', role: FCTabItemRole.search),
    FCTabItem(label: 'Profile', icon: 'person.fill'),
  ],
  selectedIndex: currentIndex,
  onTabSelected: (int index) {
    setState(() => currentIndex = index);
  },
)
```

#### Tab Bar Customization

```dart
FCTabBar(
  items: const [
    FCTabItem(
      label: 'Home',
      icon: 'house.fill',
      badge: '3',
    ),
    FCTabItem(
      label: 'Search',
      role: FCTabItemRole.search,
    ),
    FCTabItem(
      label: 'Settings',
      icon: 'gear',
    ),
  ],
  selectedIndex: selectedTab,
  style: FCTabBarStyle.standard,
  backgroundColor: Colors.white,
  selectedTintColor: Colors.blue,
  unselectedTintColor: Colors.grey,
  isTranslucent: true,
  onTabSelected: (index) {
    setState(() => selectedTab = index);
  },
)
```

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
