import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: unused_import, provides Color.toARGB32() extension
import 'package:flutter_cupertino/src/utilities.dart';

/// Tab item role options for special tab bar behaviors.
enum FCTabItemRole {
  /// Standard tab item role.
  standard,

  /// Search tab role (iOS 18+).
  /// On iOS, this uses UITabBarSystemItem.search for proper system integration.
  /// The search tab is automatically configured with a magnifying glass icon.
  search,
}

/// Represents a single tab item in the tab bar.
class FCTabItem {
  /// Creates a tab item.
  const FCTabItem({
    required this.label,
    this.icon,
    this.badge,
    this.role = FCTabItemRole.standard,
  });

  /// The label text for the tab.
  final String label;

  /// The icon for the tab.
  /// Can be an SF Symbol name (e.g., 'house.fill') or an asset name.
  /// When [role] is [FCTabItemRole.search], this is ignored and the system
  /// search icon is used instead.
  final String? icon;

  /// The badge text to display on the tab (e.g., '3' or 'New').
  final String? badge;

  /// The role of the tab item.
  /// Defaults to [FCTabItemRole.standard].
  /// On iOS 18+, setting this to [FCTabItemRole.search] creates a search tab
  /// with special system integration.
  final FCTabItemRole role;

  /// Converts this tab item to a map for platform channel communication.
  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'icon': icon,
      'badge': badge,
      'role': role.name,
    };
  }
}

/// Tab bar style options for native Cupertino tab bars.
enum FCTabBarStyle {
  /// Standard tab bar style.
  standard,

  /// Compact tab bar style (iOS only).
  compact,

  /// Scrollable tab bar style.
  scrollable,
}

/// {@template fc_tabbar}
/// A native Cupertino tab bar widget that uses platform-specific
/// implementations.
///
/// On iOS, this renders a native UITabBar.
/// On macOS, this renders a native NSSegmentedControl or tab view.
/// On other platforms, this widget is not supported.
///
/// Example:
/// ```dart
/// FCTabBar(
///   items: const [
///     CNTabItem(label: 'Home', icon: 'house.fill'),
///     CNTabItem(label: 'Search', role: CNTabItemRole.search),
///     CNTabItem(label: 'Profile', icon: 'person.fill'),
///   ],
///   selectedIndex: 0,
///   onTabSelected: (index) {
///     print('Selected tab: $index');
///   },
/// )
/// ```
/// {@endtemplate}
class FCTabBar extends StatefulWidget {
  /// {@macro fc_tabbar}
  const FCTabBar({
    required this.items,
    required this.onTabSelected,
    this.selectedIndex = 0,
    this.style = FCTabBarStyle.standard,
    this.backgroundColor,
    this.selectedTintColor,
    this.unselectedTintColor,
    this.height = 83.0,
    this.isTranslucent = true,
    super.key,
  }) : assert(
         items.length >= 2,
         'Tab bar must have at least 2 items',
       ),
       assert(
         selectedIndex >= 0 && selectedIndex < items.length,
         'selectedIndex must be within the range of items',
       );

  /// The list of tab items to display.
  final List<FCTabItem> items;

  /// Callback invoked when a tab is selected.
  /// Receives the index of the selected tab.
  final ValueChanged<int> onTabSelected;

  /// The index of the currently selected tab.
  /// Defaults to 0.
  final int selectedIndex;

  /// The style of the tab bar.
  /// Defaults to [FCTabBarStyle.standard].
  final FCTabBarStyle style;

  /// The background color of the tab bar.
  /// If null, uses the system default.
  final Color? backgroundColor;

  /// The tint color for the selected tab.
  /// If null, uses the system default (typically blue).
  final Color? selectedTintColor;

  /// The tint color for unselected tabs.
  /// If null, uses the system default (typically gray).
  final Color? unselectedTintColor;

  /// The height of the tab bar.
  /// Defaults to 83.0 (iOS tab bar height including safe area).
  /// Note: 68pt is the standard tab bar height, 83pt includes bottom safe area.
  final double height;

  /// Whether the tab bar should have a translucent background.
  /// Defaults to true.
  final bool isTranslucent;

  @override
  State<FCTabBar> createState() => _FCTabBarState();
}

class _FCTabBarState extends State<FCTabBar> {
  MethodChannel? _channel;

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    super.dispose();
  }

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel('flutter_cupertino/fc_tabbar_$id');
    _channel!.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onTabSelected') {
      final index = call.arguments as int;
      widget.onTabSelected(index);
    }
  }

  Map<String, dynamic> _getCreationParams() {
    return {
      'items': widget.items.map((item) => item.toMap()).toList(),
      'selectedIndex': widget.selectedIndex,
      'style': widget.style.name,
      'backgroundColor': widget.backgroundColor?.toARGB32(),
      'selectedTintColor': widget.selectedTintColor?.toARGB32(),
      'unselectedTintColor': widget.unselectedTintColor?.toARGB32(),
      'isTranslucent': widget.isTranslucent,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS && !Platform.isMacOS) {
      throw UnsupportedError(
        'FCTabBar is only supported on iOS and macOS platforms.',
      );
    }

    return SizedBox(
      height: widget.height,
      child: _buildPlatformView(),
    );
  }

  Widget _buildPlatformView() {
    const viewType = 'flutter_cupertino/fc_tabbar';
    final creationParams = _getCreationParams();

    if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
      );
    } else if (Platform.isMacOS) {
      return AppKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
      );
    }

    return const SizedBox.shrink();
  }
}
